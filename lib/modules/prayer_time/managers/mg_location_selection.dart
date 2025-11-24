import 'package:al_muslim/modules/prayer_time/data/models/m_city_option.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MgLocationSelection extends ChangeNotifier {
  MgLocationSelection() {
    _load();
  }

  final String _countryAr = 'مصر';
  final String _countryEn = 'Egypt';

  final List<MCityOption> _cities = const [
    MCityOption(ar: 'القاهرة', en: 'Cairo'),
    MCityOption(ar: 'الإسكندرية', en: 'Alexandria'),
    MCityOption(ar: 'الجيزة', en: 'Giza'),
    MCityOption(ar: 'الأقصر', en: 'Luxor'),
    MCityOption(ar: 'أسوان', en: 'Aswan'),
    MCityOption(ar: 'المنصورة', en: 'Mansoura'),
    MCityOption(ar: 'طنطا', en: 'Tanta'),
    MCityOption(ar: 'الإسماعيلية', en: 'Ismailia'),
    MCityOption(ar: 'السويس', en: 'Suez'),
    MCityOption(ar: 'بورسعيد', en: 'Port Said'),
  ];

  List<MCityOption> filteredCities = [];
  String searchQuery = '';
  MCityOption? selectedCity;

  String get countryName => LocalizeAndTranslate.getLanguageCode() == 'ar' ? _countryAr : _countryEn;

  void _load() {
    filteredCities = List.of(_cities);
    notifyListeners();
  }

  void search(String query) {
    searchQuery = query;
    final String lang = LocalizeAndTranslate.getLanguageCode();
    filteredCities =
        query.isEmpty
            ? List.of(_cities)
            : _cities.where((city) => city.name(lang).toLowerCase().contains(query.toLowerCase())).toList();
    notifyListeners();
  }

  void selectCity(MCityOption city) {
    selectedCity = city;
    notifyListeners();
  }
}
