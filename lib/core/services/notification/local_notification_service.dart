import 'dart:convert';
import 'dart:io';

import 'package:al_muslim/core/config/box_app_config/box_app_config.dart';
import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/ds_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
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
  bool _isNavigating = false;

  @override
  Future<void> navigate(String deepLink, Map<String, dynamic> payload) async {
    if (deepLink.isEmpty) return;
    if (_isNavigating) return;

    _isNavigating = true;
    try {
      final resolvedDeepLink = _resolveDeepLink(deepLink, payload);
      Constants.talker.info('Navigating to deep link: $resolvedDeepLink (original: $deepLink)');
      Modular.to.pushNamed(resolvedDeepLink, arguments: payload);
    } catch (error, stackTrace) {
      Constants.talker.error('Failed to navigate deep link: $deepLink', error, stackTrace);
      _navigateToFallback();
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        _isNavigating = false;
      });
    }
  }

  String _resolveDeepLink(String deepLink, Map<String, dynamic> payload) {
    // if (deepLink == RoutesNames.werd.werdDetails && payload['planId'] != null) {
    //   return RoutesNames.werd.werdMain;
    // }

    // // Fix legacy incorrect azkar deep links: /zekr/* -> /azkar/zekr/*
    // if (deepLink.startsWith('/zekr/') && !deepLink.startsWith('/azkar/')) {
    //   final categoryId = deepLink.replaceFirst('/zekr/', '');
    //   final parsed = int.tryParse(categoryId);
    //   if (parsed != null) {
    //     return RoutesNames.azkar.zekr(parsed);
    //   }
    // }

    // // Handle category-based fallback for azkar
    // if (deepLink == '/azkar' || deepLink == '/azkar/') {
    //   final categoryId = _azkarCategoryIdFromPayload(payload);
    //   if (categoryId != null) {
    //     return RoutesNames.azkar.zekr(categoryId);
    //   }
    //   return RoutesNames.azkar.azkarMain;
    // }

    return deepLink;
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
      case 'morning_adhkar':
        return 4;
      case 'evening':
      case 'evening_adhkar':
        return 2;
      case 'sleep':
        return 5;
      default:
        return null;
    }
  }

  void _navigateToFallback() {
    try {
      Modular.to.pushNamed('/');
    } catch (_) {}
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
  bool _exactSchedulingAvailable = true;
  bool _allowPermissionRequests = true;

  static String? _pendingDeepLink;
  static Map<String, dynamic>? _pendingPayload;

  static bool get hasPendingNavigation => _pendingDeepLink != null && _pendingDeepLink!.isNotEmpty;
  static String? get pendingDeepLink => _pendingDeepLink;
  static Map<String, dynamic>? get pendingPayload => _pendingPayload;

  static void clearPendingNavigation() {
    _pendingDeepLink = null;
    _pendingPayload = null;
  }

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
    _allowPermissionRequests = requestPermissions;
    _payloadHandler = onPayloadReceived ?? _payloadHandler;
    _deepLinkNavigator = deepLinkNavigator ?? _deepLinkNavigator;

    await _ensureNotificationStoreReady();
    await _configureTimeZone(timeZoneName: timeZoneName);
    if (requestPermissions) {
      await _requestPermissions();
    } else {
      await _refreshExactSchedulingCapability();
    }

    final androidSettings = AndroidInitializationSettings(androidDefaultIcon ?? 'launcher_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    try {
      final result = await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
      Constants.talker.info('LocalNotificationService initialized: $result');
    } catch (e) {
      debugPrint('=>>>>>>>>> Notification Initialization Error: $e');
    }

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

  Future<void> handlePendingNotificationIfPresent() async {
    final storedPayload = DSAppConfig.getConfigValue(Constants.configKeys.pendingNotificationPayload);
    if (storedPayload == null || storedPayload.isEmpty) return;
    await DSAppConfig.setConfigValue(Constants.configKeys.pendingNotificationPayload, '');
    final payload = _decodePayload(storedPayload);
    await handlePayload(payload);
  }

  Future<void> storePendingNotificationPayload(String? payload) async {
    if (payload == null || payload.isEmpty) return;
    await _ensureAppConfigReady();
    await DSAppConfig.setConfigValue(Constants.configKeys.pendingNotificationPayload, payload);
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
    final canProceed = await _ensurePermissionsBeforeSchedule();
    if (!canProceed) {
      Constants.talker.warning('Skipping notification ${notification.id} because OS permissions are disabled');
      return;
    }
    final androidScheduleMode = _resolveScheduleMode(androidAllowWhileIdle);

    if (!_exactSchedulingAvailable) {
      Constants.talker.warning(
        'Exact alarm permission unavailable. Scheduling notification ${notification.id} as inexact, delivery may be delayed.',
      );
    }

    try {
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
        androidScheduleMode: androidScheduleMode,
        matchDateTimeComponents: notification.repeatDaily ? DateTimeComponents.time : null,
      );
    } catch (error, stackTrace) {
      // If exact scheduling was requested but rejected by the OS, fall back to inexact once.
      final fallbackMode =
          androidAllowWhileIdle ? AndroidScheduleMode.inexactAllowWhileIdle : AndroidScheduleMode.inexact;
      if (Platform.isAndroid && androidScheduleMode != fallbackMode) {
        Constants.talker.warning(
          'Retrying notification ${notification.id} with inexact scheduling due to error: $error',
          error,
          stackTrace,
        );
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
          androidScheduleMode: fallbackMode,
          matchDateTimeComponents: notification.repeatDaily ? DateTimeComponents.time : null,
        );
      } else {
        Constants.talker.error('Failed to schedule notification ${notification.id}', error, stackTrace);
        rethrow;
      }
    }

    await _notificationStore.createUpdate(notification);
  }

  Future<void> showTestNotification({
    String title = 'Test notification',
    String body = 'This is a test notification',
    Map<String, dynamic> payload = const {},
    String? deepLink,
  }) async {
    _ensureInitialized();

    final canProceed = await _ensurePermissionsBeforeSchedule();
    if (!canProceed) {
      Constants.talker.warning('Skipping test notification because OS permissions are disabled');
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);
    await _plugin.show(id, title, body, _buildNotificationDetails(), payload: _encodePayload(payload, deepLink));
  }

  Future<void> cancelNotification(int id) async {
    _ensureInitialized();
    await _plugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    _ensureInitialized();
    await _plugin.cancelAll();
  }

  Future<void> debugPrintScheduledNotifications() async {
    try {
      await _ensureNotificationStoreReady();
    } catch (_) {}

    List<PendingNotificationRequest> pending = const [];
    try {
      _ensureInitialized();
      pending = await _plugin.pendingNotificationRequests();
    } catch (error) {
      debugPrint('LocalNotificationService not initialized: $error');
    }

    final stored = _notificationStore.getAll();
    final pendingIds = pending.map((entry) => entry.id).toSet();

    debugPrint('--- Pending notifications (${pending.length}) ---');
    for (final entry in pending) {
      debugPrint('=========================================');
      debugPrint('id=${entry.id} \ntitle=${entry.title} \nbody=${entry.body} \npayload=${entry.payload}');
    }

    debugPrint('--- Stored notifications (${stored.length}) ---');
    for (final entry in stored) {
      final isPending = pendingIds.contains(entry.id);
      debugPrint(
        'id=${entry.id} pending=$isPending title=${entry.title} body=${entry.body} time=${entry.scheduledAt.toIso8601String()} enabled=${entry.isEnabled} repeat=${entry.repeatDaily} payload=${entry.payload}',
      );
    }
  }

  Future<void> handleNotificationResponse(NotificationResponse response) async {
    final payload = _decodePayload(response.payload);
    print(" =====>>> $payload");
    await handlePayload(payload, navigateImmediately: true);
  }

  Future<void> handlePayload(Map<String, dynamic> payload, {bool navigateImmediately = false}) async {
    if (payload.isEmpty) return;

    if (_payloadHandler != null) {
      await _payloadHandler!(payload);
    }

    final deepLink = _extractDeepLink(payload) ?? _fallbackDeepLink(payload);
    if (deepLink != null && deepLink.isNotEmpty) {
      _pendingDeepLink = deepLink;
      _pendingPayload = payload;

      if (navigateImmediately) {
        await navigateToPendingIfExists();
      }
    }
  }

  Future<void> navigateToPendingIfExists() async {
    if (!hasPendingNavigation) return;

    final deepLink = _pendingDeepLink!;
    final payload = _pendingPayload ?? {};
    clearPendingNavigation();

    await _deepLinkNavigator.navigate(deepLink, payload);
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

  NotificationDetails _buildNotificationDetails({String? channelId, String? channelName, String? channelDescription}) {
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
      iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
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
      print(" =====>>>33 $value");
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  String? _fallbackDeepLink(Map<String, dynamic> payload) {
    final surahNumber = _parseInt(payload['surahNumber'] ?? payload['surah_number']);
    if (surahNumber != null) {
      return RoutesNames.quran.quranMain;
    }
    final surahName = payload['surah']?.toString().toLowerCase().trim();
    if (surahName != null && surahName.isNotEmpty) {
      if (surahName == 'al_mulk' || surahName == 'al_baqara' || surahName == 'al_baqarah') {
        return RoutesNames.quran.quranMain;
      }
    }

    if (payload['planId'] != null) {
      return RoutesNames.werd.werdMain;
    }

    final categoryId = _azkarCategoryIdFromPayload(payload);
    if (categoryId != null) {
      return RoutesNames.azkar.zekr(categoryId);
    }

    return null;
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
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
      case 'morning_adhkar':
        return 4;
      case 'evening':
      case 'evening_adhkar':
        return 2;
      case 'sleep':
        return 5;
      default:
        return null;
    }
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
    await _refreshExactSchedulingCapability(android);

    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _refreshExactSchedulingCapability([
    AndroidFlutterLocalNotificationsPlugin? androidImplementation,
  ]) async {
    final android =
        androidImplementation ??
        _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final canScheduleExact = await android?.canScheduleExactNotifications();
    if (canScheduleExact != null) {
      print(" =======>>>> canScheduleExactNotifications: $canScheduleExact ");
      _exactSchedulingAvailable = canScheduleExact;
    }
  }

  AndroidScheduleMode _resolveScheduleMode(bool allowWhileIdle) {
    if (_exactSchedulingAvailable) {
      return allowWhileIdle ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.exact;
    }
    return allowWhileIdle ? AndroidScheduleMode.inexactAllowWhileIdle : AndroidScheduleMode.inexact;
  }

  Future<bool> _ensurePermissionsBeforeSchedule() async {
    if (!Platform.isAndroid) return true;
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;

    final notificationsEnabled = await android.areNotificationsEnabled();
    if (notificationsEnabled == false) {
      if (_allowPermissionRequests) {
        await android.requestNotificationsPermission();
        final enabledAfterRequest = await android.areNotificationsEnabled();
        if (enabledAfterRequest == false) {
          Constants.talker.warning('Android notifications are disabled at OS level; skipping schedule');
          return false;
        }
      } else {
        Constants.talker.warning('Android notifications disabled and cannot request permission in background');
        return false;
      }
    }

    await _refreshExactSchedulingCapability(android);
    if (!_exactSchedulingAvailable && _allowPermissionRequests) {
      await android.requestExactAlarmsPermission();
      await _refreshExactSchedulingCapability(android);
    }
    return true;
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

  Future<void> _ensureAppConfigReady() async {
    try {
      await Hive.initFlutter('al_muslim_data');
    } catch (_) {}
    await BoxAppConfig.init();
  }

  static Future<void> _onNotificationResponse(NotificationResponse response) async {
    await LocalNotificationService.instance.handleNotificationResponse(response);
  }
}

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.instance.storePendingNotificationPayload(response.payload);
}
