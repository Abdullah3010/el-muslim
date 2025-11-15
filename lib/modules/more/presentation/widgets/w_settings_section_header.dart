import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WSettingsSectionHeader extends StatelessWidget {
  final String title;

  const WSettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      color: context.theme.colorScheme.secondaryColor,
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: Row(children: [Text(title, style: context.textTheme.primary16W500), const Spacer()]),
    );
  }
}
