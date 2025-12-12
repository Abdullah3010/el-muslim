import 'package:al_muslim/core/config/box_app_config/box_app_config.dart';
import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/ds_notification.dart';
import 'package:al_muslim/modules/azkar/managers/mg_azkar.dart';
import 'package:al_muslim/modules/core/managers/mg_core.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_location_selection.dart';
import 'package:al_muslim/modules/index/managers/mg_index.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_prayer_time.dart';
import 'package:al_muslim/modules/qibla_direction/managers/mg_qibla.dart';
import 'package:al_muslim/modules/quran/managers/mg_quran.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// [Binds] is a class that contains all the dependencies that will be used in the app.
class Binds {
  /// [binds] is a function that bind all dependencies.
  static void binds(Injector i) {
    i.addSingleton(BoxAppConfig.new);
    i.addSingleton(DSAppConfig.new);

    /// ================= Notifications ================= ///
    i.addSingleton(BoxNotification.new);
    i.addSingleton(DSNotification.new);

    /// ================= Managers ================= ///
    i.addLazySingleton(MgCore.new);
    i.addLazySingleton(MgQibla.new);
    i.addLazySingleton(MgLocationSelection.new);
    i.addLazySingleton(MgIndex.new);
    i.addLazySingleton(MgPrayerTime.new);
    i.addLazySingleton(MgAzkar.new);
    i.addLazySingleton(MgQuran.new);
    i.addLazySingleton(MgWerd.new);
  }
}
