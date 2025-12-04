import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/modules/azkar/managers/mg_azkar.dart';
import 'package:al_muslim/modules/core/managers/mg_core.dart';
import 'package:al_muslim/modules/index/managers/mg_index.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_location_selection.dart';
import 'package:al_muslim/modules/quran/managers/mg_quran.dart';
import 'package:flutter/material.dart';
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
    Modular.setNavigatorKey(Constants.navigatorKey);
    Modular.get<BoxNotification>().init();
    context.setLanguageCode('ar');
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
                      title: 'BNB',
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
  void dispose() {
    super.dispose();
  }
}
