// Flutter_modular observers print route name.
import 'package:flutter/widgets.dart';

/// [AppModularObserver] is a class that extends [NavigatorObserver] to print the route name.
class AppModularObserver extends NavigatorObserver {
  /// [didPush] is a function that print the route name when the route is pushed.
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint(
      'Modular (didPush): URL ==> (${route.settings.name}) --||-- previousRoute ==> ${previousRoute?.settings.name} --||-- args ==> ${route.settings.arguments}',
      // name: 'AppModularObserver.didPush',
    );
    super.didPush(route, previousRoute);
  }

  /// [didPop] is a function that print the route name when the route is popped.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint(
      'Modular (didPop): URL ==> (${route.settings.name}) --||-- previousRoute ==> ${previousRoute?.settings.name} --||-- args ==> ${route.settings.arguments}',
      // name: 'AppModularObserver.didPop',
    );
    super.didPop(route, previousRoute);
  }

  /// [didRemove] is a function that print the route name when the route is removed.
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint(
      'Modular (didRemove): URL ==> (${route.settings.name}) --||-- previousRoute ==> ${previousRoute?.settings.name} --||-- args ==> ${route.settings.arguments}',
      // name: 'AppModularObserver.didRemove',
    );
    super.didRemove(route, previousRoute);
  }

  ///  [didReplace] is a function that print the route name when the route is replaced.
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint(
      'Modular (didReplace): URL ==> (${newRoute?.settings.name ?? '...'}) --||-- previousRoute ==> ${oldRoute?.settings.name ?? '...'} --||-- args ==> ${newRoute?.settings.arguments ?? '...'}',
      // name: 'AppModularObserver.didReplace',
    );
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
