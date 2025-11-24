import 'package:flutter/foundation.dart';

@immutable
class MCityOption {
  const MCityOption({required this.ar, required this.en});

  final String ar;
  final String en;

  String name(String languageCode) => languageCode == 'ar' ? ar : en;
}
