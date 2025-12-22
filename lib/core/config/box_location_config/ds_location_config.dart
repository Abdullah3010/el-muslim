import 'package:al_muslim/core/config/box_location_config/box_location_config.dart';
import 'package:al_muslim/core/config/box_location_config/m_location_config.dart';

class DSLocationConfig {
  DSLocationConfig(this._box);

  static const String _currentKey = 'current_location';

  final BoxLocationConfig _box;

  MLocationConfig? getCurrent() => _box.box.get(_currentKey);

  Future<void> saveCurrent(MLocationConfig config) async {
    await _box.box.put(_currentKey, config);
  }

  bool getAutoDetectEnabled() => getCurrent()?.autoDetect ?? true;

  Future<void> setAutoDetectEnabled(bool enabled) async {
    final current = getCurrent();
    if (current != null) {
      await saveCurrent(current.copyWith(autoDetect: enabled, updatedAt: DateTime.now()));
      return;
    }
    await saveCurrent(
      MLocationConfig(
        latitude: 0,
        longitude: 0,
        city: '',
        country: '',
        updatedAt: DateTime.now(),
        autoDetect: enabled,
      ),
    );
  }
}
