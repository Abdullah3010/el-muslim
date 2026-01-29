import 'package:flutter/material.dart';

class WAzkarTextWithAyah extends StatelessWidget {
  const WAzkarTextWithAyah({
    super.key,
    required this.text,
    required this.style,
    this.ayahSymbolSize,
    this.horizontalSpacing,
  });

  final String text;
  final TextStyle style;
  final double? ayahSymbolSize;
  final double? horizontalSpacing;

  static final RegExp _ayahRegex = RegExp(r'\((\d+)\)');

  @override
  Widget build(BuildContext context) {
    final processedText = _processText(text);
    return Text(processedText, style: style, textDirection: TextDirection.rtl, textAlign: TextAlign.start);
  }

  String _processText(String source) {
    return source.replaceAllMapped(_ayahRegex, (match) {
      final String? numberText = match.group(1);
      final int? number = numberText != null ? int.tryParse(numberText) : null;
      if (number != null) {
        final arabicNumber = _toArabicNumber(number);
        return ' \u06DD$arabicNumber ';
      }
      return match.group(0) ?? '';
    });
  }

  static String _toArabicNumber(int value) {
    const List<String> arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return value.toString().split('').map((digit) => arabicDigits[int.parse(digit)]).join();
  }
}

class WAzkarTextWithAyahRich extends StatelessWidget {
  const WAzkarTextWithAyahRich({
    super.key,
    required this.text,
    required this.style,
    this.ayahSymbolSize,
    this.horizontalSpacing,
  });

  final String text;
  final TextStyle style;
  final double? ayahSymbolSize;
  final double? horizontalSpacing;

  static final RegExp _ayahRegex = RegExp(r'\((\d+)\)');

  @override
  Widget build(BuildContext context) {
    final spans = _buildSpans(text);
    return Text.rich(
      TextSpan(style: style, children: spans),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.start,
    );
  }

  List<InlineSpan> _buildSpans(String source) {
    final List<InlineSpan> spans = [];
    final double baseSize = ayahSymbolSize ?? (style.fontSize ?? 18);
    final double sidePadding = horizontalSpacing ?? (baseSize * 0.12);
    int lastIndex = 0;

    final matches = _ayahRegex.allMatches(source).toList();

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];

      if (match.start > lastIndex) {
        final textPart = source.substring(lastIndex, match.start);
        spans.add(TextSpan(text: textPart));
      }

      final String? numberText = match.group(1);
      final int? number = numberText != null ? int.tryParse(numberText) : null;

      if (number != null) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: WAyahEndSymbol(number: number, size: baseSize, style: style),
            ),
          ),
        );
      } else {
        spans.add(TextSpan(text: match.group(0) ?? ''));
      }

      lastIndex = match.end;
    }

    if (lastIndex < source.length) {
      spans.add(TextSpan(text: source.substring(lastIndex)));
    }

    return spans;
  }
}

class WAyahEndSymbol extends StatelessWidget {
  const WAyahEndSymbol({super.key, required this.number, required this.size, required this.style});

  final int number;
  final double size;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + 10,
      height: size + 10,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text('\u06DD', style: style.copyWith(fontSize: size, height: 1), textAlign: TextAlign.center),
          Center(
            child: Text(
              _toArabicNumber(number),
              textAlign: TextAlign.center,
              style: style.copyWith(fontSize: size * 0.42, fontWeight: FontWeight.w600, height: 1.1),
            ),
          ),
        ],
      ),
    );
  }

  String _toArabicNumber(int value) {
    const List<String> arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return value.toString().split('').map((digit) => arabicDigits[int.parse(digit)]).join();
  }
}
