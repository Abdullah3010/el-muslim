import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/models/m_prayer_time_response.dart';
import '../data/params/p_prayer_time_params.dart';
import '../sources/remote/prayer_time_remote_source.dart';

enum PrayerTimeStatus { initial, loading, success, error }

class MgPrayerTime extends ChangeNotifier {
  MgPrayerTime({PrayerTimeRemoteSource? remoteSource}) : _remoteSource = remoteSource ?? PrayerTimeRemoteSource();

  static const _defaultParams = PPrayerTimeParams(lat: 30.04442, lon: 31.235712, method: 5, school: 1);
  static final _cacheDateFormat = DateFormat('yyyy-MM-dd');

  final PrayerTimeRemoteSource _remoteSource;
  final Map<String, MPrayerTime> _cache = {};

  PrayerTimeStatus _status = PrayerTimeStatus.initial;
  MPrayerTime? _currentData;
  DateTime _selectedDate = DateTime.now();
  String? _errorMessage;
  String _nextPrayerName = '';
  Duration _nextPrayerCountdown = Duration.zero;
  Timer? _countdownTimer;
  List<String> prayerNames = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  PrayerTimeStatus get status => _status;
  bool get isLoading => _status == PrayerTimeStatus.loading;
  String? get errorMessage => _errorMessage;
  DateTime get selectedDate => _selectedDate;
  MPrayerTime? get currentData => _currentData;
  bool get hasData => _currentData != null;
  String get nextPrayerName => _nextPrayerName;
  Duration get nextPrayerCountdown => _nextPrayerCountdown;

  String get hijriDateLabel {
    final hijri = _currentData?.date.hijri;
    if (hijri == null) return '';
    final weekday = hijri.weekday.ar.isNotEmpty ? hijri.weekday.ar : hijri.weekday.en;
    final month = hijri.month.ar.isNotEmpty ? hijri.month.ar : hijri.month.en;
    final yearSuffix = hijri.year.isNotEmpty ? ' هـ' : '';
    return [weekday, hijri.day, month, hijri.year].where((element) => element.isNotEmpty).join(' ') + yearSuffix;
  }

  String get gregorianDateLabel {
    final gregorian = _currentData?.date.gregorian;
    if (gregorian == null) return '';
    final weekday = gregorian.weekday.en;
    final month = gregorian.month.en;
    return [weekday, gregorian.day, month, gregorian.year].where((element) => element.isNotEmpty).join(' ');
  }

  String get readableDate => _currentData?.date.readable ?? '';

  Future<void> loadPrayerTimes({DateTime? forDate}) async {
    final targetDate = _normalizeDate(forDate ?? _selectedDate);
    _selectedDate = targetDate;
    final cacheKey = _cacheDateFormat.format(_selectedDate);

    if (_cache.containsKey(cacheKey)) {
      _currentData = _cache[cacheKey];
      _status = PrayerTimeStatus.success;
      _errorMessage = null;
      _startCountdown();
      notifyListeners();
      return;
    }

    _status = PrayerTimeStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _remoteSource.fetchPrayerTimes(_defaultParams, date: _selectedDate);
      _currentData = response;
      _cache[cacheKey] = _currentData!;
      _status = PrayerTimeStatus.success;
      _startCountdown();
    } catch (error) {
      _status = PrayerTimeStatus.error;
      _errorMessage = _mapError(error);
      _cancelCountdown();
    }

    notifyListeners();
  }

  Future<void> goToPreviousDay() async => loadPrayerTimes(forDate: _selectedDate.subtract(const Duration(days: 1)));

  Future<void> goToNextDay() async => loadPrayerTimes(forDate: _selectedDate.add(const Duration(days: 1)));

  List<PrayerTimeEntry> get prayerTimeEntries => _buildPrayerEntries();

  void _startCountdown() {
    _countdownTimer?.cancel();
    _updateNextPrayerInfo(notify: false);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) => _updateNextPrayerInfo());
  }

  void _updateNextPrayerInfo({bool notify = true}) {
    final entries = _buildPrayerEntries();
    if (entries.isEmpty) {
      _nextPrayerName = '';
      _nextPrayerCountdown = Duration.zero;
      if (notify) notifyListeners();
      return;
    }

    final now = DateTime.now();
    final upcoming = entries.firstWhere(
      (entry) => entry.dateTime.isAfter(now),
      orElse: () {
        final first = entries.first;
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
    final data = _currentData;
    if (data == null) return [];

    final baseDate = _selectedDate;
    const displayOrder = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    return displayOrder
        .map((name) {
          final time = data.times.raw[name];
          if (time == null || time.isEmpty) return null;
          return PrayerTimeEntry(name: name, time: time, dateTime: _parseDateTime(baseDate, time));
        })
        .whereType<PrayerTimeEntry>()
        .toList();
  }

  DateTime _parseDateTime(DateTime baseDate, String time) {
    final parts = time.split(':');
    final hour = int.tryParse(parts.elementAt(0)) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts.elementAt(1)) ?? 0 : 0;
    return DateTime(baseDate.year, baseDate.month, baseDate.day, hour, minute);
  }

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _nextPrayerCountdown = Duration.zero;
    _nextPrayerName = '';
  }

  String _mapError(Object error) {
    if (error is DioError) {
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
