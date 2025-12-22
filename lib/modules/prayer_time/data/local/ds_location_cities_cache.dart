import 'package:al_muslim/modules/prayer_time/data/local/box_location_cities_cache.dart';

class DSLocationCitiesCache {
  DSLocationCitiesCache(this._box);

  static const String _cacheKey = 'cities_cache';

  final BoxLocationCitiesCache _box;

  Map<String, dynamic>? getCurrent() {
    final value = _box.box.get(_cacheKey);
    if (value is Map) {
      return Map<String, dynamic>.from(value.cast<String, dynamic>());
    }
    return null;
  }

  Future<void> saveCurrent(Map<String, dynamic> value) async {
    await _box.box.put(_cacheKey, Map<String, dynamic>.from(value));
  }

  Future<void> clear() async {
    await _box.box.delete(_cacheKey);
  }
}
