import 'package:localize_and_translate/localize_and_translate.dart';

String formatZekrCountText(int count) {
  final isArabic = LocalizeAndTranslate.getLanguageCode() == 'ar';
  if (isArabic) {
    return _arabicCountPhrase(count);
  }
  final numberText = _numberToEnglishWords(count);
  final suffix = count == 1 ? 'time' : 'times';
  return '$numberText $suffix';
}

String _arabicCountPhrase(int count) {
  if (count == 1) return 'مرة واحدة';
  if (count == 2) return 'مرتان';
  final numberText = _numberToArabicWords(count);
  if (count >= 3 && count <= 10) {
    return '$numberText مرات';
  }
  return '$numberText مرة';
}

String _numberToEnglishWords(int number) {
  const ones = {
    0: 'zero',
    1: 'one',
    2: 'two',
    3: 'three',
    4: 'four',
    5: 'five',
    6: 'six',
    7: 'seven',
    8: 'eight',
    9: 'nine',
    10: 'ten',
    11: 'eleven',
    12: 'twelve',
    13: 'thirteen',
    14: 'fourteen',
    15: 'fifteen',
    16: 'sixteen',
    17: 'seventeen',
    18: 'eighteen',
    19: 'nineteen',
  };
  const tens = {
    20: 'twenty',
    30: 'thirty',
    40: 'forty',
    50: 'fifty',
    60: 'sixty',
    70: 'seventy',
    80: 'eighty',
    90: 'ninety',
  };
  if (number < 0) return number.toString();
  if (number < 20) return ones[number] ?? number.toString();
  if (number < 100) {
    final ten = (number ~/ 10) * 10;
    final remainder = number % 10;
    if (remainder == 0) return tens[ten] ?? number.toString();
    return '${tens[ten]} ${ones[remainder]}';
  }
  if (number < 1000) {
    final hundred = number ~/ 100;
    final remainder = number % 100;
    final hundredText = '${ones[hundred]} hundred';
    if (remainder == 0) return hundredText;
    return '$hundredText ${_numberToEnglishWords(remainder)}';
  }
  return number.toString();
}

String _numberToArabicWords(int number) {
  const ones = {
    0: 'صفر',
    1: 'واحد',
    2: 'اثنان',
    3: 'ثلاثة',
    4: 'اربعة',
    5: 'خمسة',
    6: 'ستة',
    7: 'سبعة',
    8: 'ثمانية',
    9: 'تسعة',
    10: 'عشرة',
    11: 'احد عشر',
    12: 'اثنا عشر',
    13: 'ثلاثة عشر',
    14: 'اربعة عشر',
    15: 'خمسة عشر',
    16: 'ستة عشر',
    17: 'سبعة عشر',
    18: 'ثمانية عشر',
    19: 'تسعة عشر',
  };
  const tens = {
    20: 'عشرون',
    30: 'ثلاثون',
    40: 'اربعون',
    50: 'خمسون',
    60: 'ستون',
    70: 'سبعون',
    80: 'ثمانون',
    90: 'تسعون',
  };
  const hundreds = {
    100: 'مائة',
    200: 'مئتان',
    300: 'ثلاثمائة',
    400: 'اربعمائة',
    500: 'خمسمائة',
    600: 'ستمائة',
    700: 'سبعمائة',
    800: 'ثمانمائة',
    900: 'تسعمائة',
  };
  if (number < 0) return number.toString();
  if (number < 20) return ones[number] ?? number.toString();
  if (number < 100) {
    final ten = (number ~/ 10) * 10;
    final remainder = number % 10;
    if (remainder == 0) return tens[ten] ?? number.toString();
    return '${ones[remainder]} و ${tens[ten]}';
  }
  if (number < 1000) {
    final hundred = (number ~/ 100) * 100;
    final remainder = number % 100;
    final hundredText = hundreds[hundred] ?? '${ones[hundred ~/ 100]} مائة';
    if (remainder == 0) return hundredText;
    return '$hundredText و ${_numberToArabicWords(remainder)}';
  }
  return number.toString();
}
