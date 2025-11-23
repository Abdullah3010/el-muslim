import 'package:flutter/foundation.dart';

@immutable
class MQuranIndex {
  const MQuranIndex({
    required this.number,
    required this.name,
    required this.revelationPlace,
    required this.versesCount,
    required this.wordsCount,
    required this.lettersCount,
    required this.firstPage,
  });

  final int number;
  final MQuranName name;
  final MQuranRevelationPlace revelationPlace;
  final int versesCount;
  final int wordsCount;
  final int lettersCount;
  final MQuranFirstPage firstPage;

  factory MQuranIndex.fromJson(Map<String, dynamic> json) {
    return MQuranIndex(
      number: json['number'] as int? ?? 0,
      name: MQuranName.fromJson(json['name'] as Map<String, dynamic>? ?? const {}),
      revelationPlace:
          MQuranRevelationPlace.fromJson(json['revelation_place'] as Map<String, dynamic>? ?? const {}),
      versesCount: json['verses_count'] as int? ?? 0,
      wordsCount: json['words_count'] as int? ?? 0,
      lettersCount: json['letters_count'] as int? ?? 0,
      firstPage: MQuranFirstPage.fromJson(json['first_page'] as Map<String, dynamic>? ?? const {}),
    );
  }
}

@immutable
class MQuranName {
  const MQuranName({
    required this.ar,
    required this.en,
    required this.transliteration,
  });

  final String ar;
  final String en;
  final String transliteration;

  factory MQuranName.fromJson(Map<String, dynamic> json) {
    return MQuranName(
      ar: json['ar'] as String? ?? '',
      en: json['en'] as String? ?? '',
      transliteration: json['transliteration'] as String? ?? '',
    );
  }
}

@immutable
class MQuranRevelationPlace {
  const MQuranRevelationPlace({
    required this.ar,
    required this.en,
  });

  final String ar;
  final String en;

  factory MQuranRevelationPlace.fromJson(Map<String, dynamic> json) {
    return MQuranRevelationPlace(
      ar: json['ar'] as String? ?? '',
      en: json['en'] as String? ?? '',
    );
  }
}

@immutable
class MQuranFirstPage {
  const MQuranFirstPage({
    required this.madani,
    required this.indopak,
  });

  final int madani;
  final int indopak;

  factory MQuranFirstPage.fromJson(Map<String, dynamic> json) {
    return MQuranFirstPage(
      madani: json['madani'] as int? ?? 0,
      indopak: json['indopak'] as int? ?? 0,
    );
  }
}
