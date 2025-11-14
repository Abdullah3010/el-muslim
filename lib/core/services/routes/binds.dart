import 'package:al_muslim/core/config/box_app_config/box_app_config.dart';
import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/modules/core/managers/mg_core.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// [Binds] is a class that contains all the dependencies that will be used in the app.
class Binds {
  /// [binds] is a function that bind all dependencies.
  static void binds(Injector i) {
    i.addSingleton(BoxAppConfig.new);
    i.addSingleton(DSAppConfig.new);

    /// ================= Core ================= ///
    i.addLazySingleton(MgCore.new);
  }
}
