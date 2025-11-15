import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:flutter/material.dart';

class WSettingsItemDivider extends StatelessWidget {
  const WSettingsItemDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 2,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: context.theme.colorScheme.primaryColor.withValues(alpha: 0.2),
    );
  }
}
