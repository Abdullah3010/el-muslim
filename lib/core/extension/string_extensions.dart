import 'package:al_muslim/core/utils/enums.dart';
import 'package:collection/collection.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

extension StringExtensions on String {
  String get translated => tr().replaceAll(' - 404', '');

  String translateNumbers() {
    return LocalizeAndTranslate.isRTL()
        ? replaceAll('0', '٠')
            .replaceAll('1', '١')
            .replaceAll('2', '٢')
            .replaceAll('3', '٣')
            .replaceAll('4', '٤')
            .replaceAll('5', '٥')
            .replaceAll('6', '٦')
            .replaceAll('7', '٧')
            .replaceAll('8', '٨')
            .replaceAll('9', '٩')
        : this;
  }

  bool isValidNumber() {
    // Attempt to parse the string as a number (integer or double)
    final number = num.tryParse(this);
    // Return true if the parsing succeeded, meaning it's a valid number
    return number != null;
  }

  String get phonePrefixPosition => '\u200E$this';

  String get priceFormatted {
    final String price = this;
    final List<String> parts = price.split('.');
    final String whole = parts.firstOrNull ?? '';
    final String fraction = parts.length > 1 ? (parts.lastOrNull ?? '') : '';
    final String formattedWhole = whole.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return fraction.isEmpty ? formattedWhole : '$formattedWhole.$fraction';
  }

  T? toEnum<T>(List<T> enumValues) {
    return enumValues.firstWhereOrNull((e) => e.toString().split('.').lastOrNull == this);
  }

  bool get isAssetPath {
    return startsWith('assets/');
  }

  bool get isSvg {
    return toLowerCase().endsWith('.svg');
  }

  String get replaceSpecialChars {
    return replaceAll('#', '%23')
        .replaceAll(' ', '%20')
        .replaceAll('!', '%21')
        .replaceAll('"', '%22')
        .replaceAll('\$', '%24')
        .replaceAll('&', '%26');
  }
}

extension StringNullExtensions on String? {
  MediaType getMediaType() {
    // Get the extension in lower case
    final url = Uri.tryParse(this ?? '');

    if (url == null) {
      return MediaType.error;
    }

    final fileExtension = url.pathSegments.lastOrNull?.split('.').lastOrNull?.toLowerCase();

    // Define lists of known extensions for each media type
    const audioExtensions = ['mp3', 'wav', 'aac', 'flac', 'ogg'];
    const videoExtensions = ['mp4', 'mov', 'avi', 'mkv', 'webm'];
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'svg'];

    if (audioExtensions.contains(fileExtension)) {
      return MediaType.audio;
    } else if (videoExtensions.contains(fileExtension)) {
      return MediaType.video;
    } else if (imageExtensions.contains(fileExtension)) {
      return MediaType.image;
    } else {
      return MediaType.error;
    }
  }

  String addParamsToRoute(Map<String, dynamic> params) {
    if (this == null || this!.isEmpty) return '';
    final uri = Uri.parse(this ?? '');
    Map<String, String> allParams = {...uri.queryParameters};
    allParams.addAll(params.map((key, value) => MapEntry(key, value.toString())));
    String updatedUri = '$this?';

    allParams.forEach((key, value) {
      updatedUri += '$key=$value&';
    });
    if (updatedUri.endsWith('&')) {
      updatedUri = updatedUri.substring(0, updatedUri.length - 1);
    }

    return updatedUri.toString();
  }
}
