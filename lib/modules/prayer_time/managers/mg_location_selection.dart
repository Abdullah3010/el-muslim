import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/modules/prayer_time/data/local/box_location_cities_cache.dart';
import 'package:al_muslim/modules/prayer_time/data/local/ds_location_cities_cache.dart';
import 'package:al_muslim/modules/prayer_time/data/models/m_city_option.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MgLocationSelection extends ChangeNotifier {
  MgLocationSelection({Dio? dio, BoxLocationCitiesCache? citiesBox, DSLocationCitiesCache? citiesStore})
    : _dio = dio ?? Dio(BaseOptions(followRedirects: true, validateStatus: (status) => status != null && status < 400)),
      _citiesBox = citiesBox ?? BoxLocationCitiesCache() {
    _citiesStore = citiesStore ?? DSLocationCitiesCache(_citiesBox);
  }

  final Dio _dio;
  final BoxLocationCitiesCache _citiesBox;
  late final DSLocationCitiesCache _citiesStore;
  bool _citiesBoxReady = false;
  List<MCityOption> _cities = [];
  final Map<String, String> _localizedCityCache = {};

  List<MCityOption> filteredCities = [];
  String searchQuery = '';
  MCityOption? selectedCity;
  bool _isLoading = false;
  String? _errorMessage;
  String _countryDisplayName = '';
  String _countryApiName = '';

  String get countryName =>
      _countryDisplayName.isNotEmpty ? _countryDisplayName : (_countryApiName.isNotEmpty ? _countryApiName : '');
  String get countryApiName => _countryApiName.isNotEmpty ? _countryApiName : _countryDisplayName;
  String get countryDisplayName => _countryDisplayName.isNotEmpty ? _countryDisplayName : _countryApiName;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasCities => _cities.isNotEmpty;

  void beginLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> loadForLocation({
    required double latitude,
    required double longitude,
    required String countryDisplayName,
  }) async {
    await _ensureCitiesBoxReady();
    _countryDisplayName = countryDisplayName;
    _errorMessage = null;
    _isLoading = true;
    searchQuery = '';
    notifyListeners();

    if (latitude == 0 && longitude == 0 && countryDisplayName.isEmpty) {
      _isLoading = false;
      _errorMessage = 'Location unavailable'.translated;
      notifyListeners();
      return;
    }

    var resolvedCountry = countryDisplayName;
    try {
      try {
        await setLocaleIdentifier('en');
      } catch (_) {}
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      final placemark = placemarks.isNotEmpty ? placemarks.first : null;
      if (placemark?.country != null && placemark!.country!.isNotEmpty) {
        resolvedCountry = placemark.country!;
      }
    } catch (_) {}
    _countryApiName = resolvedCountry;

    try {
      final languageCode = LocalizeAndTranslate.getLanguageCode();
      final cached = _citiesStore.getCurrent();
      if (_isCacheValid(cached, resolvedCountry, languageCode)) {
        _cities = _citiesFromCache(cached!);
        _countryDisplayName = _cachedDisplayName(cached, fallback: _countryDisplayName);
        _isLoading = false;
        filteredCities = _filterCities(searchQuery);
        notifyListeners();
        return;
      }
      if (cached != null) {
        await _citiesStore.clear();
      }

      final response = await _dio.get(
        'https://countriesnow.space/api/v0.1/countries/cities/q',
        queryParameters: {'country': resolvedCountry},
      );
      final data = response.data;
      final cities = data is Map<String, dynamic> ? data['data'] : null;
      if (cities is List) {
        final rawCities =
            cities.whereType<String>().map((city) => city.trim()).where((city) => city.isNotEmpty).toList();
        final locale = languageCode;
        if (locale != 'en') {
          final localized = <MCityOption>[];
          for (final city in rawCities) {
            final localizedName = await _resolveLocalizedCityName(city: city, country: resolvedCountry, locale: locale);
            localized.add(MCityOption(ar: localizedName, en: city));
          }
          _cities = localized;
        } else {
          _cities = rawCities.map((city) => MCityOption(ar: city, en: city)).toList();
        }
        await _citiesStore.saveCurrent(_buildCachePayload(resolvedCountry, locale, _countryDisplayName, _cities));
      } else {
        _cities = [];
        _errorMessage = 'Unable to load cities'.translated;
      }
    } catch (error) {
      _cities = [];
      _errorMessage = 'Unable to load cities'.translated;
    } finally {
      _isLoading = false;
      filteredCities = _filterCities(searchQuery);
      notifyListeners();
    }
  }

  void search(String query) {
    searchQuery = query;
    filteredCities = _filterCities(query);
    notifyListeners();
  }

  List<MCityOption> _filterCities(String query) {
    final String lang = LocalizeAndTranslate.getLanguageCode();
    if (query.isEmpty) {
      return List.of(_cities);
    }
    return _cities.where((city) => city.name(lang).toLowerCase().contains(query.toLowerCase())).toList();
  }

  void selectCity(MCityOption city) {
    selectedCity = city;
    notifyListeners();
  }

  Future<void> _ensureCitiesBoxReady() async {
    if (_citiesBoxReady) return;
    await _citiesBox.init();
    _citiesBoxReady = true;
  }

  bool _isCacheValid(Map<String, dynamic>? cached, String country, String languageCode) {
    if (cached == null) return false;
    final cachedCountry = cached['country']?.toString() ?? '';
    final cachedLanguage = cached['languageCode']?.toString() ?? '';
    return cachedCountry == country && cachedLanguage == languageCode;
  }

  List<MCityOption> _citiesFromCache(Map<String, dynamic> cached) {
    final raw = cached['cities'];
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((entry) => MCityOption(ar: entry['ar']?.toString() ?? '', en: entry['en']?.toString() ?? ''))
        .where((city) => city.en.isNotEmpty)
        .toList();
  }

  String _cachedDisplayName(Map<String, dynamic> cached, {required String fallback}) {
    final cachedName = cached['countryDisplayName']?.toString() ?? '';
    return cachedName.isNotEmpty ? cachedName : fallback;
  }

  Map<String, dynamic> _buildCachePayload(
    String country,
    String languageCode,
    String countryDisplayName,
    List<MCityOption> cities,
  ) {
    return {
      'country': country,
      'languageCode': languageCode,
      'countryDisplayName': countryDisplayName,
      'updatedAt': DateTime.now().toIso8601String(),
      'cities': cities.map((city) => {'en': city.en, 'ar': city.ar}).toList(),
    };
  }

  Future<String> _resolveLocalizedCityName({
    required String city,
    required String country,
    required String locale,
  }) async {
    final cacheKey = '$locale|$country|$city';
    final cached = _localizedCityCache[cacheKey];
    if (cached != null && cached.isNotEmpty) {
      return cached;
    }
    try {
      try {
        await setLocaleIdentifier('en');
      } catch (_) {}
      final locations = await locationFromAddress('$city, $country');
      if (locations.isEmpty) {
        return city;
      }
      if (locale != 'en') {
        try {
          await setLocaleIdentifier(locale);
        } catch (_) {}
      }
      final placemarks = await placemarkFromCoordinates(locations.first.latitude, locations.first.longitude);
      final placemark = placemarks.isNotEmpty ? placemarks.first : null;
      final localized = placemark?.locality ?? placemark?.subAdministrativeArea ?? placemark?.administrativeArea ?? '';
      final resolved = localized.isNotEmpty ? localized : city;
      _localizedCityCache[cacheKey] = resolved;
      return resolved;
    } catch (_) {
      return city;
    }
  }
}
