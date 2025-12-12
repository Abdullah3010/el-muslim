import 'package:flutter/foundation.dart';

@immutable
class MWerdDetailSegment {
  const MWerdDetailSegment({
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
