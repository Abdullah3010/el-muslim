import 'dart:async';
import 'dart:ui';

import 'package:al_muslim/core/config/box_app_config/box_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/ds_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/modules/prayer_time/data/params/p_prayer_time_params.dart';
import 'package:al_muslim/modules/prayer_time/sources/remote/prayer_time_remote_source.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

const String prayerWorkTaskName = 'daily_prayer_time_fetch';
const int _prayerNotificationBaseId = 4200;

@pragma('vm:entry-point')
void prayerBackgroundDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    final service = PrayerBackgroundService.forBackground(inputData: inputData);
    final success = await service.handleWork(taskName);
    return success;
  });
}

class PrayerBackgroundService {
  factory PrayerBackgroundService({
    Workmanager? workmanager,
    PrayerTimeRemoteSource? remoteSource,
    LocalNotificationService? notificationService,
    BoxNotification? boxNotification,
    DSNotification? dsNotification,
    PPrayerTimeParams params = _defaultParams,
  }) {
    final resolvedBox = boxNotification ?? BoxNotification();
    final resolvedStore = dsNotification ?? DSNotification(resolvedBox);
    return PrayerBackgroundService._(
      workmanager ?? Workmanager(),
      remoteSource ?? PrayerTimeRemoteSource(),
      notificationService ?? LocalNotificationService(),
      resolvedBox,
      resolvedStore,
      params,
    );
  }

  factory PrayerBackgroundService.forBackground({Map<String, dynamic>? inputData}) {
    final resolvedBox = BoxNotification();
    final resolvedStore = DSNotification(resolvedBox);
    return PrayerBackgroundService._(
      Workmanager(),
      PrayerTimeRemoteSource(),
      LocalNotificationService(),
      resolvedBox,
      resolvedStore,
      _decodeParams(inputData) ?? _defaultParams,
    );
  }

  PrayerBackgroundService._(
    this._workmanager,
    this._remoteSource,
    this._notificationService,
    this._boxNotification,
    this._notificationStore,
    this._params,
  );

  final Workmanager _workmanager;
  final PrayerTimeRemoteSource _remoteSource;
  final LocalNotificationService _notificationService;
  final BoxNotification _boxNotification;
  final DSNotification _notificationStore;
  final PPrayerTimeParams _params;

  bool _workmanagerInitialized = false;
  bool _notificationsReady = false;
  bool _storageInitialized = false;
  bool _notificationBoxReady = false;

  static const List<String> _prayerNames = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  static const PPrayerTimeParams _defaultParams = PPrayerTimeParams(
    lat: 30.04442,
    lon: 31.235712,
    method: 5,
    school: 1,
  );

  Future<void> initializeBackgroundSync() async {
    await _prepareStorage();
    await _ensureNotificationsReady();
    await _ensureNotificationBoxReady();
    await _initializeWorkmanager();
    await _registerDailyTask();
  }

  Future<void> scheduleTodayPrayers() async {
    await _prepareStorage();
    await _ensureNotificationsReady();
    await _ensureNotificationBoxReady();
    await _fetchAndScheduleFor(DateTime.now());
  }

  Future<bool> handleWork(String taskName) async {
    try {
      await _prepareStorage();
      await _ensureNotificationsReady(requestPermissions: false);
      await _ensureNotificationBoxReady();

      if (taskName == prayerWorkTaskName || taskName == Workmanager.iOSBackgroundTask) {
        await _fetchAndScheduleFor(DateTime.now());
      }
      return true;
    } catch (error, stackTrace) {
      Constants.talker.error('Prayer background task failed', error, stackTrace);
      return false;
    }
  }

  Future<void> _initializeWorkmanager() async {
    if (_workmanagerInitialized) return;
    await _workmanager.initialize(prayerBackgroundDispatcher, isInDebugMode: false);
    _workmanagerInitialized = true;
  }

