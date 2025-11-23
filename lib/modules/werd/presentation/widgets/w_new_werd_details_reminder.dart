import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WNewWerdDetailsReminder extends StatefulWidget {
  const WNewWerdDetailsReminder({super.key, required this.label, required this.timeLabel});

  final String label;
  final String timeLabel;

  @override
  State<WNewWerdDetailsReminder> createState() => _WNewWerdDetailsReminderState();
}

class _WNewWerdDetailsReminderState extends State<WNewWerdDetailsReminder> {
  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Reminder'.translated, style: context.textTheme.primary16W500),
          12.heightBox,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.secondaryColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.label, style: context.textTheme.primary16W500),
                      4.heightBox,
                      Text(widget.timeLabel, style: context.textTheme.primary16W400),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _isEnabled,
                  onChanged: (value) => setState(() => _isEnabled = value),
                  activeColor: context.theme.colorScheme.primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
