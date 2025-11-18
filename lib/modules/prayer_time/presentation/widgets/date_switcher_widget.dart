import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateSwitcherWidget extends StatelessWidget {
  const DateSwitcherWidget({
    required this.hijriLabel,
    required this.gregorianLabel,
    required this.readableLabel,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final String hijriLabel;
  final String gregorianLabel;
  final String readableLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      decoration: BoxDecoration(color: context.theme.colorScheme.primaryColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onPrevious,
            child: Container(
              height: 64.h,
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Transform.rotate(angle: (180 * 3.14) / 180, child: Assets.icons.nextIconWhite.svg()),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(gregorianLabel, textAlign: TextAlign.center, style: context.theme.textTheme.white14W500),
                Text(hijriLabel, textAlign: TextAlign.center, style: context.theme.textTheme.white14W500),
              ],
            ),
          ),
          InkWell(
            onTap: onNext,
            child: Container(
              height: 64.h,
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Transform.rotate(angle: 0, child: Assets.icons.nextIconWhite.svg()),
            ),
          ),
        ],
      ),
    );
  }
}