  Future<void> _registerDailyTask() async {
    final delay = _timeUntilNextMidnight();
    await _workmanager.registerPeriodicTask(
      prayerWorkTaskName,
      prayerWorkTaskName,
      frequency: const Duration(hours: 24),
      initialDelay: delay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(networkType: NetworkType.connected),
      backoffPolicy: BackoffPolicy.linear,
      backoffPolicyDelay: const Duration(minutes: 15),
      inputData: _encodeParams(_params),
    );
  }

  Duration _timeUntilNextMidnight() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return nextMidnight.difference(now);
  }

  Future<void> _prepareStorage() async {
    if (_storageInitialized) return;
    try {
      await Hive.initFlutter('al_muslim_data');
    } catch (_) {}
    await BoxAppConfig.init();
    _storageInitialized = true;
  }

  Future<void> _ensureNotificationsReady({bool requestPermissions = true}) async {
    if (_notificationsReady) return;
    await _notificationService.initialize(requestPermissions: requestPermissions);
    _notificationsReady = true;
  }

  Future<void> _ensureNotificationBoxReady() async {
    if (_notificationBoxReady) return;
    await _boxNotification.init();
    _notificationBoxReady = true;
  }

  Future<void> _fetchAndScheduleFor(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final response = await _remoteSource.fetchPrayerTimes(_params, date: normalizedDate);
    final entries = _buildPrayerEntries(response.times.raw, normalizedDate);
    await _scheduleNotifications(entries);
  }

  List<_PrayerEntry> _buildPrayerEntries(Map<String, String> raw, DateTime baseDate) {
    return _prayerNames
        .map((name) {
          final time = raw[name];
          if (time == null || time.isEmpty) return null;
          return _PrayerEntry(name: name, dateTime: _parseDateTime(baseDate, time));
        })
        .whereType<_PrayerEntry>()
        .toList();
  }

  DateTime _parseDateTime(DateTime baseDate, String time) {
    final sanitized = time.split(' ').first;
    final parts = sanitized.split(':');
    final hour = int.tryParse(parts.elementAt(0)) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts.elementAt(1)) ?? 0 : 0;
    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  Future<void> _scheduleNotifications(List<_PrayerEntry> entries) async {
    final now = DateTime.now();
    for (int index = 0; index < entries.length; index++) {
      final entry = entries[index];
      if (!entry.dateTime.isAfter(now)) continue;

      final notificationId = _prayerNotificationBaseId + index;
      await _notificationService.cancelNotification(notificationId);
      final notification = MLocalNotification(
        id: notificationId,
        title: '${entry.name} prayer',
        body: 'It is time for ${entry.name}',
        scheduledAt: entry.dateTime,
        repeatDaily: false,
        payload: {'prayer': entry.name, 'time': entry.dateTime.toIso8601String()},
        deepLink: null,
      );
      await _notificationService.scheduleNotification(notification: notification, androidAllowWhileIdle: true);
      await _notificationStore.createUpdate(notification);
    }
  }

  static Map<String, dynamic> _encodeParams(PPrayerTimeParams params) {
    return {'lat': params.lat, 'lon': params.lon, 'method': params.method, 'school': params.school};
  }

  static PPrayerTimeParams? _decodeParams(Map<String, dynamic>? inputData) {
    if (inputData == null || inputData.isEmpty) return null;
    double? parseDouble(dynamic value) => value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '');
    int? parseInt(dynamic value) => value is int ? value : int.tryParse(value?.toString() ?? '');

    final lat = parseDouble(inputData['lat']);
    final lon = parseDouble(inputData['lon']);
    final method = parseInt(inputData['method']);
    final school = parseInt(inputData['school']);

    if (lat == null || lon == null || method == null || school == null) return null;
    return PPrayerTimeParams(lat: lat, lon: lon, method: method, school: school);
  }
}

class _PrayerEntry {
  const _PrayerEntry({required this.name, required this.dateTime});

  final String name;
  final DateTime dateTime;
}
