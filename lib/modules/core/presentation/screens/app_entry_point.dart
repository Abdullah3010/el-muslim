import 'dart:async';

import 'package:al_muslim/core/config/box_location_config/ds_location_config.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/config/box_location_config/box_location_config.dart';
import 'package:al_muslim/modules/prayer_time/data/local/box_location_cities_cache.dart';
import 'package:al_muslim/modules/azkar/managers/mg_azkar.dart';
import 'package:al_muslim/modules/core/managers/mg_core.dart';
import 'package:al_muslim/modules/index/managers/mg_index.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_location_selection.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_prayer_time.dart';
import 'package:al_muslim/modules/quran/managers/mg_quran.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/theme/app_themes.dart';
import 'package:al_muslim/core/widgets/w_logger_icon.dart';
import 'package:toastification/toastification.dart';
import 'package:provider/provider.dart';

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Modular.setNavigatorKey(Constants.navigatorKey);
    Modular.get<BoxNotification>().init();
    Modular.get<BoxLocationConfig>().init();
    Modular.get<BoxLocationCitiesCache>().init();
    context.setLanguageCode('ar');
    Future.microtask(() async {
      final mgPrayerTime = Modular.get<MgPrayerTime>();
      await mgPrayerTime.initializeLocation();
      final storedLocation = Modular.get<DSLocationConfig>().getCurrent();
      if (storedLocation == null) return;
      if (storedLocation.latitude == 0 && storedLocation.longitude == 0) return;
      if (storedLocation.country.isEmpty) return;
      await Modular.get<MgLocationSelection>().loadForLocation(
        latitude: storedLocation.latitude,
        longitude: storedLocation.longitude,
        countryDisplayName: storedLocation.country,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Modular.get<MgCore>()),
        ChangeNotifierProvider(create: (_) => Modular.get<MgAzkar>()),
        ChangeNotifierProvider(create: (_) => Modular.get<MgIndex>()),
        ChangeNotifierProvider(create: (_) => Modular.get<MgLocationSelection>()),
        ChangeNotifierProvider(create: (_) => Modular.get<MgQuran>()),
        ChangeNotifierProvider(create: (_) => Modular.get<MgWerd>()),
      ],
      child: OrientationBuilder(
        builder: (context, orientation) {
          return ScreenUtilInit(
            designSize: const Size(440, 956),
            minTextAdapt: true,
            enableScaleText: () => false,
            enableScaleWH: () => false,
            builder:
                (_, __) => LocalizedApp(
                  child: ToastificationWrapper(
                    config: ToastificationConfig(
                      alignment: Alignment.topCenter,
                      itemWidth: MediaQuery.sizeOf(context).width * 0.9,
                    ),
                    child: MaterialApp.router(
                      title: 'Al-Muslim',
                      debugShowCheckedModeBanner: false,
                      locale: context.locale,
                      localizationsDelegates: context.delegates,
                      supportedLocales: context.supportedLocales,
                      theme: AppThemes.light,
                      routerConfig: Modular.routerConfig,
                      builder: (ctx, child) {
                        if (Constants.showTalker) {
                          child = Stack(children: [child ?? const SizedBox(), const WLoggerIcon()]);
                        }
                        return LocalizeAndTranslate.directionBuilder(context, child);
                      },
                    ),
                  ),
                ),
          );
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(LocalNotificationService.instance.handlePendingNotificationIfPresent());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
