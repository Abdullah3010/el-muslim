import 'dart:async';

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
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:al_muslim/modules/prayer_time/data/models/m_prayer_time_response.dart';
import 'package:al_muslim/modules/prayer_time/data/params/p_prayer_time_params.dart';
import 'package:al_muslim/modules/prayer_time/sources/remote/prayer_time_remote_source.dart';
import 'package:al_muslim/modules/prayer_time/utils/prayer_method_mapper.dart';

enum PrayerTimeStatus { initial, loading, success, error }

class MgPrayerTime extends ChangeNotifier {
  MgPrayerTime({
    PrayerTimeRemoteSource? remoteSource,
    LocalNotificationService? notificationService,
    BoxNotification? boxNotification,
    DSNotification? notificationStore,
    BoxLocationConfig? locationBox,
    DSLocationConfig? locationStore,
    InitNotificationsService? initNotificationsService,
    PrayerNotificationsService? prayerNotificationsService,
  }) : _remoteSource = remoteSource ?? PrayerTimeRemoteSource(),
       _notificationService = notificationService ?? LocalNotificationService(),
       _boxNotification = boxNotification ?? BoxNotification(),
       _locationBox = locationBox ?? BoxLocationConfig() {
    _notificationStore = notificationStore ?? DSNotification(_boxNotification);
    _locationStore = locationStore ?? DSLocationConfig(_locationBox);
    _initNotificationsService =
        initNotificationsService ??
        InitNotificationsService(
          notificationService: _notificationService,
          boxNotification: _boxNotification,
          notificationStore: _notificationStore,
        );
    _prayerNotificationsService = prayerNotificationsService ?? PrayerNotificationsService();
  }

  static const _defaultParams = PPrayerTimeParams(lat: 30.04442, lon: 31.235712, method: 5);
  static final _cacheDateFormat = DateFormat('yyyy-MM-dd');

  final PrayerTimeRemoteSource _remoteSource;
  final Map<String, MPrayerTime> _cache = {};
  final LocalNotificationService _notificationService;
  final BoxNotification _boxNotification;
  late final DSNotification _notificationStore;
  late final InitNotificationsService _initNotificationsService;
  late final PrayerNotificationsService _prayerNotificationsService;
  final Map<String, MLocalNotification> _prayerNotifications = {};
  bool _notificationBoxReady = false;
  final BoxLocationConfig _locationBox;
  late final DSLocationConfig _locationStore;
  bool _locationBoxReady = false;

  PrayerTimeStatus _status = PrayerTimeStatus.initial;
  MPrayerTime? _currentData;
  DateTime _selectedDate = DateTime.now();
  String? _errorMessage;
  String? _locationError;
  bool _isLocationLoading = false;
  MLocationConfig? _locationConfig;
  String? _lastResolvedCountryCode;
  bool _autoDetectEnabled = true;
  String _nextPrayerName = '';
  Duration _nextPrayerCountdown = Duration.zero;
  Timer? _countdownTimer;
  PPrayerTimeParams _activeParams = _defaultParams;
  List<String> prayerNames = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  PrayerTimeStatus get status => _status;
  bool get isLoading => _status == PrayerTimeStatus.loading;
  String? get errorMessage => _errorMessage;
  DateTime get selectedDate => _selectedDate;
  MPrayerTime? get currentData => _currentData;
  bool get hasData => _currentData != null;
  String get nextPrayerName => _nextPrayerName;
  Duration get nextPrayerCountdown => _nextPrayerCountdown;
  bool get isLocationLoading => _isLocationLoading;
  bool get isAutoDetectEnabled => _autoDetectEnabled;
  bool get canGoToPreviousDay => !_isToday(_selectedDate);

  String get currentLocationLabel {
    if (_locationError != null && _locationError!.isNotEmpty) {
      return _locationError!;
    }
    final displayName = _locationConfig?.displayName ?? '';
    if (displayName.isNotEmpty) {
      return displayName;
    }
    return _isLocationLoading ? 'Detecting location'.translated : 'Location unavailable'.translated;
  }

