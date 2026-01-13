import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class KhatmaCompletionService {
  KhatmaCompletionService._();
  static final KhatmaCompletionService _instance = KhatmaCompletionService._();
  static KhatmaCompletionService get instance => _instance;

  Future<void> recordKhatmaCompletion() async {
    final currentCount = getCompletedKhatmasCount();
    final newCount = currentCount + 1;

    await DSAppConfig.setConfigValue(Constants.configKeys.completedKhatmasCount, newCount.toString());

    await DSAppConfig.setConfigValue(Constants.configKeys.lastKhatmaCompletionDate, DateTime.now().toIso8601String());
  }

  int getCompletedKhatmasCount() {
    final stored = DSAppConfig.getConfigValue(Constants.configKeys.completedKhatmasCount);
    if (stored == null || stored.isEmpty) return 0;
    return int.tryParse(stored) ?? 0;
  }

  String getFormattedKhatmasCount() {
    return getCompletedKhatmasCount().toString().translateNumbers();
  }

  DateTime? getLastCompletionDate() {
    final stored = DSAppConfig.getConfigValue(Constants.configKeys.lastKhatmaCompletionDate);
    if (stored == null || stored.isEmpty) return null;
    return DateTime.tryParse(stored);
  }

  String getFormattedLastCompletionDate() {
    final date = getLastCompletionDate();
    if (date == null) return '-';

    final isArabic = LocalizeAndTranslate.getLanguageCode() == 'ar';
    final locale = isArabic ? 'ar' : 'en';
    final formatter = DateFormat.yMMMd(locale);
    return formatter.format(date);
  }

  Future<void> resetKhatmaStats() async {
    await DSAppConfig.setConfigValue(Constants.configKeys.completedKhatmasCount, '0');
    await DSAppConfig.setConfigValue(Constants.configKeys.lastKhatmaCompletionDate, '');
  }
}
