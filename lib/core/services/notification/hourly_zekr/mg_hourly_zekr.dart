import 'package:al_muslim/core/services/notification/hourly_zekr/hourly_zekr_notification_service.dart';
import 'package:flutter/material.dart';

class MgHourlyZekr extends ChangeNotifier {
  MgHourlyZekr({HourlyZekrNotificationService? service}) : _service = service ?? HourlyZekrNotificationService();

  final HourlyZekrNotificationService _service;

  bool _isEnabled = false;
  bool _isInitialized = false;

  bool get isEnabled => _isEnabled;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _service.initialize();
    _isEnabled = await _service.isEnabled();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> setEnabled(bool enabled) async {
    if (!_isInitialized) {
      await initialize();
    }

    _isEnabled = enabled;
    notifyListeners();

    await _service.setEnabled(enabled);
  }

  Future<void> rescheduleIfNeeded() async {
    if (!_isInitialized) {
      await initialize();
    }

    await _service.rescheduleIfNeeded();
  }
}
