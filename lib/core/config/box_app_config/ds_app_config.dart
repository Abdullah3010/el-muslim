import 'package:hive/hive.dart';
import 'package:al_muslim/core/config/box_app_config/box_app_config.dart';

class DSAppConfig {
  static final Box<String> _box = BoxAppConfig.box;

  static Future<void> delete() async {
    await _box.clear();
  }

  static String? getConfigValue(String key) {
    return _box.get(key);
  }

  static Future<String> setConfigValue(String key, String value) async {
    await _box.put(key, value);
    return value;
  }
}
