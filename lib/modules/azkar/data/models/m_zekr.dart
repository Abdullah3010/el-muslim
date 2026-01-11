import 'package:localize_and_translate/localize_and_translate.dart';

class MZekr {
  final int? id;
  final MZekrDescription? description;
  final int? count;
  final String? zekr;
  final String? reference;
  final String? category;
  final String? fadelZeker;

  MZekr({this.id, this.description, this.count, this.zekr, this.reference, this.category, this.fadelZeker});

  factory MZekr.fromJson(Map<String, dynamic>? json) {
    return MZekr(
      id: json?['id'],
      description: MZekrDescription.fromJson(json?['description'] ?? {}),
      count: json?['count'],
      zekr: json?['zekr'],
      reference: json?['reference'],
      category: json?['category'],
      fadelZeker: json?['fadel_zeker'],
    );
  }
}

class MZekrDescription {
  final String? arabic;
  final String? english;

  MZekrDescription({this.arabic, this.english});

  factory MZekrDescription.fromJson(Map<String, dynamic>? json) {
    return MZekrDescription(arabic: json?['arabic'], english: json?['english']);
  }

  String get displayDescription {
    return LocalizeAndTranslate.getLanguageCode() == 'en' ? (english ?? '') : (arabic ?? '');
  }
}
