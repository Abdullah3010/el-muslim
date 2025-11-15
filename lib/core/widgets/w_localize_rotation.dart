import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class WLocalizeRotation extends StatelessWidget {
  const WLocalizeRotation({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(angle: context.languageCode == 'ar' ? (180 * 3.14) / 180 : 0, child: child);
  }
}
