import 'package:flutter/foundation.dart';

@immutable
class MWerdDetailSegment {
  const MWerdDetailSegment({
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
    required this.startPageNumber,
    required this.endPageNumber,
  });

  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
  final int startPageNumber;
  final int endPageNumber;
}
