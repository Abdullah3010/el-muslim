import 'package:localize_and_translate/localize_and_translate.dart';

class MAzkarCategories {
  final int? id;
  final String? arName;
  final String? enName;
  final String? filename;
  final String? image;

  MAzkarCategories({this.id, this.arName, this.enName, this.filename, this.image});

  factory MAzkarCategories.fromJson(Map<String, dynamic>? json) {
    return MAzkarCategories(
      id: json?['id'],
      arName: json?['arName'],
      enName: json?['enName'],
      filename: json?['filename'],
      image: json?['image'],
    );
  }

  String get displayName {
    return LocalizeAndTranslate.getLanguageCode() == 'ar' ? (arName ?? '') : (enName ?? '');
  }

  String get filePath {
    return 'assets/json/azkar/$filename';
  }

  String get imagePath {
    if (image == null || image!.isEmpty) return '';
    return 'assets/images/$image';
  }
}
