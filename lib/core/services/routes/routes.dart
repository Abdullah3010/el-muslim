import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/routes/guards/guards_ensuer_keyboard.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/modules/azkar/presentation/screens/sn_azkar_list.dart';
import 'package:al_muslim/modules/azkar/presentation/screens/sn_zekr.dart';
import 'package:al_muslim/modules/core/presentation/screens/sn_splash.dart';
import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';
import 'package:al_muslim/modules/index/presentation/screens/sn_index.dart';
import 'package:al_muslim/modules/more/presentation/screens/sn_more.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_adhan_notifications.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_adhan_settings.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_location_selection.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_pray_time.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_pray_time_settings.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/screens/sn_qibla_direction.dart';
import 'package:al_muslim/modules/quran/presentation/screens/sn_quran_library.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_all_werd.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_daily_awrad_alarm.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_next_werd.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_previous_werd.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_werd.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_werd_details.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:quran_library/quran_library.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
      RoutesNames.werd.allWerds,
      transition: TransitionType.fadeIn,
      child: (_) => const SnAllWerds(),
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
        final data = r.args.data;
        final option = data is MWerdPlanOption ? data : null;
        return SnWerdDetails(initialOption: option);
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
      child: (_) {
        print(" =====>>>> params: ${r.args.params}");
        print(" =====>>>> categoryId: ${r.args.params['categoryId']}");

        return SnZekr(categoryId: int.tryParse(r.args.params['categoryId']) ?? 0);
      },
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
        final data = r.args.data;
        final firstPage = data is MQuranFirstPage ? data : (data is MQuranIndex ? data.firstPage : null);
        final surahNumber = data is MQuranIndex ? data.number : _surahNumberFromPayload(data);
        final bookmark = data is BookmarkModel ? data : null;
        return SnQuranLibrary(firstPage: firstPage, surahNumber: surahNumber, bookmark: bookmark);
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

  static int? _surahNumberFromPayload(dynamic data) {
    if (data is int) return data;
    if (data is Map) {
      final rawNumber = data['surahNumber'] ?? data['surah_number'];
      final parsed = _parseInt(rawNumber);
      if (parsed != null) return parsed;
      final rawName = data['surah']?.toString();
      if (rawName != null) {
        final normalized = rawName.toLowerCase().trim();
        switch (normalized) {
          case 'al_mulk':
            return 67;
          case 'al_baqara':
          case 'al_baqarah':
            return 2;
          default:
            return _parseInt(normalized);
        }
      }
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }
}