  String get hijriDateLabel {
    final hijri = _currentData?.date.hijri;
    if (hijri == null) return '';
    final weekday = _localizedValue(ar: hijri.weekday.ar, en: hijri.weekday.en);
    final month = _localizedValue(ar: hijri.month.ar, en: hijri.month.en);
    final yearSuffix = hijri.year.isNotEmpty ? ' هـ' : '';
    return [weekday, hijri.day, month, hijri.year].where((element) => element.isNotEmpty).join(' ') + yearSuffix;
  }

  String get gregorianDateLabel {
    final gregorian = _currentData?.date.gregorian;
    if (gregorian == null) return '';
    final locale = LocalizeAndTranslate.getLanguageCode();
    final formatter = DateFormat('EEEE d MMMM yyyy', locale);
    return formatter.format(_normalizeDate(_selectedDate));
  }

  String get readableDate => _currentData?.date.readable ?? '';

  Future<void> loadPrayerTimes({DateTime? forDate}) async {
    await _ensureLocationSettings();
    await _ensureNotificationSettings();
    final targetDate = _normalizeDate(forDate ?? _selectedDate);
    _selectedDate = targetDate;
    final cacheKey = _cacheKeyFor(_selectedDate);

    if (_cache.containsKey(cacheKey)) {
      _currentData = _cache[cacheKey];
      _status = PrayerTimeStatus.success;
      _errorMessage = null;
      _startCountdown();
      unawaited(_refreshPrayerNotifications());
      notifyListeners();
      return;
    }

    _status = PrayerTimeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      var response = await _remoteSource.fetchPrayerTimes(_activeParams, date: _selectedDate);

      // Apply Qatar-specific prayer time adjustments
      if (isQatarCountryCode(_lastResolvedCountryCode)) {
        final adjustments = getQatarPrayerAdjustments();
        final adjustedTimes = response.times.copyWithAdjustments(adjustments, adjustTimeByMinutes);
        response = response.copyWith(times: adjustedTimes);
      }

      _currentData = response;
      _cache[cacheKey] = _currentData!;
      _status = PrayerTimeStatus.success;
      _startCountdown();
      unawaited(_refreshPrayerNotifications());
    } catch (error) {
      _status = PrayerTimeStatus.error;
      _errorMessage = _mapError(error);
      _cancelCountdown();
    }

