extension StackTraceExtension on StackTrace {
  StackTrace limitStackTracePrint([int limit = 2]) {
    final List<String> lines = toString().split('\n');
    final String limitedStackTrace = lines.take(limit).join('\n');
    return StackTrace.fromString(limitedStackTrace);
  }
}
