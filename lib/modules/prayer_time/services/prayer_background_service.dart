import 'dart:async';
import 'dart:ui';

import 'package:al_muslim/core/config/box_app_config/box_app_config.dart';
import 'package:al_muslim/core/config/box_location_config/box_location_config.dart';
import 'package:al_muslim/core/config/box_location_config/ds_location_config.dart';
import 'package:al_muslim/core/config/box_location_config/m_location_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/notification/init_notifications_service.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/ds_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/services/notification/prayer_notifications_service.dart';
import 'package:al_muslim/modules/prayer_time/data/params/p_prayer_time_params.dart';
import 'package:al_muslim/modules/prayer_time/sources/remote/prayer_time_remote_source.dart';
import 'package:al_muslim/modules/prayer_time/utils/prayer_method_mapper.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

const String prayerWorkTaskName = 'daily_prayer_time_fetch';

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
    InitNotificationsService? initNotificationsService,
    PrayerNotificationsService? prayerNotificationsService,
    BoxLocationConfig? locationBox,
    DSLocationConfig? locationStore,
    PPrayerTimeParams params = _defaultParams,
  }) {
    final resolvedNotificationService = notificationService ?? LocalNotificationService();
    final resolvedBox = boxNotification ?? BoxNotification();
    final resolvedStore = dsNotification ?? DSNotification(resolvedBox);
    final resolvedInitService =
        initNotificationsService ??
        InitNotificationsService(
          notificationService: resolvedNotificationService,
          boxNotification: resolvedBox,
          notificationStore: resolvedStore,
        );
    final resolvedLocationBox = locationBox ?? BoxLocationConfig();
    final resolvedLocationStore = locationStore ?? DSLocationConfig(resolvedLocationBox);
    return PrayerBackgroundService._(
      workmanager ?? Workmanager(),
      remoteSource ?? PrayerTimeRemoteSource(),
      resolvedNotificationService,
      resolvedBox,
      resolvedStore,
      resolvedInitService,
      prayerNotificationsService ?? PrayerNotificationsService(),
      resolvedLocationBox,
      resolvedLocationStore,
      params,
    );
  }

  factory PrayerBackgroundService.forBackground({Map<String, dynamic>? inputData}) {
    final resolvedNotificationService = LocalNotificationService();
    final resolvedBox = BoxNotification();
    final resolvedStore = DSNotification(resolvedBox);
    final resolvedInitService = InitNotificationsService(
      notificationService: resolvedNotificationService,
      boxNotification: resolvedBox,
      notificationStore: resolvedStore,
    );
    final resolvedLocationBox = BoxLocationConfig();
    final resolvedLocationStore = DSLocationConfig(resolvedLocationBox);
    return PrayerBackgroundService._(
      Workmanager(),
      PrayerTimeRemoteSource(),
      resolvedNotificationService,
      resolvedBox,
      resolvedStore,
      resolvedInitService,
      PrayerNotificationsService(),
      resolvedLocationBox,
      resolvedLocationStore,
      _decodeParams(inputData) ?? _defaultParams,
    );
  }

  PrayerBackgroundService._(
    this._workmanager,
    this._remoteSource,
    this._notificationService,
    this._boxNotification,
    this._notificationStore,
    this._initNotificationsService,
    this._prayerNotificationsService,
    this._locationBox,
    this._locationStore,
    this._params,
  );

  final Workmanager _workmanager;
  final PrayerTimeRemoteSource _remoteSource;
  final LocalNotificationService _notificationService;
  final BoxNotification _boxNotification;
  final DSNotification _notificationStore;
  final InitNotificationsService _initNotificationsService;
  final PrayerNotificationsService _prayerNotificationsService;
  final BoxLocationConfig _locationBox;
  final DSLocationConfig _locationStore;
  final PPrayerTimeParams _params;

  bool _workmanagerInitialized = false;
  bool _notificationsReady = false;
  bool _storageInitialized = false;
  bool _notificationBoxReady = false;
  bool _locationBoxReady = false;

  static const List<String> _prayerNames = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
  static const PPrayerTimeParams _defaultParams = PPrayerTimeParams(
    lat: 30.04442,
    lon: 31.235712,
    method: 5,
  );

  Future<void> initializeBackgroundSync() async {
    await _prepareStorage();
    await _ensureNotificationsReady();
    await _ensureNotificationBoxReady();
    await _ensureLocationBoxReady();
    await _initializeWorkmanager();
    await _registerDailyTask();
  }

  Future<void> scheduleTodayPrayers() async {
    await _prepareStorage();
    await _ensureNotificationsReady();
    await _ensureNotificationBoxReady();
    await _ensureLocationBoxReady();
    await _fetchAndScheduleFor(DateTime.now());
  }

  Future<bool> handleWork(String taskName) async {
    try {
      await _prepareStorage();
      await _ensureNotificationsReady(requestPermissions: false);
      await _ensureNotificationBoxReady();
      await _ensureLocationBoxReady();

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
    final params = await _resolveParams();
    final response = await _remoteSource.fetchPrayerTimes(params, date: normalizedDate);
    final entries = _buildPrayerEntries(response.times.raw, normalizedDate);
    await _scheduleNotifications(entries);
    await _updateAzkarNotifications(entries);
  }

  Future<void> _ensureLocationBoxReady() async {
    if (_locationBoxReady) return;
    await _locationBox.init();
    _locationBoxReady = true;
  }

  Future<PPrayerTimeParams> _resolveParams() async {
    final MLocationConfig? stored = _locationStore.getCurrent();
    if (stored == null) return _params;
    final countryCode = await _resolveCountryCode(stored.latitude, stored.longitude);
    final method = getPrayerMethodByCountryCode(countryCode);
    return PPrayerTimeParams(
      lat: stored.latitude,
      lon: stored.longitude,
      method: method,
    );
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
      final template = await _prayerNotificationsService.templateForPrayer(entry.name);
      final notificationId = Constants.prayNotificationBaseId + index;
      final stored = await _notificationStore.getById(notificationId);
      final scheduledAt = entry.dateTime;
      final resolved = (stored ?? _defaultNotification(notificationId, entry.name, template: template)).copyWith(
        title: template?.title ?? stored?.title ?? _safeTranslate(entry.name),
        body: template?.body ?? stored?.body ?? _defaultPrayerBody(entry.name),
        scheduledAt: scheduledAt,
        payload: _updatedPayload(_mergedPayload(template?.payload, stored?.payload), entry.name, 0),
        deepLink: template?.deepLink ?? stored?.deepLink,
      );

      await _notificationService.cancelNotification(notificationId);
      if (!resolved.isEnabled || !scheduledAt.isAfter(now)) {
        await _notificationStore.createUpdate(resolved);
      } else {
        await _notificationService.scheduleNotification(
          notification: resolved,
          androidAllowWhileIdle: true,
          // soundName: 'maka_azhan',
        );
        await _notificationStore.createUpdate(resolved);
      }
    }
  }

  Future<void> _updateAzkarNotifications(List<_PrayerEntry> entries) async {
    final fajrTime = _timeForPrayer(entries, 'Fajr');
    final maghribTime = _timeForPrayer(entries, 'Maghrib');
    await _initNotificationsService.updateAzkarNotifications(fajrTime: fajrTime, maghribTime: maghribTime);
  }

  DateTime? _timeForPrayer(List<_PrayerEntry> entries, String name) {
    for (final entry in entries) {
      if (entry.name == name) {
        return entry.dateTime;
      }
    }
    return null;
  }

  Map<String, dynamic> _updatedPayload(Map<String, dynamic> existing, String prayerName, int preAlertMinutes) {
    return {...existing, 'prayer': prayerName, 'preAlertMinutes': preAlertMinutes};
  }

  MLocalNotification _defaultNotification(int id, String prayerName, {PrayerNotificationTemplate? template}) {
    final resolvedPrayer = template?.title ?? _safeTranslate(prayerName);
    final resolvedBody = template?.body ?? _defaultPrayerBody(prayerName);
    return MLocalNotification(
      id: id,
      title: resolvedPrayer,
      body: resolvedBody,
      scheduledAt: DateTime.now(),
      repeatDaily: false,
      payload: _updatedPayload(_mergedPayload(template?.payload, <String, dynamic>{}), prayerName, 0),
      deepLink: template?.deepLink,
      isEnabled: template?.isEnabled ?? true,
    );
  }

  String _defaultPrayerBody(String prayerName) {
    final resolvedPrayer = _safeTranslate(prayerName);
    return '${_safeTranslate('It is time for')} $resolvedPrayer';
  }

  Map<String, dynamic> _mergedPayload(Map<String, dynamic>? template, Map<String, dynamic>? existing) {
    return <String, dynamic>{...?template, ...?existing};
  }

  String _safeTranslate(String value) {
    try {
      return value.translated;
    } catch (_) {
      return value;
    }
  }

  Future<String?> _resolveCountryCode(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;
      return placemarks.first.isoCountryCode;
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic> _encodeParams(PPrayerTimeParams params) {
    return {'lat': params.lat, 'lon': params.lon, 'method': params.method};
  }

  static PPrayerTimeParams? _decodeParams(Map<String, dynamic>? inputData) {
    if (inputData == null || inputData.isEmpty) return null;
    double? parseDouble(dynamic value) => value is num ? value.toDouble() : double.tryParse(value?.toString() ?? '');
    int? parseInt(dynamic value) => value is int ? value : int.tryParse(value?.toString() ?? '');

    final lat = parseDouble(inputData['lat']);
    final lon = parseDouble(inputData['lon']);
    final method = parseInt(inputData['method']);

    if (lat == null || lon == null || method == null) return null;
    return PPrayerTimeParams(lat: lat, lon: lon, method: method);
  }
}

class _PrayerEntry {
  const _PrayerEntry({required this.name, required this.dateTime});

  final String name;
  final DateTime dateTime;
}
