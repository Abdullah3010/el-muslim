import 'dart:convert';

import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_day.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_detail_segment.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/sources/local/werd_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MgWerd extends ChangeNotifier {
  MgWerd({WerdLocalDataSource? localDataSource, LocalNotificationService? notificationService})
    : _localDataSource = localDataSource ?? WerdLocalDataSource(),
      _notificationService = notificationService ?? LocalNotificationService();

  final WerdLocalDataSource _localDataSource;
  final LocalNotificationService _notificationService;
  final List<MWerdPlanOption> _options = [];
  final List<MWerdDay> _planDays = [];
  MWerdPlanOption? selectedOption;
  MWerdDay? selectedPlanDay;
  DateTime? planStartDate;
  bool isLoading = false;
  bool isPlanLoading = false;
  bool isPlanDetailsLoading = false;
  String? errorMessage;
  String? planDetailsError;

  List<MWerdPlanOption> get options => List.unmodifiable(_options);
  List<MWerdPlanOption> get suggestedOptions => _options.where((option) => option.isSuggested).toList();
  List<MWerdPlanOption> get otherOptions => _options.where((option) => !option.isSuggested).toList();
  List<MWerdDay> get planDays => List.unmodifiable(_planDays);
  List<MWerdDay> get finishedDays => _planDays.where((day) => day.isFinished).toList();
  List<MWerdDay> get upcomingDays => _planDays.where((day) => !day.isFinished).toList();
  List<MLocalNotification> get notificationReminders => List.unmodifiable(selectedOption?.notifications ?? const []);
  MLocalNotification? get primaryNotification => notificationReminders.isNotEmpty ? notificationReminders.first : null;
  bool get hasData => _options.isNotEmpty;
  int get totalDays => selectedOption?.days ?? _planDays.length;
  int get finishedDaysCount => finishedDays.length;
  int get remainingDaysCount => totalDays - finishedDaysCount;
  double get progress => totalDays == 0 ? 0 : finishedDaysCount / totalDays;
  List<MWerdDetailSegment> get currentDaySegments => selectedPlanDay?.toSegments() ?? const <MWerdDetailSegment>[];
  int get currentLateDays => _calculateLateDays(DateTime.now());

  Future<void> initialize() async {
    await Future.wait([loadOptions(), loadSelectedPlan()]);
  }

  Future<void> loadOptions() async {
    if (isLoading || (hasData && errorMessage == null)) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString('assets/json/khatma/khatma_metadata.json');
      final decoded = json.decode(jsonString) as List<dynamic>;
      _options
        ..clear()
        ..addAll(decoded.whereType<Map<String, dynamic>>().map(MWerdPlanOption.fromJson));
    } catch (e) {
      errorMessage = 'Unable to load werd options'.translated;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSelectedPlan() async {
    isPlanLoading = true;
    notifyListeners();

    try {
      selectedOption = await _localDataSource.getSelectedPlan();
      planStartDate = selectedOption != null ? await _localDataSource.getPlanStartDate() : null;
      _planDays.clear();
      selectedPlanDay = null;
      if (selectedOption != null) {
        await _restoreNotifications();
        await loadPlanDay();
      }
    } finally {
      isPlanLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectOption(MWerdPlanOption option) async {
    try {
      _planDays.clear();
      selectedPlanDay = null;
      selectedOption = option;
      final now = DateTime.now();
      planStartDate = now;
      await _localDataSource.savePlanStartDate(now);
      await _ensureDefaultNotification();
      if (selectedOption != null) {
        await _localDataSource.saveSelectedPlan(selectedOption!);
      }
      await loadPlanDay();
      notifyListeners();
    } catch (e, st) {
      print(" ====>>>> Error in selectOption: $e");
      print(" ====>>>> Error in selectOption: $st");
    }
  }

  Future<void> loadPlanDay({int? dayNumber}) async {
    final plan = selectedOption;
    if (plan == null) return;

    if (_planDays.isNotEmpty) {
      selectedPlanDay = _chooseDay(focusDay: dayNumber);
      notifyListeners();
      return;
    }

    if (plan.planDays.isNotEmpty) {
      _planDays
        ..clear()
        ..addAll(plan.planDays);
      selectedPlanDay = _chooseDay(focusDay: dayNumber);
      notifyListeners();
      return;
    }

    isPlanDetailsLoading = true;
    planDetailsError = null;
    notifyListeners();

    try {
      await _hydratePlan(plan, focusDay: dayNumber);
    } catch (e) {
      planDetailsError = 'Unable to load werd plan details'.translated;
      _planDays.clear();
      selectedPlanDay = null;
    } finally {
      isPlanDetailsLoading = false;
      notifyListeners();
    }
  }

  Future<void> openDay(int dayNumber) => loadPlanDay(dayNumber: dayNumber);

  Future<void> markCurrentDayFinished() async {
    final plan = selectedOption;
    final current = selectedPlanDay;
    if (plan == null || current == null) return;

    final index = _planDays.indexWhere((day) => day.dayNumber == current.dayNumber);
    if (index == -1) return;

    _planDays[index] = current.copyWith(isFinished: true);
    selectedPlanDay = _chooseDay();
    final updatedPlan = plan.copyWith(planDays: List<MWerdDay>.unmodifiable(_planDays));
    selectedOption = updatedPlan;

    await _persistPlanState(updatedPlan);
    notifyListeners();
  }

  Future<void> addNotification(TimeOfDay time) async {
    final plan = selectedOption;
    if (plan == null) return;

    final scheduledAt = _dateFromTime(time);
    final notification = _buildNotification(plan, scheduledAt);
    await _upsertNotification(notification);
    notifyListeners();
  }

  Future<void> updateNotificationTime(int notificationId, TimeOfDay time) async {
    final notification = _notificationById(notificationId);
    if (notification == null) return;

    final updated = notification.copyWith(scheduledAt: _dateFromTime(time));
    await _upsertNotification(updated);
    notifyListeners();
  }

  Future<void> toggleNotification(int notificationId, bool isEnabled) async {
    final notification = _notificationById(notificationId);
    if (notification == null || notification.isEnabled == isEnabled) return;

    final updated = notification.copyWith(isEnabled: isEnabled);
    await _upsertNotification(updated);
    notifyListeners();
  }

  Future<void> deleteNotification(int notificationId) async {
    final plan = selectedOption;
    if (plan == null) return;

    final updatedNotifications = plan.notifications.where((n) => n.id != notificationId).toList();
    selectedOption = plan.copyWith(
      planDays: plan.planDays,
      notifications: List<MLocalNotification>.unmodifiable(updatedNotifications),
    );

    await _notificationService.cancelNotification(notificationId);
    await _localDataSource.deleteNotification(notificationId);
    await _persistPlanState(selectedOption!);
    notifyListeners();
  }

  MWerdDay? _chooseDay({int? focusDay}) {
    if (_planDays.isEmpty) return null;

    if (focusDay != null) {
      try {
        return _planDays.firstWhere((day) => day.dayNumber == focusDay);
      } catch (_) {}
    }

    try {
      return _planDays.firstWhere((day) => !day.isFinished);
    } catch (_) {
      return _planDays.last;
    }
  }

  Future<void> _hydratePlan(MWerdPlanOption plan, {int? focusDay}) async {
    final jsonString = await rootBundle.loadString(plan.assetPath);
    final decoded = json.decode(jsonString) as Map<String, dynamic>;
    final savedDays = await _localDataSource.getPlanDays(plan.id);
    final persistedDays = savedDays.isNotEmpty ? savedDays : plan.planDays;
    final savedStatus = {for (final day in persistedDays) day.dayNumber: day.isFinished};
    final parsedDays = <MWerdDay>[];

    decoded.forEach((key, value) {
      final match = RegExp(r'day_(\d+)').firstMatch(key);
      if (match == null) return;

      final dayNumber = int.tryParse(match.group(1) ?? '');
      if (dayNumber == null || value is! Map<String, dynamic>) return;

      final isFinished = savedStatus[dayNumber] ?? false;
      parsedDays.add(MWerdDay.fromJson(dayNumber, value, isFinished: isFinished));
    });

    parsedDays.sort((a, b) => a.dayNumber.compareTo(b.dayNumber));

    _planDays
      ..clear()
      ..addAll(parsedDays);

    selectedPlanDay = _chooseDay(focusDay: focusDay);
    selectedOption = plan.copyWith(planDays: List<MWerdDay>.unmodifiable(_planDays));
    await _persistPlanState(selectedOption!);
  }

  Future<void> _persistPlanState(MWerdPlanOption plan) async {
    await _localDataSource.savePlanDays(plan.id, _planDays);
    await _localDataSource.saveSelectedPlan(plan);
  }

  Future<void> deleteCurrentWerdPlan() async {
    final plan = selectedOption;
    if (plan == null) return;

    for (final notification in plan.notifications) {
      await _notificationService.cancelNotification(notification.id);
      await _localDataSource.deleteNotification(notification.id);
    }

    _planDays.clear();
    selectedPlanDay = null;
    selectedOption = null;
    planStartDate = null;
    await _localDataSource.clearSelectedPlan();
    await _localDataSource.clearPlanStartDate();
    notifyListeners();
  }

  Future<void> _restoreNotifications() async {
    final plan = selectedOption;
    if (plan == null) return;

    final notifications = plan.notifications;
    if (notifications.isEmpty) {
      await _ensureDefaultNotification();
      return;
    }

    await _localDataSource.saveNotifications(notifications);
    for (final notification in notifications) {
      if (notification.isEnabled) {
        await _notificationService.scheduleNotification(notification: notification);
      } else {
        await _notificationService.cancelNotification(notification.id);
      }
    }
  }

  Future<void> _ensureDefaultNotification() async {
    final plan = selectedOption;
    if (plan == null || plan.notifications.isNotEmpty) return;

    final notification = _buildNotification(plan, _defaultNotificationTime());
    await _upsertNotification(notification);
  }

  Future<void> _upsertNotification(MLocalNotification notification) async {
    final plan = selectedOption;
    if (plan == null) return;

    final List<MLocalNotification> updatedNotifications = List.of(plan.notifications);
    final index = updatedNotifications.indexWhere((element) => element.id == notification.id);
    if (index >= 0) {
      updatedNotifications[index] = notification;
    } else {
      updatedNotifications.add(notification);
    }

    final updatedPlan = plan.copyWith(
      planDays: plan.planDays,
      notifications: List<MLocalNotification>.unmodifiable(updatedNotifications),
    );
    selectedOption = updatedPlan;

    await _localDataSource.saveNotification(notification);
    if (notification.isEnabled) {
      await _notificationService.scheduleNotification(notification: notification);
    } else {
      await _notificationService.cancelNotification(notification.id);
    }
    await _persistPlanState(updatedPlan);
  }

  MLocalNotification _buildNotification(MWerdPlanOption plan, DateTime scheduledAt) {
    final reminderTitle = 'Daily Werd Reminder'.translated;
    return MLocalNotification(
      id: _generateNotificationId(),
      title: reminderTitle.isEmpty ? 'Daily Werd Reminder' : reminderTitle,
      body: plan.titleEn,
      scheduledAt: scheduledAt,
      repeatDaily: true,
      payload: {'planId': plan.id},
      deepLink: RoutesNames.werd.werdMain,
    );
  }

  DateTime _defaultNotificationTime() {
    final now = DateTime.now();
    final scheduled = DateTime(now.year, now.month, now.day, 8);
    if (scheduled.isAfter(now)) return scheduled;
    return scheduled.add(const Duration(days: 1));
  }

  DateTime _dateFromTime(TimeOfDay time) {
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (date.isBefore(now)) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  MLocalNotification? _notificationById(int id) {
    final plan = selectedOption;
    if (plan == null) return null;
    try {
      return plan.notifications.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  int _generateNotificationId() {
    final plan = selectedOption;
    final usedIds = <int>{};
    if (plan != null) {
      usedIds.addAll(plan.notifications.map((n) => n.id));
    }
    var candidate = Constants.werdNotificationBaseId;
    while (usedIds.contains(candidate)) {
      candidate++;
      if (candidate > 0xFFFFFFFF) {
        candidate = Constants.werdNotificationBaseId;
      }
    }
    return candidate;
  }

  int _calculateLateDays(DateTime now) {
    final start = planStartDate;
    final day = selectedPlanDay;
    if (start == null || day == null) return 0;
    final startDate = DateTime(start.year, start.month, start.day);
    final currentDate = DateTime(now.year, now.month, now.day);
    final daysSinceStart = currentDate.difference(startDate).inDays;
    if (daysSinceStart < 0) return 0;
    final expectedDay = daysSinceStart + 1;
    final lateDays = expectedDay - day.dayNumber;
    return lateDays > 0 ? lateDays : 0;
  }
}
