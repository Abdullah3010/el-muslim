import 'package:al_muslim/modules/azkar/presentation/screens/sn_azkar_list.dart';
import 'package:al_muslim/modules/azkar/presentation/screens/sn_zekr.dart';
import 'package:al_muslim/modules/core/presentation/screens/sn_splash.dart';
import 'package:al_muslim/modules/index/presentation/screens/sn_index.dart';
import 'package:al_muslim/modules/more/presentation/screens/sn_more.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_adhan_notifications.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_adhan_settings.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_pray_time.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_pray_time_settings.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_location_selection.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_daily_awrad_alarm.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_next_werd.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_previous_werd.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_werd.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_werd_details.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/screens/sn_qibla_direction.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/routes/guards/guards_ensuer_keyboard.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:al_muslim/modules/quran/presentation/screens/sn_quran.dart';
import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';

/// [Routes] is a class that contains all the routes in the app.
class Routes {
  /// [buildRoutes] is a function that build all the routes in the app.
  static void buildRoutes(RouteManager r) {
    /// ================= Core ================= ///
    r.child(
      RoutesNames.core.splash,
      transition: TransitionType.fadeIn,
      child: (_) => const SNSplash(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Logger ================= ///
    r.child(
      RoutesNames.core.logger,
      child: (context) => TalkerScreen(talker: Constants.talker),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= More ================= ///
    r.child(
      RoutesNames.more.moreMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SnMore(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Pray Time ================= ///
    r.child(
      RoutesNames.prayTime.prayTimeMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SnPrayTime(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.prayTime.prayTimeSettings,
      transition: TransitionType.fadeIn,
      child: (_) => const SnPrayTimeSettings(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.prayTime.adhanNotifications,
      transition: TransitionType.fadeIn,
      child: (_) => const SnAdhanNotifications(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.prayTime.adhanSettings,
      transition: TransitionType.fadeIn,
      child: (_) => SnAdhanSettings(adhanIndex: r.args.data['adhanIndex'] as int?),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.prayTime.locationSelection,
      transition: TransitionType.fadeIn,
      child: (_) => const SnLocationSelection(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Werd ================= ///
    r.child(
      RoutesNames.werd.werdMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SnWerd(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.werd.previousWerd,
      transition: TransitionType.fadeIn,
      child: (_) => const SnPreviousWerd(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.werd.nextWerd,
      transition: TransitionType.fadeIn,
      child: (_) => const SnNextWerd(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.werd.dailyAwradAlarm,
      transition: TransitionType.fadeIn,
      child: (_) => const SnDailyAwradAlarm(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.werd.werdDetails,
      transition: TransitionType.fadeIn,
      child: (_) {
        final option = r.args.data as MWerdPlanOption?;
        return SnWerdDetails(
          option: option ??
              const MWerdPlanOption(
                titleAr: 'ختمة 30 يوما',
                titleEn: 'Werd 30 days',
                subtitleAr: 'الورد اليومي 1 جزء',
                subtitleEn: 'Daily portion 1 Juz',
              ),
        );
      },
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Azkar ================= ///
    r.child(
      RoutesNames.azkar.azkarMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SnAzkarList(),
      guards: [EnsureKeyboardDismissed()],
    );

    r.child(
      RoutesNames.azkar.zekrbase,
      transition: TransitionType.fadeIn,
      child: (_) => SnZekr(categoryId: int.tryParse(r.args.params['categoryId']) ?? 0),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Index ================= ///
    r.child(
      RoutesNames.index.indexMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SnIndex(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Quran ================= ///
    r.child(
      RoutesNames.quran.quranMain,
      transition: TransitionType.fadeIn,
      child: (_) {
        final firstPage = r.args.data as MQuranFirstPage?;
        return SnQuran(firstPage: firstPage);
      },
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Qibla Direction ================= ///
    r.child(
      RoutesNames.qibla.qiblaMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SnQiblaDirection(),
      guards: [EnsureKeyboardDismissed()],
    );
  }
}
