import 'dart:async';

import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/notification/init_notifications_service.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/ds_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MgMore extends ChangeNotifier {
  MgMore._(this._boxNotification, this._notificationService, this._dsNotification);

  factory MgMore({
    BoxNotification? boxNotification,
    LocalNotificationService? notificationService,
    DSNotification? dsNotification,
  }) {
    final resolvedBox = boxNotification ?? BoxNotification();
    return MgMore._(
      resolvedBox,
      notificationService ?? LocalNotificationService(),
      dsNotification ?? DSNotification(resolvedBox),
    );
  }

  final BoxNotification _boxNotification;
  final LocalNotificationService _notificationService;
  final DSNotification _dsNotification;

  Box<MLocalNotification> get notificationBox => _boxNotification.box;

  ValueListenable<Box<MLocalNotification>> notificationListenable(int notificationId) =>
      _boxNotification.box.listenable(keys: [notificationId]);

  MLocalNotification? notificationFor(int notificationId) => notificationBox.get(notificationId);

  Future<void> toggleNotification({
    required int notificationId,
    required bool enable,
    required TimeOfDay defaultTime,
  }) async {
    final existing = notificationFor(notificationId);
    if (enable) {
      final initialTime = _timeOfDayFrom(existing) ?? defaultTime;
      final scheduledAt = _nextDailyTime(initialTime);
      final meta = _notificationMeta(notificationId);
      final baseNotification = existing ?? _buildNotification(notificationId, meta, scheduledAt);
      final updatedPayload = _applyAutoScheduleOverride(notificationId, baseNotification.payload, true);
      final notification = baseNotification.copyWith(
        scheduledAt: scheduledAt,
        isEnabled: true,
        payload: updatedPayload,
      );
      await _notificationService.scheduleNotification(notification: notification);
      return;
    }

    await _notificationService.cancelNotification(notificationId);
    await _dsNotification.setEnabled(notificationId, false);
  }

  Future<void> updateNotificationTime({
    required int notificationId,
    required TimeOfDay selectedTime,
    required TimeOfDay defaultTime,
  }) async {
    final existing = notificationFor(notificationId);
    final scheduledAt = _nextDailyTime(selectedTime);
    final meta = _notificationMeta(notificationId);
    final baseNotification = existing ?? _buildNotification(notificationId, meta, scheduledAt);
    final updatedPayload = _applyAutoScheduleOverride(notificationId, baseNotification.payload, false);
    final notification = baseNotification.copyWith(
      scheduledAt: scheduledAt,
      isEnabled: existing?.isEnabled ?? true,
      payload: updatedPayload,
    );
    await _notificationService.scheduleNotification(notification: notification);
  }

  String formatNotificationTimeLabel(int notificationId, TimeOfDay defaultTime) {
    final scheduledAt = notificationFor(notificationId)?.scheduledAt ?? _nextDailyTime(defaultTime);
    return _formatTime(scheduledAt);
  }

  TimeOfDay? _timeOfDayFrom(MLocalNotification? notification) {
    if (notification == null) return null;
    return TimeOfDay(hour: notification.scheduledAt.hour, minute: notification.scheduledAt.minute);
  }

  DateTime _nextDailyTime(TimeOfDay time) {
    final now = DateTime.now();
    var scheduled = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  String _formatTime(DateTime dateTime) {
    final hourOfPeriod = dateTime.hour % 12;
    final hour = hourOfPeriod == 0 ? 12 : hourOfPeriod;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  MLocalNotification _buildNotification(int notificationId, _NotificationMeta meta, DateTime scheduledAt) {
    return MLocalNotification(
      id: notificationId,
      title: meta.title,
      body: meta.body,
      scheduledAt: scheduledAt,
      repeatDaily: true,
      payload: meta.payload,
      deepLink: meta.deepLink,
    );
  }

  Map<String, dynamic> _applyAutoScheduleOverride(int notificationId, Map<String, dynamic> payload, bool autoSchedule) {
    if (!_isAzkarAutoSchedule(notificationId)) return payload;
    final raw = payload[InitNotificationsService.autoSchedulePayloadKey];
    if (autoSchedule && raw is bool && raw == false) {
      return payload;
    }
    if (autoSchedule && raw is String && raw.toLowerCase() == 'false') {
      return payload;
    }
    return <String, dynamic>{...payload, InitNotificationsService.autoSchedulePayloadKey: autoSchedule};
  }

  bool _isAzkarAutoSchedule(int notificationId) {
    return notificationId == Constants.morningAzkarNotificationId ||
        notificationId == Constants.eveningAzkarNotificationId;
  }

  _NotificationMeta _notificationMeta(int notificationId) {
    switch (notificationId) {
      case Constants.morningAzkarNotificationId:
        return _NotificationMeta(
          title: 'Morning Adhkar Alarm'.translated,
          body: 'Morning Adhkar Alarm'.translated,
          payload: {'type': 'morning_adhkar'},
          deepLink: RoutesNames.azkar.azkarMain,
        );
      case Constants.eveningAzkarNotificationId:
        return _NotificationMeta(
          title: 'Evening Adhkar Alarm'.translated,
          body: 'Evening Adhkar Alarm'.translated,
          payload: {'type': 'evening_adhkar'},
          deepLink: RoutesNames.azkar.azkarMain,
        );
      case Constants.almulkQuranNotificationId:
        final isArabic = LocalizeAndTranslate.getLanguageCode() == 'ar';
        return _NotificationMeta(
          title: isArabic ? 'منبه سورة الملك' : 'Surah Al-Mulk Alarm',
          body:
              isArabic
                  ? 'لا تنسَ قراءة سورة الملك قبل النوم، فهي المنجية من عذاب القبر.'
                  : 'Remember to recite Surah Al-Mulk before sleeping — it protects from the punishment of the grave.',
          payload: {'surah': 'al_mulk', 'surahNumber': 67},
          deepLink: RoutesNames.quran.quranMain,
        );
      case Constants.albakraQuranNotificationId:
        final isArabic = LocalizeAndTranslate.getLanguageCode() == 'ar';
        return _NotificationMeta(
          title: isArabic ? 'منبه سورة البقرة' : 'Surah Al-Baqara Alarm',
          body:
              isArabic
                  ? 'قراءة سورة البقرة( إن لكل شيء سناما، وإن سنام القرآن البقرة، وإن من قرأها في بيته ليلة لم يدخله الشيطان 3 ليال)'
                  : 'Reciting Surah Al-Baqara brings blessings; neglecting it brings regret and falsehood cannot overcome it.',
          payload: {'surah': 'al_baqara', 'surahNumber': 2},
          deepLink: RoutesNames.quran.quranMain,
        );
      default:
        throw ArgumentError('Notification meta is not defined for id=$notificationId');
    }
  }
}

class _NotificationMeta {
  const _NotificationMeta({required this.title, required this.body, required this.deepLink, this.payload = const {}});

  final String title;
  final String body;
  final String deepLink;
  final Map<String, dynamic> payload;
}
