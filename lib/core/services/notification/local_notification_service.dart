import 'dart:convert';

import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/ds_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

typedef NotificationPayloadHandler = Future<void> Function(Map<String, dynamic> payload);

abstract class NotificationPreferences {
  Future<void> setEnabled(bool enabled);

  Future<bool> isEnabled();
}

class HiveNotificationPreferences implements NotificationPreferences {
  static const String _enabledKey = 'localNotificationsEnabled';

  @override
  Future<bool> isEnabled() async {
    final stored = DSAppConfig.getConfigValue(_enabledKey);
    if (stored == null || stored.isEmpty) return true;
    return stored.toLowerCase() == 'true';
  }

  @override
  Future<void> setEnabled(bool enabled) async {
    await DSAppConfig.setConfigValue(_enabledKey, enabled.toString());
  }
}

abstract class DeepLinkNavigator {
  Future<void> navigate(String deepLink, Map<String, dynamic> payload);
}

class ModularDeepLinkNavigator implements DeepLinkNavigator {
  @override
  Future<void> navigate(String deepLink, Map<String, dynamic> payload) async {
    if (deepLink.isEmpty) return;

    try {
      Modular.to.pushNamed(deepLink, arguments: payload);
    } catch (error, stackTrace) {
      Constants.talker.error('Failed to navigate deep link: $deepLink', error, stackTrace);
    }
  }
}

