import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class WLocalizeRotation extends StatelessWidget {
  const WLocalizeRotation({super.key, required this.child, this.reverse = false});

  final Widget child;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(angle: (context.languageCode == 'ar' && !reverse) ? 0 : (180 * 3.14) / 180, child: child);
  }
}
