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
    final spans = _buildSpans(text);
    return RichText(textDirection: TextDirection.rtl, text: TextSpan(style: style, children: spans));
  }

  List<InlineSpan> _buildSpans(String source) {
    final List<InlineSpan> spans = <InlineSpan>[];
    int lastIndex = 0;
    final double baseSize = ayahSymbolSize ?? (style.fontSize ?? 18);
    final double sidePadding = horizontalSpacing ?? (baseSize * 0.12);

    for (final match in _ayahRegex.allMatches(source)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: source.substring(lastIndex, match.start)));
      }

      final String? numberText = match.group(1);
      final int? number = numberText != null ? int.tryParse(numberText) : null;
      if (number == null) {
        spans.add(TextSpan(text: match.group(0) ?? ''));
      } else {
        spans.add(const TextSpan(text: '\u200F'));
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: WAyahEndSymbol(number: number, size: baseSize, style: style),
            ),
          ),
        );
        spans.add(const TextSpan(text: '\u200F'));
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
