import 'package:al_muslim/modules/azkar/presentation/screens/sn_azkar.dart';
import 'package:al_muslim/modules/core/presentation/screens/sn_splash.dart';
import 'package:al_muslim/modules/index/presentation/screens/sn_index.dart';
import 'package:al_muslim/modules/more/presentation/screens/sn_more.dart';
import 'package:al_muslim/modules/prayer_time/presentation/screens/sn_pray_time.dart';
import 'package:al_muslim/modules/werd/presentation/screens/sn_werd.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/screens/sn_qibla_direction.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/routes/guards/guards_ensuer_keyboard.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
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

    /// ================= Werd ================= ///
    r.child(
      RoutesNames.werd.werdMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SnWerd(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Azkar ================= ///
    r.child(
      RoutesNames.azkar.azkarMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SnAzkar(),
      guards: [EnsureKeyboardDismissed()],
    );

    /// ================= Index ================= ///
    r.child(
      RoutesNames.index.indexMain,
      transition: TransitionType.fadeIn,
      child: (_) => const SnIndex(),
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
