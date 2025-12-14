import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WNewWerdDetailsReminder extends StatelessWidget {
  const WNewWerdDetailsReminder({super.key, required this.label, this.notification, this.onToggle, this.onTap});

  final String label;
  final MLocalNotification? notification;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String timeLabel = _timeLabel();
    final bool hasNotification = notification != null;
    final bool isEnabled = notification?.isEnabled ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Reminder'.translated, style: context.textTheme.primary16W500),
          12.heightBox,
          InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: onTap,
            child: Container(
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
                        Text(label, style: context.textTheme.primary16W500),
                        4.heightBox,
                        Text(
                          timeLabel.translateTime(),
                          style: context.textTheme.primary16W400.copyWith(
                            color: hasNotification ? null : context.theme.colorScheme.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isEnabled,
                    onChanged: hasNotification && onToggle != null ? (value) => onToggle!(value) : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _timeLabel() {
    if (notification == null) {
      return 'No reminders yet'.translated;
    }
    final scheduled = notification!.scheduledAt;
    final hourOfPeriod = scheduled.hour % 12;
    final hour = hourOfPeriod == 0 ? 12 : hourOfPeriod;
    final minute = scheduled.minute.toString().padLeft(2, '0');
    final period = scheduled.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}
