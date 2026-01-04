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
  List<MQuranIndex> filteredSurahs = [];
  bool isLoading = false;
  String? errorMessage;
  String searchQuery = '';

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
      _applySearch(notify: false);
    } catch (e) {
      errorMessage = 'Unable to load index'.translated;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectIndex(int index) {
    if (index < 0 || index >= surahs.length) return;
    final surah = surahs[index];
    Modular.to.pushNamed(RoutesNames.quran.quranMain, arguments: surah);
  }

  void selectSurah(MQuranIndex surah) {
    Modular.to.pushNamed(RoutesNames.quran.quranMain, arguments: surah);
  }

  void selectPage(int pageNumber) {
    if (pageNumber <= 0) return;
    Modular.to.pushNamed(
      RoutesNames.quran.quranMain,
      arguments: MQuranFirstPage(madani: pageNumber, indopak: pageNumber),
    );
  }

  void search(String query) {
    searchQuery = query;
    _applySearch();
  }

  void _applySearch({bool notify = true}) {
    final String normalizedQuery = _normalizeDigits(searchQuery.trim().toLowerCase());

    if (normalizedQuery.isEmpty) {
      filteredSurahs = List.of(surahs);
      notifyListeners();
      return;
    }

    filteredSurahs =
        surahs.where((surah) {
          final String number = surah.number.toString();
          return number.contains(normalizedQuery) ||
              surah.name.ar.toLowerCase().contains(normalizedQuery) ||
              surah.name.en.toLowerCase().contains(normalizedQuery) ||
              surah.name.transliteration.toLowerCase().contains(normalizedQuery);
        }).toList();

    if (notify) notifyListeners();
  }

  String _normalizeDigits(String input) {
    const Map<String, String> arabicIndicDigits = {
      '\u0660': '0',
      '\u0661': '1',
      '\u0662': '2',
      '\u0663': '3',
      '\u0664': '4',
      '\u0665': '5',
      '\u0666': '6',
      '\u0667': '7',
      '\u0668': '8',
      '\u0669': '9',
    };
    const Map<String, String> easternArabicIndicDigits = {
      '\u06F0': '0',
      '\u06F1': '1',
      '\u06F2': '2',
      '\u06F3': '3',
      '\u06F4': '4',
      '\u06F5': '5',
      '\u06F6': '6',
      '\u06F7': '7',
      '\u06F8': '8',
      '\u06F9': '9',
    };

    final StringBuffer buffer = StringBuffer();
    for (final int codeUnit in input.codeUnits) {
      final String char = String.fromCharCode(codeUnit);
      buffer.write(arabicIndicDigits[char] ?? easternArabicIndicDigits[char] ?? char);
    }
    return buffer.toString();
  }
}
