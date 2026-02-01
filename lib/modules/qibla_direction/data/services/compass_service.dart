import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/modules/qibla_direction/data/models/m_qibla_compass_state.dart';
import 'package:al_muslim/modules/qibla_direction/data/services/qibla_calculation_service.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

/// Service for handling compass sensor data with magnetic declination correction.
/// Converts Magnetic North to True North for accurate Qibla direction.
class CompassService {
  CompassService();

  StreamSubscription<QiblahDirection>? _compassSubscription;
  final StreamController<MQiblaCompassState> _stateController = StreamController<MQiblaCompassState>.broadcast();

  Stream<MQiblaCompassState> get compassStream => _stateController.stream;

  double _qiblaBearing = 0;
  double _magneticDeclination = 0;
  bool _isInitialized = false;

  /// Low-pass filter alpha for smooth sensor updates
  static const double _smoothingAlpha = 0.15;
  double _smoothedHeading = 0;
  bool _hasInitialHeading = false;

  /// iOS-specific: tracking for stream health
  DateTime? _lastDataReceived;
  bool _hasReceivedData = false;
  Timer? _iosStreamCheckTimer;

  /// Initialize compass with user's position for Qibla calculation
  Future<void> initialize(Position position) async {
    Constants.talker.info(
      '[CompassService] initialize called with lat: ${position.latitude}, lng: ${position.longitude}',
    );

    _qiblaBearing = QiblaCalculationService.calculateQiblaBearing(position.latitude, position.longitude);
    Constants.talker.info('[CompassService] Calculated Qibla bearing: $_qiblaBearing°');

    _magneticDeclination = _calculateMagneticDeclination(position.latitude, position.longitude);
    Constants.talker.info('[CompassService] Magnetic declination: $_magneticDeclination°');

    _isInitialized = true;
    Constants.talker.info('[CompassService] Starting compass stream...');
    _startCompassStream();
  }

  void _startCompassStream() {
    Constants.talker.info('[CompassService] _startCompassStream called');
    _compassSubscription?.cancel();

    Constants.talker.info('[CompassService] Subscribing to FlutterQiblah.qiblahStream...');

    // iOS-specific: Add timeout to detect if stream is not emitting
    if (Platform.isIOS) {
      Constants.talker.info('[CompassService] iOS detected - setting up stream timeout check');
      _setupIOSStreamCheck();
    }

    _compassSubscription = FlutterQiblah.qiblahStream.listen(
      (data) {
        _lastDataReceived = DateTime.now();
        _hasReceivedData = true;

        // iOS: Check for invalid heading (-1 means no heading available)
        if (data.direction < 0) {
          Constants.talker.warning('[CompassService] iOS: Invalid heading received (${data.direction}), skipping');
          return;
        }

        Constants.talker.debug('[CompassService] Received compass data - direction: ${data.direction}');
        _onCompassUpdate(data);
      },
      onError: (error, stackTrace) {
        Constants.talker.error('[CompassService] Compass stream error: $error');
        Constants.talker.error('[CompassService] StackTrace: $stackTrace');
        _stateController.addError(error);
      },
      onDone: () {
        Constants.talker.warning('[CompassService] Compass stream completed (onDone)');
        // iOS: Try to restart stream if it closes unexpectedly
        if (Platform.isIOS && _isInitialized) {
          Constants.talker.info('[CompassService] iOS: Attempting to restart compass stream...');
          Future.delayed(const Duration(milliseconds: 500), _startCompassStream);
        }
      },
    );
    Constants.talker.info('[CompassService] Compass stream subscription created');
  }

  void _setupIOSStreamCheck() {
    _iosStreamCheckTimer?.cancel();
    _iosStreamCheckTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isInitialized) {
        timer.cancel();
        return;
      }

      if (!_hasReceivedData) {
        Constants.talker.warning('[CompassService] iOS: No compass data received yet after ${timer.tick * 3} seconds');
        if (timer.tick >= 3) {
          Constants.talker.error('[CompassService] iOS: Compass stream appears stuck - attempting restart');
          _compassSubscription?.cancel();
          Future.delayed(const Duration(milliseconds: 200), _startCompassStream);
          timer.cancel();
        }
      } else {
        final timeSinceLastData = DateTime.now().difference(_lastDataReceived!);
        if (timeSinceLastData.inSeconds > 5) {
          Constants.talker.warning(
            '[CompassService] iOS: No data for ${timeSinceLastData.inSeconds}s - stream may be stalled',
          );
        }
      }
    });
  }

  void _onCompassUpdate(QiblahDirection qiblahDirection) {
    if (!_isInitialized) {
      Constants.talker.warning('[CompassService] _onCompassUpdate called but not initialized');
      return;
    }

    double magneticHeading = qiblahDirection.direction;
    double trueHeading = _convertToTrueNorth(magneticHeading);
    trueHeading = _applyLowPassFilter(trueHeading);

    final double offset = QiblaCalculationService.calculateOffset(_qiblaBearing, trueHeading);
    final bool isFacingQibla = QiblaCalculationService.isFacingQibla(offset);
    final QiblaRotationDirection rotationDirection = QiblaCalculationService.getRotationDirection(offset);

    final state = MQiblaCompassState(
      deviceHeading: trueHeading,
      qiblaBearing: _qiblaBearing,
      offset: offset,
      isFacingQibla: isFacingQibla,
      rotationDirection: rotationDirection,
      magneticDeclination: _magneticDeclination,
    );

    if (!_stateController.isClosed) {
      _stateController.add(state);
    } else {
      Constants.talker.warning('[CompassService] State controller is closed, cannot emit state');
    }
  }

  /// Convert magnetic heading to true heading using magnetic declination
  double _convertToTrueNorth(double magneticHeading) {
    double trueHeading = magneticHeading + _magneticDeclination;
    return (trueHeading + 360) % 360;
  }

  /// Apply low-pass filter for smooth heading transitions
  double _applyLowPassFilter(double newHeading) {
    if (!_hasInitialHeading) {
      _smoothedHeading = newHeading;
      _hasInitialHeading = true;
      return newHeading;
    }

    double delta = newHeading - _smoothedHeading;
    if (delta > 180) delta -= 360;
    if (delta < -180) delta += 360;

    _smoothedHeading = (_smoothedHeading + _smoothingAlpha * delta + 360) % 360;
    return _smoothedHeading;
  }

  /// Calculate approximate magnetic declination based on location.
  /// Uses simplified World Magnetic Model approximation.
  ///
  /// For production, consider using a proper WMM library or API.
  double _calculateMagneticDeclination(double latitude, double longitude) {
    Constants.talker.info('[CompassService] Calculating magnetic declination for lat: $latitude, lng: $longitude');
    final double latRad = latitude * pi / 180;
    final double lonRad = longitude * pi / 180;

    double declination = -6.5 * cos(latRad) * sin(lonRad - 1.0) + 2.5 * sin(2 * latRad);
    declination = declination.clamp(-30.0, 30.0);

    Constants.talker.info('[CompassService] Magnetic declination calculated: $declination°');
    return declination;
  }

  void dispose() {
    Constants.talker.info('[CompassService] dispose called');
    _iosStreamCheckTimer?.cancel();
    _compassSubscription?.cancel();
    _stateController.close();
    Constants.talker.info('[CompassService] disposed successfully');
  }
}
