import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WNewWerdDetailsProgress extends StatelessWidget {
  const WNewWerdDetailsProgress({
    super.key,
    required this.progress,
    required this.previousWerds,
    required this.upcomingWerds,
    required this.statusLabel,
  });

  final double progress;
  final int previousWerds;
  final int upcomingWerds;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Current Werd'.translated, style: context.textTheme.primary16W500),
              const Spacer(),
              Text(statusLabel, style: context.textTheme.red14W500),
            ],
          ),
          8.heightBox,
          LinearProgressIndicator(
            value: progress,
            minHeight: 8.h,
            color: context.theme.colorScheme.primaryColor,
            backgroundColor: context.theme.colorScheme.lightGray,
            borderRadius: BorderRadius.circular(50.r),
          ),
          24.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'Previous Werds'.translated}: ${'$previousWerds'.translateNumbers()}',
                style: context.textTheme.primary14W400,
              ),

              Text(
                '${'Upcoming Werds'.translated}: ${'$upcomingWerds'.translateNumbers()}',
                style: context.textTheme.primary14W400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
