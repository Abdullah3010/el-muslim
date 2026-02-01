import 'dart:async';
import 'dart:io';

import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/modules/qibla_direction/data/models/m_qibla_compass_state.dart';
import 'package:al_muslim/modules/qibla_direction/data/models/m_qibla_location_state.dart';
import 'package:al_muslim/modules/qibla_direction/data/params/p_qibla_location_request.dart';
import 'package:al_muslim/modules/qibla_direction/data/services/compass_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

class MgQibla extends ChangeNotifier {
  MgQibla() : _deviceSupportFuture = _checkDeviceSupport() {
    refreshLocationStatus();
  }

  static Future<bool?> _checkDeviceSupport() async {
    Constants.talker.info('[Qibla] Checking device support - Platform: ${Platform.operatingSystem}');
    if (Platform.isIOS) {
      Constants.talker.info('[Qibla] iOS detected - returning true for compass support');
      return true;
    }
    final result = await FlutterQiblah.androidDeviceSensorSupport();
    Constants.talker.info('[Qibla] Android sensor support result: $result');
    return result;
  }

  final Future<bool?> _deviceSupportFuture;
  CompassService? _compassService;

  Future<bool?> get deviceSupportFuture => _deviceSupportFuture;

  final StreamController<MQiblaLocationState> _locationStreamController =
      StreamController<MQiblaLocationState>.broadcast();

  /// Cached last location state for late subscribers
  MQiblaLocationState? _lastLocationState;
  MQiblaLocationState? get lastLocationState => _lastLocationState;

  Stream<MQiblaLocationState> get locationStatusStream => _locationStreamController.stream;

  Stream<MQiblaCompassState>? get compassStream => _compassService?.compassStream;

  Future<void> refreshLocationStatus([PQiblaLocationRequest request = const PQiblaLocationRequest()]) async {
    Constants.talker.info('[Qibla] refreshLocationStatus called - requestPermission: ${request.requestPermission}');
    try {
      final locationStatus = await FlutterQiblah.checkLocationStatus();
      Constants.talker.info(
        '[Qibla] Location status - enabled: ${locationStatus.enabled}, permission: ${locationStatus.status}',
      );
      if (locationStatus.enabled && locationStatus.status == LocationPermission.denied && request.requestPermission) {
        Constants.talker.info('[Qibla] Requesting location permissions...');
        await FlutterQiblah.requestPermissions();
        final refreshedStatus = await FlutterQiblah.checkLocationStatus();
        Constants.talker.info(
          '[Qibla] Refreshed status - enabled: ${refreshedStatus.enabled}, permission: ${refreshedStatus.status}',
        );
        _emitLocationStatus(refreshedStatus);
      } else {
        _emitLocationStatus(locationStatus);
      }
    } catch (error, stackTrace) {
      Constants.talker.error('[Qibla] Error in refreshLocationStatus: $error');
      Constants.talker.error('[Qibla] StackTrace: $stackTrace');
      _locationStreamController.addError(error);
    }
  }

  void _emitLocationStatus(LocationStatus status) {
    Constants.talker.info(
      '[Qibla] Emitting location status - enabled: ${status.enabled}, permission: ${status.status}',
    );
    if (_locationStreamController.isClosed) {
      Constants.talker.warning('[Qibla] Location stream controller is closed, cannot emit');
      return;
    }
    final state = MQiblaLocationState(status: status);
    _lastLocationState = state;
    _locationStreamController.add(state);
    notifyListeners();
  }

  Future<void> initializeCompass() async {
    Constants.talker.info('[Qibla] initializeCompass called');
    try {
      Constants.talker.info('[Qibla] Fetching user position...');
      final position = await fetchUserPosition();
      if (position == null) {
        Constants.talker.error('[Qibla] Failed to get user position - position is null');
        return;
      }
      Constants.talker.info('[Qibla] User position obtained - lat: ${position.latitude}, lng: ${position.longitude}');

      Constants.talker.info('[Qibla] Disposing old compass service if exists...');
      _compassService?.dispose();

      Constants.talker.info('[Qibla] Creating new CompassService...');
      _compassService = CompassService();

      Constants.talker.info('[Qibla] Initializing compass service with position...');
      await _compassService!.initialize(position);

      Constants.talker.info('[Qibla] Compass service initialized successfully');
      notifyListeners();
    } catch (e, stackTrace) {
      Constants.talker.error('[Qibla] Error initializing compass: $e');
      Constants.talker.error('[Qibla] StackTrace: $stackTrace');
    }
  }

  Future<Position?> fetchUserPosition() async {
    Constants.talker.info('[Qibla] fetchUserPosition called');
    try {
      final status = await FlutterQiblah.checkLocationStatus();
      Constants.talker.info(
        '[Qibla] fetchUserPosition - location enabled: ${status.enabled}, permission: ${status.status}',
      );

      if (!status.enabled || status.status == LocationPermission.deniedForever) {
        Constants.talker.warning('[Qibla] fetchUserPosition - returning null (disabled or denied forever)');
        return null;
      }

      if (status.status == LocationPermission.denied) {
        Constants.talker.info('[Qibla] fetchUserPosition - requesting permissions...');
        await FlutterQiblah.requestPermissions();
        final refreshed = await FlutterQiblah.checkLocationStatus();
        Constants.talker.info('[Qibla] fetchUserPosition - refreshed permission: ${refreshed.status}');
        if (!refreshed.enabled || refreshed.status == LocationPermission.denied) {
          Constants.talker.warning('[Qibla] fetchUserPosition - still denied after request');
          return null;
        }
      }

      Constants.talker.info('[Qibla] fetchUserPosition - calling Geolocator.getCurrentPosition...');
      final position = await Geolocator.getCurrentPosition();
      Constants.talker.info(
        '[Qibla] fetchUserPosition - got position: lat=${position.latitude}, lng=${position.longitude}',
      );
      return position;
    } catch (e, stackTrace) {
      Constants.talker.error('[Qibla] Error in fetchUserPosition: $e');
      Constants.talker.error('[Qibla] StackTrace: $stackTrace');
      return null;
    }
  }

  @override
  void dispose() {
    _locationStreamController.close();
    _compassService?.dispose();
    FlutterQiblah().dispose();
    super.dispose();
  }
}