    notifyListeners();
  }

  Future<void> goToPreviousDay() async {
    if (!canGoToPreviousDay) return;
    await loadPrayerTimes(forDate: _selectedDate.subtract(const Duration(days: 1)));
  }

  Future<void> goToNextDay() async => loadPrayerTimes(forDate: _selectedDate.add(const Duration(days: 1)));

  List<PrayerTimeEntry> get prayerTimeEntries => _buildPrayerEntries();

  Future<void> initializeLocation() async {
    await _ensureLocationSettings();
    if (!_autoDetectEnabled) return;
    await refreshLocation();
  }

  Future<void> setAutoDetectEnabled(bool enabled) async {
    await _ensureLocationSettings();
    if (_autoDetectEnabled == enabled) return;
    _autoDetectEnabled = enabled;
    _locationConfig = _locationConfig?.copyWith(autoDetect: enabled, updatedAt: DateTime.now());
    _locationError = null;
    await _locationStore.setAutoDetectEnabled(enabled);
    notifyListeners();
    if (enabled) {
      await refreshLocation();
    }
  }

  Future<MLocationConfig?> fetchLocationCandidate() async {
    await _ensureLocationSettings();
    return _resolveLocationCandidate();
  }

  Future<void> refreshLocation() async {
    await _ensureLocationSettings();
    final candidate = await _resolveLocationCandidate();
    if (candidate == null) return;
    await applyLocation(candidate, countryCode: _lastResolvedCountryCode);
  }

  Future<void> applyLocation(MLocationConfig config, {String? countryCode}) async {
    await _ensureLocationSettings();
    final resolved = config.copyWith(autoDetect: _autoDetectEnabled, updatedAt: DateTime.now());
    final changed =
        _locationConfig == null ||
        (_locationConfig!.latitude - resolved.latitude).abs() > 0.0001 ||
        (_locationConfig!.longitude - resolved.longitude).abs() > 0.0001;
    _locationConfig = resolved;
    await _updateParamsFromLocation(resolved, countryCode: countryCode);
    await _locationStore.saveCurrent(resolved);
    _locationError = null;
    if (changed) {
      _cache.clear();
      unawaited(loadPrayerTimes(forDate: _selectedDate));
    }
    notifyListeners();
  }

  Future<bool> applyManualLocation({
    required String cityDisplay,
    required String countryDisplay,
    required String cityForGeocoding,
    required String countryForGeocoding,
  }) async {
    await _ensureLocationSettings();
    if (_isLocationLoading) return false;
    _isLocationLoading = true;
    _locationError = null;
    notifyListeners();

    try {
      final queryParts = [cityForGeocoding, countryForGeocoding].where((value) => value.trim().isNotEmpty).toList();
      if (queryParts.isEmpty) {
        _locationError = 'Location unavailable'.translated;
        return false;
      }
      final locations = await locationFromAddress(queryParts.join(', '));
      if (locations.isEmpty) {
        _locationError = 'Location unavailable'.translated;
        return false;
      }
      final location = locations.first;
      final countryCode = await _resolveCountryCodeByCoordinates(location.latitude, location.longitude);
      await applyLocation(
        MLocationConfig(
          latitude: location.latitude,
          longitude: location.longitude,
          city: cityDisplay,
          country: countryDisplay,
          updatedAt: DateTime.now(),
          autoDetect: _autoDetectEnabled,
        ),
        countryCode: countryCode,
      );
      return true;
    } catch (_) {
      _locationError = 'Location unavailable'.translated;
      return false;
    } finally {
      _isLocationLoading = false;
      notifyListeners();
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _updateNextPrayerInfo(notify: false);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateNextPrayerInfo());
  }

  void _updateNextPrayerInfo({bool notify = true}) {
    final now = DateTime.now();
    final todayEntries = _buildPrayerEntriesForDate(_normalizeDate(now));

    if (todayEntries.isEmpty) {
      _nextPrayerName = '';
      _nextPrayerCountdown = Duration.zero;
      if (notify) notifyListeners();
      return;
    }

    final upcoming = todayEntries.firstWhere(
      (entry) => entry.dateTime.isAfter(now),
      orElse: () {
        final first = todayEntries.first;
        return PrayerTimeEntry(
          name: first.name,
          time: first.time,
          dateTime: first.dateTime.add(const Duration(days: 1)),
        );
      },
    );

    final remaining = upcoming.dateTime.difference(now);
    _nextPrayerName = upcoming.name;
    _nextPrayerCountdown = remaining.isNegative ? Duration.zero : remaining;

    if (notify) {
      notifyListeners();
    }
  }

  List<PrayerTimeEntry> _buildPrayerEntries() {
    return _buildPrayerEntriesForDate(_selectedDate);
  }

  List<PrayerTimeEntry> _buildPrayerEntriesForDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    final cacheKey = _cacheKeyFor(normalizedDate);
    final data = _cache[cacheKey];

    if (data == null) return [];

    const displayOrder = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    return displayOrder
        .map((name) {
          final time = data.times.raw[name];
          if (time == null || time.isEmpty) return null;
          return PrayerTimeEntry(name: name, time: time, dateTime: _parseDateTime(normalizedDate, time));
        })
        .whereType<PrayerTimeEntry>()
        .toList();
  }

  bool isPrayerMuted(String prayerName) {
    final notification = _prayerNotifications[prayerName];
    return !(notification?.isEnabled ?? true);
  }

  Future<void> setPrayerNotificationEnabled(String prayerName, bool isEnabled) async {
    await _ensureNotificationSettings();
    final template = await _prayerNotificationsService.templateForPrayer(prayerName);
    final notification = _prayerNotifications[prayerName] ?? _defaultNotification(prayerName, template: template);
    final updated = notification.copyWith(isEnabled: isEnabled);
    _prayerNotifications[prayerName] = updated;
    await _notificationStore.createUpdate(updated);
    if (!isEnabled) {
      await _notificationService.cancelNotification(updated.id);
    } else {
      await _reschedulePrayer(prayerName);
    }
    notifyListeners();
  }

  DateTime _parseDateTime(DateTime baseDate, String time) {
    final parts = time.split(':');
    final hour = int.tryParse(parts.elementAt(0)) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts.elementAt(1)) ?? 0 : 0;
    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  String _cacheKeyFor(DateTime date) {
    final latKey = _activeParams.lat.toStringAsFixed(3);
    final lonKey = _activeParams.lon.toStringAsFixed(3);
    return '${_cacheDateFormat.format(date)}_${latKey}_${lonKey}_${_activeParams.method}';
  }

  Future<void> _ensureLocationSettings() async {
    await _ensureLocationBoxReady();
    if (_locationConfig != null) {
      _autoDetectEnabled = _locationConfig!.autoDetect;
      return;
    }
    final stored = _locationStore.getCurrent();
    _autoDetectEnabled = stored?.autoDetect ?? true;
    if (stored != null) {
      _locationConfig = stored;
      await _updateParamsFromLocation(stored);
      notifyListeners();
    }
  }

  Future<void> _ensureLocationBoxReady() async {
    if (_locationBoxReady) return;
    await _locationBox.init();
    _locationBoxReady = true;
  }

  Future<MLocationConfig?> _resolveLocationCandidate() async {
    if (_isLocationLoading) return null;
    _isLocationLoading = true;
    _locationError = null;
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError = 'Please enable location services'.translated;
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _locationError = 'Location permission denied'.translated;
        return null;
      }

      if (permission == LocationPermission.deniedForever) {
        _locationError = 'Location permission denied forever'.translated;
        return null;
      }

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      final locale = LocalizeAndTranslate.getLanguageCode();
      try {
        await setLocaleIdentifier(locale);
      } catch (_) {}
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final placemark = placemarks.isNotEmpty ? placemarks.first : null;
      final city = placemark?.locality ?? placemark?.subAdministrativeArea ?? placemark?.administrativeArea ?? '';
      final country = placemark?.country ?? '';
      _lastResolvedCountryCode = placemark?.isoCountryCode;
      return MLocationConfig(
        latitude: position.latitude,
        longitude: position.longitude,
        city: city,
        country: country,
        updatedAt: DateTime.now(),
        autoDetect: _autoDetectEnabled,
      );
    } catch (error) {
      _locationError = 'Location unavailable'.translated;
      return null;
    } finally {
      _isLocationLoading = false;
      notifyListeners();
    }
  }

  Future<void> _updateParamsFromLocation(MLocationConfig config, {String? countryCode}) async {
    final resolvedCountryCode =
        countryCode != null && countryCode.trim().isNotEmpty
            ? countryCode
            : await _resolveCountryCodeByCoordinates(config.latitude, config.longitude);
    final method = getPrayerMethodByCountryCode(resolvedCountryCode);
    _activeParams = PPrayerTimeParams(lat: config.latitude, lon: config.longitude, method: method);
  }

  Future<void> _ensureNotificationSettings() async {
    await _ensureNotificationBoxReady();
    var didUpdate = false;
    for (final prayerName in prayerNames) {
      if (!_prayerNotifications.containsKey(prayerName)) {
        final id = _notificationIdForPrayer(prayerName);
        final stored = await _notificationStore.getById(id);
        if (stored != null) {
          _prayerNotifications[prayerName] = stored;
          didUpdate = true;
        } else {
          final template = await _prayerNotificationsService.templateForPrayer(prayerName);
          final created = _defaultNotification(prayerName, template: template);
          _prayerNotifications[prayerName] = created;
          await _notificationStore.createUpdate(created);
          didUpdate = true;
        }
      }
    }
    if (didUpdate) {
      notifyListeners();
    }
  }

  Future<String?> _resolveCountryCodeByCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;
      return placemarks.first.isoCountryCode;
    } catch (_) {
      return null;
    }
  }

  Future<void> _ensureNotificationBoxReady() async {
    if (_notificationBoxReady) return;
    await _boxNotification.init();
    _notificationBoxReady = true;
  }

  int _notificationIdForPrayer(String prayerName) {
    final index = prayerNames.indexOf(prayerName);
    return Constants.prayNotificationBaseId + (index < 0 ? 0 : index);
  }

  MLocalNotification _defaultNotification(String prayerName, {PrayerNotificationTemplate? template}) {
    final now = DateTime.now();
    return _buildNotification(
      prayerName: prayerName,
      scheduledAt: now,
      preAlertMinutes: 0,
      isEnabled: template?.isEnabled ?? true,
      template: template,
    );
  }

  Map<String, dynamic> _updatedPayload(Map<String, dynamic> existing, String prayerName, int preAlertMinutes) {
    return {
      ...existing,
      'prayer': prayerName,
      'preAlertMinutes': preAlertMinutes,
      'languageCode': LocalizeAndTranslate.getLanguageCode(),
    };
  }

  Map<String, dynamic> _mergedPayload(Map<String, dynamic>? template, Map<String, dynamic>? existing) {
    return <String, dynamic>{...?template, ...?existing};
  }

  MLocalNotification _buildNotification({
    required String prayerName,
    required DateTime scheduledAt,
    required int preAlertMinutes,
    required bool isEnabled,
    PrayerNotificationTemplate? template,
  }) {
    final title = template?.title ?? prayerName.translated;
    final body = template?.body ?? _defaultPrayerBody(prayerName);
    return MLocalNotification(
      id: _notificationIdForPrayer(prayerName),
      title: title,
      body: body,
      scheduledAt: scheduledAt,
      repeatDaily: false,
      payload: _updatedPayload(_mergedPayload(template?.payload, <String, dynamic>{}), prayerName, preAlertMinutes),
      deepLink: template?.deepLink,
      isEnabled: isEnabled,
    );
  }

  String _defaultPrayerBody(String prayerName) {
    return '${'It is time for'.translated} ${prayerName.translated}';
  }

  Future<void> _refreshPrayerNotifications() async {
    if (_currentData == null) return;
    if (!_isToday(_selectedDate)) return;
    await _ensureNotificationSettings();
    final entries = _buildPrayerEntries();
    await _initNotificationsService.updateAzkarNotifications(
      fajrTime: _timeForPrayer(entries, 'Fajr'),
      maghribTime: _timeForPrayer(entries, 'Maghrib'),
    );
    for (final entry in entries) {
      await _schedulePrayerNotification(entry);
    }
  }

  Future<void> _reschedulePrayer(String prayerName) async {
    if (_currentData == null) return;
    if (!_isToday(_selectedDate)) return;
    final entry = _buildPrayerEntries().firstWhere(
      (item) => item.name == prayerName,
      orElse: () => PrayerTimeEntry(name: prayerName, time: '', dateTime: DateTime.now()),
    );
    if (entry.time.isEmpty) return;
    await _schedulePrayerNotification(entry);
  }

  Future<void> _schedulePrayerNotification(PrayerTimeEntry entry) async {
    final now = DateTime.now();
    final template = await _prayerNotificationsService.templateForPrayer(entry.name);
    final notification = _prayerNotifications[entry.name] ?? _defaultNotification(entry.name, template: template);
    final scheduledAt = entry.dateTime;
    final localized = notification.copyWith(
      title: template?.title ?? notification.title,
      body: template?.body ?? notification.body ?? _defaultPrayerBody(entry.name),
      scheduledAt: scheduledAt,
      payload: _updatedPayload(_mergedPayload(template?.payload, notification.payload), entry.name, 0),
      deepLink: template?.deepLink ?? notification.deepLink,
    );

    await _notificationService.cancelNotification(localized.id);
    if (!localized.isEnabled || !scheduledAt.isAfter(now)) {
      _prayerNotifications[entry.name] = localized;
      await _notificationStore.createUpdate(localized);
      return;
    }

    await _notificationService.scheduleNotification(
      notification: localized,
      androidAllowWhileIdle: true,
      // soundName: 'maka_azhan',
    );
    _prayerNotifications[entry.name] = localized;
    await _notificationStore.createUpdate(localized);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  DateTime? _timeForPrayer(List<PrayerTimeEntry> entries, String name) {
    for (final entry in entries) {
      if (entry.name == name) {
        return entry.dateTime;
      }
    }
    return null;
  }

  String _localizedValue({required String ar, required String en}) {
    final locale = LocalizeAndTranslate.getLanguageCode();
    if (locale == 'ar') {
      return ar.isNotEmpty ? ar : en;
    }
    return en.isNotEmpty ? en : ar;
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _nextPrayerCountdown = Duration.zero;
    _nextPrayerName = '';
  }

  String _mapError(Object error) {
    if (error is DioException) {
      return error.message ?? '';
    }
    return error.toString();
  }

  @override
  void dispose() {
    _cancelCountdown();
    super.dispose();
  }
}

class PrayerTimeEntry {
  const PrayerTimeEntry({required this.name, required this.time, required this.dateTime});

  final String name;
  final String time;
  final DateTime dateTime;
}
