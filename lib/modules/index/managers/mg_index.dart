import 'dart:convert';

import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MgIndex extends ChangeNotifier {
  final List<MQuranIndex> surahs = [];
  bool isLoading = false;
  String? errorMessage;

  bool get hasData => surahs.isNotEmpty;

  Future<void> loadIndex() async {
    if (isLoading) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString(Assets.json.quran.quranIndex);
      final decoded = json.decode(jsonString) as List<dynamic>;
      surahs
        ..clear()
        ..addAll(decoded.whereType<Map<String, dynamic>>().map((jsonMap) => MQuranIndex.fromJson(jsonMap)).toList());
    } catch (e) {
      errorMessage = 'Unable to load index'.translated;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectIndex(int index) {
    if (index < 0 || index >= surahs.length) return;
    final firstPage = surahs[index].firstPage;
    Modular.to.pushNamed(
      RoutesNames.quran.quranMain,
      arguments: firstPage,
    );
  }
}
