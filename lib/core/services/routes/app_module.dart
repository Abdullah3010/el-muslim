import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/core/services/routes/binds.dart';
import 'package:al_muslim/core/services/routes/routes.dart';

/// [AppModule] is a class that extends [Module] to bind all dependencies and routes.
class AppModule extends Module {
  /// [binds] is a function that bind all dependencies.
  @override
  void binds(Injector i) {
    Binds.binds(i);
  }

  /// [routes] is a function that bind all routes.
  @override
  void routes(RouteManager r) {
    Routes.buildRoutes(r);
  }
}
