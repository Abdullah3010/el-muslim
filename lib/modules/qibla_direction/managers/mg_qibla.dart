import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

import '../data/models/m_qibla_location_state.dart';
import '../data/params/p_qibla_location_request.dart';

class MgQibla extends ChangeNotifier {
  MgQibla() : _deviceSupportFuture = FlutterQiblah.androidDeviceSensorSupport() {
    refreshLocationStatus();
  }

  final Future<bool?> _deviceSupportFuture;

  Future<bool?> get deviceSupportFuture => _deviceSupportFuture;

  final StreamController<MQiblaLocationState> _locationStreamController =
      StreamController<MQiblaLocationState>.broadcast();

  Stream<MQiblaLocationState> get locationStatusStream => _locationStreamController.stream;

  Future<void> refreshLocationStatus([PQiblaLocationRequest request = const PQiblaLocationRequest()]) async {
    try {
      final locationStatus = await FlutterQiblah.checkLocationStatus();
      if (locationStatus.enabled && locationStatus.status == LocationPermission.denied && request.requestPermission) {
        await FlutterQiblah.requestPermissions();
        final refreshedStatus = await FlutterQiblah.checkLocationStatus();
        _emitLocationStatus(refreshedStatus);
      } else {
        _emitLocationStatus(locationStatus);
      }
    } catch (error) {
      _locationStreamController.addError(error);
    }
  }

  void _emitLocationStatus(LocationStatus status) {
    if (_locationStreamController.isClosed) return;
    _locationStreamController.add(MQiblaLocationState(status: status));
    notifyListeners();
  }

  Future<Position?> fetchUserPosition() async {
    final status = await FlutterQiblah.checkLocationStatus();
    if (!status.enabled || status.status == LocationPermission.deniedForever) {
      return null;
    }

    if (status.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final refreshed = await FlutterQiblah.checkLocationStatus();
      if (!refreshed.enabled || refreshed.status == LocationPermission.denied) {
        return null;
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
  }
}
