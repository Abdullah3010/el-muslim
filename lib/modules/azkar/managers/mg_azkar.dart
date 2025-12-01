import 'dart:convert';

import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/modules/azkar/data/models/m_azkar_categories.dart';
import 'package:al_muslim/modules/azkar/data/models/m_zekr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MgAzkar extends ChangeNotifier {
  List<MAzkarCategories> categories = [];

  List<MZekr> activeAzkarList = [];

  Future<void> loadAzkarCategories() async {
    final jsonString = await rootBundle.loadString(Assets.json.azkar.azkarCatigories);
    categories = (json.decode(jsonString) as List).map((e) => MAzkarCategories.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> loadAzkarByCategory(int categoryId) async {
    activeAzkarList.clear();

    notifyListeners();
    final category = categories.firstWhere((cat) => cat.id == categoryId, orElse: () => MAzkarCategories());
    final jsonString = await rootBundle.loadString(category.filePath);
    activeAzkarList = (json.decode(jsonString) as List).map((e) => MZekr.fromJson(e)).toList();
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

  void resetZekrProgress() {
    currentZekrIndexNotifier = 0;
    currentZekrCount = 0;
    notifyListeners();
  }
}
