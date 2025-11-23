import 'package:flutter/foundation.dart';

@immutable
class MWerdPlanOption {
  const MWerdPlanOption({
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
  });

  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
}
