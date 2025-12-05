import 'dart:async';

import 'package:al_muslim/core/config/box_app_config/box_app_config.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/routes/app_module.dart';
import 'package:al_muslim/modules/core/presentation/screens/app_entry_point.dart';
import 'package:al_muslim/modules/prayer_time/services/prayer_background_service.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );

    await LocalizeAndTranslate.init(
      assetLoader: const AssetLoaderRootBundleJson('assets/lang/'),
      defaultType: LocalizationDefaultType.asDefined,
      supportedLanguageCodes: ['ar', 'en'],
    );

    LocalizeAndTranslate.setLanguageCode('ar');

    try {
      await Hive.initFlutter('al_muslim_data');
    } catch (e) {
      debugPrint(e.toString());
    }

    await BoxAppConfig.init();
    try {
      final notificationService = LocalNotificationService();
      await notificationService.initialize(androidDefaultIcon: '@mipmap/ic_launcher');
      await notificationService.handleInitialNotificationIfPresent();

      final prayerBackgroundService = PrayerBackgroundService();
      await prayerBackgroundService.initializeBackgroundSync();
      await prayerBackgroundService.scheduleTodayPrayers();
    } catch (error, stackTrace) {
      debugPrint('Failed to initialize background services: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => ModularApp(module: AppModule(), child: const AppEntryPoint()),
      ),
    );
  }, (error, stackTrace) {});
}
