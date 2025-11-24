import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WDailyAwradAlarmItem extends StatelessWidget {
  const WDailyAwradAlarmItem({
    super.key,
    required this.timeLabel,
    required this.isOn,
    this.showSettings = false,
    this.onToggle,
    this.onSettingsTap,
  });

  final String timeLabel;
  final bool isOn;
  final bool showSettings;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primaryLightOrange.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Text(timeLabel, style: context.textTheme.primary16W500),
          const Spacer(),
          if (showSettings) ...[
            IconButton(
              onPressed: onSettingsTap,
              padding: EdgeInsets.zero,
              icon: Icon(Icons.settings, color: context.theme.colorScheme.primaryColor, size: 20.sp),
            ),
          ],
          Switch(
            value: isOn,
            activeColor: context.theme.colorScheme.primaryColor,
            activeTrackColor: context.theme.colorScheme.primaryColor.withOpacity(0.5),
            inactiveTrackColor: context.theme.colorScheme.primaryColor.withOpacity(0.2),
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
