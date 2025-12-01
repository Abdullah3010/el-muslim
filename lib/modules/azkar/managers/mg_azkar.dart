import 'dart:convert';

import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/modules/azkar/data/models/m_azkar_categories.dart';
import 'package:al_muslim/modules/azkar/data/models/m_zekr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MgAzkar extends ChangeNotifier {
  List<MAzkarCategories> categories = [];

  List<MZekr> activeAzkarList = [];
  final Map<String, List<MZekr>> _groupedAzkar = {};
  final List<String> groupedAzkarKeys = [];
  String? selectedGroupedKey;

  Future<void> loadAzkarCategories() async {
    final jsonString = await rootBundle.loadString(Assets.json.azkar.azkarCatigories);
    categories = (json.decode(jsonString) as List).map((e) => MAzkarCategories.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> loadAzkarByCategory(int categoryId) async {
    try {
      activeAzkarList.clear();
      _groupedAzkar.clear();
      groupedAzkarKeys.clear();
      selectedGroupedKey = null;
      resetZekrProgress(shouldNotify: false);

      final category = categories.firstWhere((cat) => cat.id == categoryId, orElse: () => MAzkarCategories());
      final jsonString = await rootBundle.loadString(category.filePath);

      final decoded = json.decode(jsonString);
      if (decoded is List) {
        activeAzkarList = decoded.map((e) => MZekr.fromJson(e as Map<String, dynamic>?)).toList();
      } else if (decoded is Map<String, dynamic>) {
        decoded.forEach((key, value) {
          final azkarList = (value as List).map((item) => MZekr.fromJson(item as Map<String, dynamic>?)).toList();
          _groupedAzkar[key] = azkarList;
          groupedAzkarKeys.add(key);
        });
        activeAzkarList.clear();
      } else {
        activeAzkarList.clear();
      }

      notifyListeners();
    } catch (e, st) {
      print('Error loading azkar by category: $e');
      print(st);
    }
  }

  bool get isGroupedCategory => groupedAzkarKeys.isNotEmpty;

  void selectGroupedAzkar(String key) {
    final azkar = _groupedAzkar[key];
    if (azkar == null) return;
    selectedGroupedKey = key;
    activeAzkarList
      ..clear()
      ..addAll(azkar);
    resetZekrProgress(shouldNotify: false);
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    notifyListeners();
  }

  void clearGroupedSelection() {
    activeAzkarList.clear();
    selectedGroupedKey = null;
    resetZekrProgress(shouldNotify: false);
    notifyListeners();
  }

  int currentZekrIndexNotifier = 0;
  int currentZekrCount = 0;
  PageController pageController = PageController();
  void updateCurrentZekrIndex(int index) {
    currentZekrIndexNotifier = index;
    pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    notifyListeners();
  }

  void updateCurrentZekrCount(int count) {
    currentZekrCount = count;
    notifyListeners();
  }

  void resetZekrProgress({bool shouldNotify = true}) {
    currentZekrIndexNotifier = 0;
    currentZekrCount = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    if (shouldNotify) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
