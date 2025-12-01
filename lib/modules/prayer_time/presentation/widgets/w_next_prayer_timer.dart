import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WNextPrayerTimer extends StatelessWidget {
  const WNextPrayerTimer({required this.nextPrayerLabel, required this.countdown, this.description, super.key});

  final String nextPrayerLabel;
  final Duration countdown;
  final String? description;

  String get _formattedCountdown {
    final hours = countdown.inHours;
    final minutes = countdown.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = countdown.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Cairo', style: context.theme.textTheme.primary20W500),
          SizedBox(height: 12.h),
          Text('${'Time until prayer call'.translated} $nextPrayerLabel', style: context.theme.textTheme.primary20W500),

          SizedBox(height: 12.h),
          Text(_formattedCountdown.translateNumbers(), style: context.theme.textTheme.primary43W400),
        ],
      ),
    );
  }
}
