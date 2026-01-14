import 'dart:convert';

import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/notification/hourly_zekr/m_hourly_zekr.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class HourlyZekrNotificationService {
  HourlyZekrNotificationService({LocalNotificationService? notificationService})
    : _notificationService = notificationService ?? LocalNotificationService.instance;

  final LocalNotificationService _notificationService;

  static const String _enabledKey = 'hourlyZekrEnabled';
  static const String _jsonAssetPath = 'assets/json/notifictaions/hourly_notifications.json';

  List<MHourlyZekr> _azkarList = [];
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadAzkarFromJson();
      _isInitialized = true;

      final isEnabled = await this.isEnabled();
      if (isEnabled) {
        await scheduleHourlyNotifications();
      }
    } catch (error, stackTrace) {
      Constants.talker.error('Failed to initialize HourlyZekrNotificationService', error, stackTrace);
    }
  }

  Future<void> _loadAzkarFromJson() async {
    try {
      final jsonString = await rootBundle.loadString(_jsonAssetPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> azkarJson = jsonData['hourly_azkar'] as List<dynamic>;

      _azkarList = azkarJson.map((json) => MHourlyZekr.fromJson(json as Map<String, dynamic>)).toList();

      if (_azkarList.isEmpty) {
        throw Exception('Hourly azkar list is empty in JSON file');
      }

      Constants.talker.info('Loaded ${_azkarList.length} hourly azkar from JSON');
    } catch (error, stackTrace) {
      Constants.talker.error('Failed to load hourly azkar from JSON', error, stackTrace);
      _azkarList = _getDefaultAzkar();
    }
  }

  List<MHourlyZekr> _getDefaultAzkar() {
    return [
      const MHourlyZekr(id: 1, textAr: 'سبحان الله', textEn: 'Glory be to Allah'),
      const MHourlyZekr(id: 2, textAr: 'الحمد لله', textEn: 'Praise be to Allah'),
      const MHourlyZekr(id: 3, textAr: 'الله أكبر', textEn: 'Allah is the Greatest'),
      const MHourlyZekr(id: 4, textAr: 'لا إله إلا الله', textEn: 'There is no god but Allah'),
      const MHourlyZekr(id: 5, textAr: 'أستغفر الله', textEn: 'I seek forgiveness from Allah'),
    ];
  }

  Future<bool> isEnabled() async {
    final stored = DSAppConfig.getConfigValue(_enabledKey);
    if (stored == null || stored.isEmpty) return true;
    return stored.toLowerCase() == 'true';
  }

  Future<void> setEnabled(bool enabled) async {
    await DSAppConfig.setConfigValue(_enabledKey, enabled.toString());

    if (enabled) {
      await scheduleHourlyNotifications();
    } else {
      await cancelHourlyNotifications();
    }
  }

  Future<void> scheduleHourlyNotifications() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_azkarList.isEmpty) {
      Constants.talker.warning('Cannot schedule hourly zekr: azkar list is empty');
      return;
    }

    await cancelHourlyNotifications();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int scheduledCount = 0;

    final isArabic = LocalizeAndTranslate.getLanguageCode() == 'ar';

    for (int hour = 7; hour <= 23; hour++) {
      final zekr = _azkarList[hour % _azkarList.length];
      final scheduledTime = DateTime(today.year, today.month, today.day, hour, 0, 0);

      final notification = MLocalNotification(
        id: Constants.hourlyZekrNotificationId + (hour - 7),
        title: 'Remember Allah'.translated,
        body: isArabic ? zekr.textAr : zekr.textEn,
        scheduledAt: scheduledTime,
        repeatDaily: true,
        payload: {'type': 'hourly_zekr', 'zekr_id': zekr.id, 'hour': hour},
        isEnabled: true,
      );

      try {
        await _notificationService.scheduleNotification(
          notification: notification,
          androidAllowWhileIdle: true,
          channelId: 'hourly_zekr',
          channelName: 'Hourly Zekr',
          channelDescription: 'Hourly Islamic remembrance notifications',
        );
        scheduledCount++;
      } catch (error, stackTrace) {
        Constants.talker.error('Failed to schedule hourly zekr notification for hour $hour', error, stackTrace);
      }
    }

    Constants.talker.info('Scheduled $scheduledCount hourly zekr notifications (7 AM - 11 PM, daily repeat)');
  }

  Future<void> cancelHourlyNotifications() async {
    try {
      for (int i = 0; i < 17; i++) {
        await _notificationService.cancelNotification(Constants.hourlyZekrNotificationId + i);
      }
      Constants.talker.info('Cancelled all hourly zekr notifications (7 AM - 11 PM)');
    } catch (error, stackTrace) {
      Constants.talker.error('Failed to cancel hourly zekr notifications', error, stackTrace);
    }
  }

  Future<void> rescheduleIfNeeded() async {
    final isEnabled = await this.isEnabled();
    if (!isEnabled) return;

    await scheduleHourlyNotifications();
  }

  Future<void> handleNotificationResponse(Map<String, dynamic> payload) async {
    if (payload['type'] != 'hourly_zekr') return;

    final isEnabled = await this.isEnabled();
    if (!isEnabled) return;

    Constants.talker.info('Hourly zekr notification received. Scheduling next one...');
    await scheduleHourlyNotifications();
  }
}
