import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';

class QuranReadingTimeService {
  QuranReadingTimeService._();
  static final QuranReadingTimeService _instance = QuranReadingTimeService._();
  static QuranReadingTimeService get instance => _instance;

  DateTime? _sessionStartTime;

  void startSession() {
    _sessionStartTime = DateTime.now();
  }

  Future<void> endSession() async {
    if (_sessionStartTime == null) return;

    final sessionDuration = DateTime.now().difference(_sessionStartTime!);
    _sessionStartTime = null;

    final currentTotalSeconds = getTotalReadingTimeSeconds();
    final newTotalSeconds = currentTotalSeconds + sessionDuration.inSeconds;

    await DSAppConfig.setConfigValue(Constants.configKeys.quranReadingTimeSeconds, newTotalSeconds.toString());
  }

  int getTotalReadingTimeSeconds() {
    final stored = DSAppConfig.getConfigValue(Constants.configKeys.quranReadingTimeSeconds);
    if (stored == null || stored.isEmpty) return 0;
    return int.tryParse(stored) ?? 0;
  }

  Duration getTotalReadingTime() {
    return Duration(seconds: getTotalReadingTimeSeconds());
  }

  String getFormattedTotalTime() {
    final duration = getTotalReadingTime();
    final hours = duration.inHours;
    final hourLabel = 'Hour'.translated;

    return '$hours $hourLabel';
  }

  Future<void> resetReadingTime() async {
    await DSAppConfig.setConfigValue(Constants.configKeys.quranReadingTimeSeconds, '0');
  }
}
