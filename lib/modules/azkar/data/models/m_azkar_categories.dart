import 'package:localize_and_translate/localize_and_translate.dart';

class MAzkarCategories {
  final int? id;
  final String? arName;
  final String? enName;
  final String? filename;

  MAzkarCategories({this.id, this.arName, this.enName, this.filename});

  factory MAzkarCategories.fromJson(Map<String, dynamic>? json) {
    return MAzkarCategories(
      id: json?['id'],
      arName: json?['arName'],
      enName: json?['enName'],
      filename: json?['filename'],
    );
  }

  String get displayName {
    return LocalizeAndTranslate.getLanguageCode() == 'ar' ? (arName ?? '') : (enName ?? '');
  }

  String get filePath {
    return 'assets/json/$filename';
  }
}
