import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/core/constants/constants.dart';

/// [EnsureKeyboardDismissed] is a class that contains information about ensure keyboard dismissed.
class EnsureKeyboardDismissed extends RouteGuard {
  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    if (Constants.navigatorKey.currentContext != null) {
      FocusScope.of(Constants.navigatorKey.currentContext!).focusedChild?.unfocus();
    }

    return true;
  }
}
