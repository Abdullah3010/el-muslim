import 'dart:developer' as developer;

import 'package:al_muslim/core/extension/enums_extension.dart';
import 'package:al_muslim/core/extension/stack_trace_extension.dart';
import 'package:al_muslim/core/utils/enums.dart';

class ErrorHelper {
  static void printDebugError({
    String message = '',
    ErrorLevels level = ErrorLevels.DEBUG,
    String name = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      error: error,
      level: level.getLevelInteger(),
      stackTrace: stackTrace?.limitStackTracePrint(),
    );
  }
}
