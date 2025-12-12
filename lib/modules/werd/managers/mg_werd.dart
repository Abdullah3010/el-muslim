import 'dart:convert';

import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_day.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_detail_segment.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/sources/local/werd_local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MgWerd extends ChangeNotifier {
  MgWerd({WerdLocalDataSource? localDataSource}) : _localDataSource = localDataSource ?? WerdLocalDataSource();

  final WerdLocalDataSource _localDataSource;
  final List<MWerdPlanOption> _options = [];
  final List<MWerdDay> _planDays = [];
  MWerdPlanOption? selectedOption;
  MWerdDay? selectedPlanDay;
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
  bool get hasData => _options.isNotEmpty;
  int get totalDays => selectedOption?.days ?? _planDays.length;
  int get finishedDaysCount => finishedDays.length;
  int get remainingDaysCount => totalDays - finishedDaysCount;
  double get progress => totalDays == 0 ? 0 : finishedDaysCount / totalDays;
  List<MWerdDetailSegment> get currentDaySegments =>
      selectedPlanDay?.toSegments() ?? const <MWerdDetailSegment>[];

  Future<void> initialize() async {
    await Future.wait([
      loadOptions(),
      loadSelectedPlan(),
    ]);
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
      _planDays.clear();
      selectedPlanDay = null;
      if (selectedOption != null) {
        await loadPlanDay();
      }
    } finally {
      isPlanLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectOption(MWerdPlanOption option) async {
    _planDays.clear();
    selectedPlanDay = null;
    selectedOption = option;
    await _localDataSource.saveSelectedPlan(option);
    await loadPlanDay();
    notifyListeners();
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
}