class LocalNotificationService {
  factory LocalNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    NotificationPreferences? preferences,
    DeepLinkNavigator? deepLinkNavigator,
    BoxNotification? boxNotification,
    DSNotification? notificationStore,
  }) {
    return _instance ??= LocalNotificationService._(
      plugin ?? FlutterLocalNotificationsPlugin(),
      preferences ?? HiveNotificationPreferences(),
      deepLinkNavigator ?? ModularDeepLinkNavigator(),
      boxNotification ?? BoxNotification(),
      notificationStore,
    );
  }

  LocalNotificationService._(
    this._plugin,
    this._preferences,
    this._deepLinkNavigator,
    this._boxNotification,
    DSNotification? notificationStore,
  ) : _notificationStore = notificationStore ?? DSNotification(_boxNotification);

  static LocalNotificationService get instance => _instance ?? LocalNotificationService();
  static LocalNotificationService? _instance;

  final FlutterLocalNotificationsPlugin _plugin;
  final NotificationPreferences _preferences;
  final BoxNotification _boxNotification;
  final DSNotification _notificationStore;
  DeepLinkNavigator _deepLinkNavigator;
  NotificationPayloadHandler? _payloadHandler;
  bool _initialized = false;
  bool _notificationBoxReady = false;

  static const String _defaultChannelId = 'al_muslim_local_notifications';
  static const String _defaultChannelName = 'Al Muslim Alerts';
  static const String _defaultChannelDescription = 'Scheduled reminders and alarms';

  Future<void> initialize({
    String? androidDefaultIcon,
    String? timeZoneName,
    NotificationPayloadHandler? onPayloadReceived,
    DeepLinkNavigator? deepLinkNavigator,
    bool requestPermissions = true,
  }) async {
    if (_initialized) return;
    _payloadHandler = onPayloadReceived ?? _payloadHandler;
    _deepLinkNavigator = deepLinkNavigator ?? _deepLinkNavigator;

    await _ensureNotificationStoreReady();
    await _configureTimeZone(timeZoneName: timeZoneName);
    if (requestPermissions) {
      await _requestPermissions();
    }

    final androidSettings = AndroidInitializationSettings(androidDefaultIcon ?? '@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _initialized = true;
  }

  Future<void> handleInitialNotificationIfPresent() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    final response = details?.notificationResponse;
    if (details?.didNotificationLaunchApp ?? false) {
      if (response != null) {
        await handleNotificationResponse(response);
      }
    }
  }

  Future<void> setNotificationsEnabled(bool enabled, {bool cancelScheduled = true}) async {
    await _preferences.setEnabled(enabled);
    if (!enabled && cancelScheduled) {
      await _plugin.cancelAll();
    }
  }

  Future<void> enableNotifications() => setNotificationsEnabled(true);

  Future<void> disableNotifications({bool cancelScheduled = true}) =>
      setNotificationsEnabled(false, cancelScheduled: cancelScheduled);

  Future<bool> isNotificationsEnabled() => _preferences.isEnabled();

  Future<void> scheduleNotification({
    required MLocalNotification notification,
    bool androidAllowWhileIdle = true,
    String? channelId,
    String? channelName,
    String? channelDescription,
  }) async {
    _ensureInitialized();
    await _ensureNotificationStoreReady();

    if (!await _preferences.isEnabled()) {
      Constants.talker.info('Notifications disabled. Skipping schedule for id: ${notification.id}');
      return;
    }

    final notificationDate = _nextValidDateTime(notification.scheduledAt, repeatDaily: notification.repeatDaily);
    final encodedPayload = _encodePayload(notification.payload, notification.deepLink);

    await _plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      _toTimeZoneDate(notificationDate),
      _buildNotificationDetails(
        channelId: channelId,
        channelName: channelName,
        channelDescription: channelDescription,
      ),
      payload: encodedPayload,
      androidAllowWhileIdle: androidAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: notification.repeatDaily ? DateTimeComponents.time : null,
    );

    await _notificationStore.createUpdate(notification);
  }

  Future<void> cancelNotification(int id) async {
    _ensureInitialized();
    await _plugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    _ensureInitialized();
    await _plugin.cancelAll();
  }

  Future<void> handleNotificationResponse(NotificationResponse response) async {
    final payload = _decodePayload(response.payload);
    await handlePayload(payload);
  }

  Future<void> handlePayload(Map<String, dynamic> payload) async {
    if (payload.isEmpty) return;

    if (_payloadHandler != null) {
      await _payloadHandler!(payload);
    }

    final deepLink = _extractDeepLink(payload);
    if (deepLink != null && deepLink.isNotEmpty) {
      await _deepLinkNavigator.navigate(deepLink, payload);
    }
  }

  void registerPayloadHandler(NotificationPayloadHandler handler) {
    _payloadHandler = handler;
  }

  void setDeepLinkNavigator(DeepLinkNavigator navigator) {
    _deepLinkNavigator = navigator;
  }

  DateTime nextInstanceOf(TimeOfDay time, {DateTime? reference}) {
    final now = reference ?? DateTime.now();
    final scheduled = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (scheduled.isAfter(now)) return scheduled;
    return scheduled.add(const Duration(days: 1));
  }

  NotificationDetails _buildNotificationDetails({
    String? channelId,
    String? channelName,
    String? channelDescription,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId ?? _defaultChannelId,
        channelName ?? _defaultChannelName,
        channelDescription: channelDescription ?? _defaultChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        enableLights: true,
        enableVibration: true,
        playSound: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  tz.TZDateTime _toTimeZoneDate(DateTime dateTime) => tz.TZDateTime.from(dateTime, tz.local);

  DateTime _nextValidDateTime(DateTime scheduledAt, {required bool repeatDaily}) {
    final now = DateTime.now();
    if (scheduledAt.isAfter(now) || !repeatDaily) return scheduledAt;
    return scheduledAt.add(const Duration(days: 1));
  }

  String _encodePayload(Map<String, dynamic> payload, String? deepLink) {
    final data = <String, dynamic>{...payload};
    if (deepLink != null && deepLink.isNotEmpty) {
      data['deepLink'] = deepLink;
    }
    return jsonEncode(data);
  }

  Map<String, dynamic> _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return {};
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    } catch (error, stackTrace) {
      Constants.talker.error('Failed to decode notification payload', error, stackTrace);
    }
    return {};
  }

  String? _extractDeepLink(Map<String, dynamic> payload) {
    for (final key in ['deepLink', 'deeplink', 'route']) {
      final value = payload[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  Future<void> _configureTimeZone({String? timeZoneName}) async {
    tz.initializeTimeZones();

    final abbreviationMap = <String, String>{
      'EET': 'Africa/Cairo',
      'EST': 'America/New_York',
      'EDT': 'America/New_York',
      'PST': 'America/Los_Angeles',
      'PDT': 'America/Los_Angeles',
      'CST': 'America/Chicago',
      'CDT': 'America/Chicago',
      'GMT': 'Etc/GMT',
      'UTC': 'Etc/UTC',
      'IST': 'Asia/Kolkata',
    };

    final derivedName = DateTime.now().timeZoneName;
    final candidates = <String>[
      if (timeZoneName != null && timeZoneName.isNotEmpty) timeZoneName,
      if (derivedName.isNotEmpty) derivedName,
      if (abbreviationMap.containsKey(derivedName)) abbreviationMap[derivedName]!,
      'Africa/Cairo', // safe fallback for common EET devices
      'Etc/UTC',
    ];

    for (final name in candidates) {
      try {
        tz.setLocalLocation(tz.getLocation(name));
        return;
      } catch (_) {
        continue;
      }
    }

    // Final fallback
    Constants.talker.error('Failed to configure time zone, fallback to UTC');
    tz.setLocalLocation(tz.getLocation('Etc/UTC'));
  }

  Future<void> _requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  void _ensureInitialized() {
    if (_initialized) return;
    throw StateError('Call LocalNotificationService.initialize before using notifications');
  }

  Future<void> _ensureNotificationStoreReady() async {
    if (_notificationBoxReady) return;
    await _boxNotification.init();
    _notificationBoxReady = true;
  }

  static Future<void> _onNotificationResponse(NotificationResponse response) async {
    await LocalNotificationService.instance.handleNotificationResponse(response);
  }
}

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  await LocalNotificationService.instance.handleNotificationResponse(response);
}
