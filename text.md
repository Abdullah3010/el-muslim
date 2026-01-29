# Task: Render Quran Text with Inline Ayah Numbers (۝١) from Preformatted String

## Goal
Implement a Flutter solution that renders Arabic Quranic text where ayah numbers are already embedded in the source string using parentheses (e.g. `(1)(2)(3)`), and dynamically replaces those markers at render-time with a styled **Ayah End Symbol (۝)** containing **Arabic-Indic digits (١٢٣)**.

The original text string MUST remain unchanged.

---

## Input Example (From API / DB)
```text
قُلْ هُوَ ٱللَّهُ أَحَدٌ(1) ٱللَّهُ ٱلصَّمَدُ(2) لَمْ يَلِدْ وَلَمْ يُولَدْ(3)
Expected Visual Output
(1) → rendered as ۝١

(2) → rendered as ۝٢

(3) → rendered as ۝٣

Arabic text flows RTL correctly

Ayah number is centered precisely inside the ۝ symbol

Uses Quran-compatible Arabic font

Constraints
❌ Do NOT modify or preprocess the source string

❌ Do NOT generate ayah numbers automatically

✅ Parsing must be done at render-time

✅ Solution must support multi-digit numbers (12), (114), etc.

✅ RTL-safe

✅ Reusable widget-based architecture

Technical Stack
Flutter (Stable)

Dart

RichText + TextSpan + WidgetSpan

Font: NotoNaskhArabic (or equivalent Quran-supporting font)

Implementation Steps
1. Detect Ayah Markers
Use RegExp to detect ayah markers in the format:

RegExp(r'\((\d+)\)')
This captures:

Full match: (3)

Group(1): 3

2. Arabic-Indic Number Conversion Helper
Implement a utility function to convert Western digits to Arabic-Indic digits.

String toArabicNumber(int number) {
  const arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
  return number
      .toString()
      .split('')
      .map((e) => arabicDigits[int.parse(e)])
      .join();
}
3. Ayah Number Widget (۝ + number)
Create a reusable widget that:

Renders Unicode U+06DD (۝)

Overlays the Arabic-Indic number inside it

Allows fine-grained vertical alignment control

class AyahNumber extends StatelessWidget {
  final int number;
  final double size;

  const AyahNumber({
    super.key,
    required this.number,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          '\u06DD',
          style: TextStyle(
            fontFamily: 'NotoNaskhArabic',
            fontSize: size,
            height: 1,
          ),
        ),
        Positioned(
          top: size * 0.28,
          child: Text(
            toArabicNumber(number),
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: size * 0.38,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}
4. Quran Text Parser → RichText Builder
Convert the source string into a RichText widget by:

Iterating over RegExp matches

Adding text segments as TextSpan

Replacing (n) markers with WidgetSpan(AyahNumber)

Widget buildQuranText(String text) {
  final regex = RegExp(r'\((\d+)\)');
  final spans = <InlineSpan>[];

  int lastIndex = 0;

  for (final match in regex.allMatches(text)) {
    spans.add(
      TextSpan(text: text.substring(lastIndex, match.start)),
    );

    final number = int.parse(match.group(1)!);

    spans.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: AyahNumber(number: number),
      ),
    );

    lastIndex = match.end;
  }

  if (lastIndex < text.length) {
    spans.add(
      TextSpan(text: text.substring(lastIndex)),
    );
  }

  return RichText(
    textDirection: TextDirection.rtl,
    text: TextSpan(
      style: const TextStyle(
        fontFamily: 'NotoNaskhArabic',
        fontSize: 22,
        height: 1.8,
        color: Colors.black,
      ),
      children: spans,
    ),
  );
}
Usage Example
buildQuranText(
  'قُلْ هُوَ ٱللَّهُ أَحَدٌ(1) ٱللَّهُ ٱلصَّمَدُ(2) لَمْ يَلِدْ وَلَمْ يُولَدْ(3)',
);
Acceptance Criteria
 (n) is never rendered as plain text

 Ayah symbol ۝ renders correctly

 Numbers are Arabic-Indic (١٢٣)

 RTL layout is preserved

 Works with multi-digit ayah numbers

 No mutation of source text

 Widget is reusable and stateless

Optional Enhancements (Out of Scope)
Tap interaction on ayah numbers

Theme-aware coloring

Support for alternative Quran fonts

Caching spans for performance in long lists

Notes for AI Agent
Prioritize rendering correctness over string manipulation

Assume text is Quranic Arabic (RTL by default)

Avoid assumptions about ayah separators other than (number)

