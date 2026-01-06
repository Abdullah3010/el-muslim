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

  InitNotificationsService._(
    this._notificationService,
    this._boxNotification,
    this._notificationStore,
  );

  static const String assetPath = 'assets/json/notifictaions/init_notifications.json';
  static const String autoSchedulePayloadKey = 'autoSchedule';
  static const String _scheduledFlagValue = 'true';

  final LocalNotificationService _notificationService;
  final BoxNotification _boxNotification;
  final DSNotification _notificationStore;

  Future<void> scheduleInitialNotificationsIfNeeded({String assetPath = InitNotificationsService.assetPath}) async {
    final storedFlag = DSAppConfig.getConfigValue(Constants.configKeys.initNotificationsScheduled);
    if (storedFlag?.toLowerCase() == _scheduledFlagValue) return;

    await _boxNotification.init();
    final notifications = await _loadNotifications(assetPath: assetPath);
    for (final notification in notifications) {
      final existing = await _notificationStore.getById(notification.id);
      if (existing != null) continue;
      await _notificationService.scheduleNotification(notification: notification);
    }

    await DSAppConfig.setConfigValue(Constants.configKeys.initNotificationsScheduled, _scheduledFlagValue);
  }

  Future<void> updateAzkarNotifications({
    required DateTime? fajrTime,
    required DateTime? maghribTime,
  }) async {
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

  Future<void> _updateAzkarNotification({
    required int notificationId,
    required DateTime scheduledAt,
  }) async {
    final existing = await _notificationStore.getById(notificationId);
    if (existing == null) return;
    if (!_isAutoScheduleEnabled(existing.payload)) return;

    final nextSchedule = _nextDailyDateTime(scheduledAt);
    final updatedPayload = <String, dynamic>{
      ...existing.payload,
      autoSchedulePayloadKey: true,
    };
    final updated = existing.copyWith(
      scheduledAt: nextSchedule,
      repeatDaily: true,
      payload: updatedPayload,
    );

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
      final repeatDaily = scheduleType == 'daily';
      final scheduledAt = _scheduledAtForTime(time);
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
      deepLink = _resolveDeepLink(routeValue?.toString());
    }

    if (_isAutoScheduleNotification(notificationId)) {
      payload = <String, dynamic>{
        ...payload,
        autoSchedulePayloadKey: true,
      };
    }

    return _ResolvedPayload(payload: payload, deepLink: deepLink);
  }

  String? _resolveDeepLink(String? route) {
    if (route == null || route.isEmpty) return null;
    if (route == '/azkar' || route == '/azkar/') {
      return RoutesNames.azkar.azkarMain;
    }
    return route;
  }

  int? _notificationIdFor(String id) {
    switch (id) {
      case 'azkar_morning':
        return Constants.morningAzkarNotificationId;
      case 'azkar_evening':
        return Constants.eveningAzkarNotificationId;
      case 'azkar_sleep':
        return Constants.sleepAzkarNotificationId;
    }
    return null;
  }

  bool _isAutoScheduleNotification(int notificationId) {
    return notificationId == Constants.morningAzkarNotificationId ||
        notificationId == Constants.eveningAzkarNotificationId;
  }
}

class _ResolvedPayload {
  const _ResolvedPayload({required this.payload, this.deepLink});

  final Map<String, dynamic> payload;
  final String? deepLink;
}
