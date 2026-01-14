import 'dart:convert';

import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/ds_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class InitNotificationsService {
  factory InitNotificationsService({
    required LocalNotificationService notificationService,
    BoxNotification? boxNotification,
    DSNotification? notificationStore,
  }) {
    final resolvedBox = boxNotification ?? BoxNotification();
    return InitNotificationsService._(
      notificationService,
      resolvedBox,
      notificationStore ?? DSNotification(resolvedBox),
    );
  }

  InitNotificationsService._(this._notificationService, this._boxNotification, this._notificationStore);

  static const String assetPath = 'assets/json/notifictaions/init_notifications.json';
  static const String autoSchedulePayloadKey = 'autoSchedule';
  static const String _scheduledFlagValue = 'true';

  final LocalNotificationService _notificationService;
  final BoxNotification _boxNotification;
  final DSNotification _notificationStore;

  Future<void> scheduleInitialNotificationsIfNeeded({String assetPath = InitNotificationsService.assetPath}) async {
    final storedFlag = DSAppConfig.getConfigValue(Constants.configKeys.initNotificationsScheduled);
    if (storedFlag?.toLowerCase() == _scheduledFlagValue) return;

    await _scheduleNotifications(assetPath: assetPath);
    await DSAppConfig.setConfigValue(Constants.configKeys.initNotificationsScheduled, _scheduledFlagValue);
  }

  Future<void> resetAndRescheduleNotifications({String assetPath = InitNotificationsService.assetPath}) async {
    await _boxNotification.init();
    final notifications = await _loadNotifications(assetPath: assetPath);

    for (final notification in notifications) {
      await _notificationService.cancelNotification(notification.id);
      await _notificationStore.delete(notification.id);
    }

    await _scheduleNotifications(assetPath: assetPath);
    await DSAppConfig.setConfigValue(Constants.configKeys.initNotificationsScheduled, _scheduledFlagValue);
  }

  Future<void> _scheduleNotifications({required String assetPath}) async {
    await _boxNotification.init();
    final notifications = await _loadNotifications(assetPath: assetPath);
    for (final notification in notifications) {
      final existing = await _notificationStore.getById(notification.id);
      if (existing != null) {
        final updatedPayload = _mergedPayload(notification.payload, existing.payload);
        final updatedDeepLink = existing.deepLink ?? notification.deepLink;
        final shouldReschedule = existing.deepLink == null && updatedDeepLink != null;
        final updated = existing.copyWith(deepLink: updatedDeepLink, payload: updatedPayload);
        await _notificationStore.createUpdate(updated);
        if (shouldReschedule && existing.isEnabled) {
          await _notificationService.cancelNotification(existing.id);
          await _notificationService.scheduleNotification(notification: updated);
        }
        continue;
      }
      await _notificationService.scheduleNotification(notification: notification);
    }
  }

  Future<void> updateAzkarNotifications({required DateTime? fajrTime, required DateTime? maghribTime}) async {
    if (fajrTime == null && maghribTime == null) return;
    await _boxNotification.init();
    if (fajrTime != null) {
      await _updateAzkarNotification(
        notificationId: Constants.morningAzkarNotificationId,
        scheduledAt: fajrTime.add(const Duration(hours: 1)),
      );
    }
    if (maghribTime != null) {
      await _updateAzkarNotification(
        notificationId: Constants.eveningAzkarNotificationId,
        scheduledAt: maghribTime.subtract(const Duration(minutes: 15)),
      );
    }
  }

  Future<void> _updateAzkarNotification({required int notificationId, required DateTime scheduledAt}) async {
    final existing = await _notificationStore.getById(notificationId);
    if (existing == null) return;
    if (!_isAutoScheduleEnabled(existing.payload)) return;

    final nextSchedule = _nextDailyDateTime(scheduledAt);
    final updatedPayload = <String, dynamic>{...existing.payload, autoSchedulePayloadKey: true};
    final updated = existing.copyWith(scheduledAt: nextSchedule, repeatDaily: true, payload: updatedPayload);

    await _notificationService.cancelNotification(notificationId);
    if (!updated.isEnabled) {
      await _notificationStore.createUpdate(updated);
      return;
    }
    await _notificationService.scheduleNotification(notification: updated);
  }

  bool _isAutoScheduleEnabled(Map<String, dynamic> payload) {
    final raw = payload[autoSchedulePayloadKey];
    if (raw is bool) return raw;
    if (raw is String) return raw.toLowerCase() == 'true';
    return false;
  }

  DateTime _nextDailyDateTime(DateTime scheduledAt) {
    final now = DateTime.now();
    if (scheduledAt.isAfter(now)) return scheduledAt;
    return scheduledAt.add(const Duration(days: 1));
  }

  Future<List<MLocalNotification>> _loadNotifications({required String assetPath}) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map) return const [];
    final defaultLocale = decoded['default_locale']?.toString() ?? 'en';
    final rawNotifications = decoded['notifications'];
    if (rawNotifications is! List) return const [];

    final List<MLocalNotification> notifications = [];
    for (final raw in rawNotifications) {
      if (raw is! Map) continue;
      final map = raw.cast<String, dynamic>();
      final id = _notificationIdFor(map['id']?.toString() ?? '');
      if (id == null) continue;

      final schedule = map['schedule'] is Map ? (map['schedule'] as Map).cast<String, dynamic>() : <String, dynamic>{};
      final time = schedule['time']?.toString() ?? '';
      final scheduleType = schedule['type']?.toString().toLowerCase() ?? '';
      final day = schedule['day']?.toString().toLowerCase() ?? '';
      final repeatDaily = scheduleType == 'daily';
      final scheduledAt = scheduleType == 'weekly' ? _scheduledAtForWeeklyTime(time, day) : _scheduledAtForTime(time);
      final enabled = map['enabled'] is bool ? map['enabled'] as bool : true;

      final content = map['content'] is Map ? (map['content'] as Map).cast<String, dynamic>() : <String, dynamic>{};
      final title = _localizedValue(content['title'], defaultLocale);
      final body = _localizedValue(content['body'], defaultLocale);

      final rawPayload = map['payload'];
      final resolvedPayload = _resolvedPayload(rawPayload, id);

      notifications.add(
        MLocalNotification(
          id: id,
          title: title,
          body: body,
          scheduledAt: scheduledAt,
          repeatDaily: repeatDaily,
          payload: resolvedPayload.payload,
          deepLink: resolvedPayload.deepLink,
          isEnabled: enabled,
        ),
      );
    }

    return notifications;
  }

  DateTime _scheduledAtForTime(String time) {
    final now = DateTime.now();
    final parts = time.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  DateTime _scheduledAtForWeeklyTime(String time, String day) {
    final now = DateTime.now();
    final parts = time.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    final targetWeekday = _weekdayFromString(day);
    final currentWeekday = now.weekday;

    int daysToAdd = targetWeekday - currentWeekday;
    if (daysToAdd < 0 || (daysToAdd == 0 && now.hour >= hour)) {
      daysToAdd += 7;
    }

    final targetDate = now.add(Duration(days: daysToAdd));
    return DateTime(targetDate.year, targetDate.month, targetDate.day, hour, minute);
  }

  int _weekdayFromString(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        return DateTime.friday;
    }
  }

  String _localizedValue(dynamic raw, String defaultLocale) {
    if (raw is Map) {
      final resolvedLocale = LocalizeAndTranslate.getLanguageCode();
      final current = raw[resolvedLocale]?.toString();
      if (current != null && current.isNotEmpty) return current;
      final fallback = raw[defaultLocale]?.toString();
      if (fallback != null && fallback.isNotEmpty) return fallback;
      for (final value in raw.values) {
        final resolved = value?.toString() ?? '';
        if (resolved.isNotEmpty) return resolved;
      }
    }
    return raw?.toString() ?? '';
  }

  _ResolvedPayload _resolvedPayload(dynamic rawPayload, int notificationId) {
    Map<String, dynamic> payload = <String, dynamic>{};
    String? deepLink;
    if (rawPayload is Map) {
      final mutable = rawPayload.cast<String, dynamic>();
      final params = mutable.remove('params');
      final routeValue = mutable.remove('route') ?? mutable.remove('deepLink') ?? mutable.remove('deeplink');
      payload = Map<String, dynamic>.from(mutable);
      if (params is Map) {
        payload.addAll(params.cast<String, dynamic>());
      }
      deepLink = _resolveDeepLink(routeValue?.toString(), payload);
    }

    if (_isAutoScheduleNotification(notificationId)) {
      payload = <String, dynamic>{...payload, autoSchedulePayloadKey: true};
    }

    return _ResolvedPayload(payload: payload, deepLink: deepLink);
  }

  String? _resolveDeepLink(String? route, Map<String, dynamic> payload) {
    if (route == null || route.isEmpty) return null;
    if (route == '/azkar' || route == '/azkar/') {
      final categoryId = _azkarCategoryIdFromPayload(payload);
      if (categoryId != null) {
        return RoutesNames.azkar.zekr(categoryId);
      }
      return RoutesNames.azkar.azkarMain;
    }
    return route;
  }

  int? _azkarCategoryIdFromPayload(Map<String, dynamic> payload) {
    final raw = payload['category'] ?? payload['type'];
    if (raw == null) return null;
    if (raw is int) return raw;
    final value = raw.toString().toLowerCase().trim();
    if (value.isEmpty) return null;
    final parsed = int.tryParse(value);
    if (parsed != null) return parsed;
    switch (value) {
      case 'morning':
        return 4;
      case 'evening':
        return 2;
      case 'sleep':
        return 5;
      default:
        return null;
    }
  }

  int? _notificationIdFor(String id) {
    switch (id) {
      case 'azkar_morning':
        return Constants.morningAzkarNotificationId;
      case 'azkar_evening':
        return Constants.eveningAzkarNotificationId;
      case 'azkar_sleep':
        return Constants.sleepAzkarNotificationId;
      case 'quran_almulk':
        return Constants.almulkQuranNotificationId;
      case 'quran_albaqara':
        return Constants.albakraQuranNotificationId;
      case 'quran_alkahf':
        return Constants.alkahfQuranNotificationId;
    }
    return null;
  }

  bool _isAutoScheduleNotification(int notificationId) {
    return notificationId == Constants.morningAzkarNotificationId ||
        notificationId == Constants.eveningAzkarNotificationId;
  }

  Map<String, dynamic> _mergedPayload(Map<String, dynamic>? base, Map<String, dynamic>? existing) {
    return <String, dynamic>{...?base, ...?existing};
  }
}

class _ResolvedPayload {
  const _ResolvedPayload({required this.payload, this.deepLink});

  final Map<String, dynamic> payload;
  final String? deepLink;
}
