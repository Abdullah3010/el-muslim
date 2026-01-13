import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WPrayerTimesListShimmer extends StatelessWidget {
  const WPrayerTimesListShimmer({super.key});

  static final List<String> _prayerNames = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        6,
        (index) => Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 13.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _prayerNames[index].translated,
                  style: context.theme.textTheme.bodyLarge?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ),
              Skeletonizer(
                enabled: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [Bone.text(words: 1, style: TextStyle(fontSize: 16.sp))],
                ),
              ),
              24.horizontalSpace,
              Assets.icons.unmute.svg(),
            ],
          ),
        ),
      ),
    );
  }
}
