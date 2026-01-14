import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:al_muslim/core/widgets/w_settings_row_item.dart';
import 'package:al_muslim/modules/more/managers/mg_more.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_time_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce/hive.dart';

class AlarmEnableRow extends StatelessWidget {
  const AlarmEnableRow({
    super.key,
    required this.manager,
    required this.notificationId,
    required this.title,
    required this.icon,
    required this.defaultTime,
  });

  final MgMore manager;
  final int notificationId;
  final String title;
  final String icon;
  final TimeOfDay defaultTime;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<MLocalNotification>>(
      valueListenable: manager.notificationListenable(notificationId),
      builder: (_, box, __) {
        final notification = box.get(notificationId);
        final bool isEnabled = notification?.isEnabled ?? false;
        final theme = context.theme;
        return WSettingsRowItem(
          title: title,
          icon: icon,
          trailing: Switch(
            value: isEnabled,
            activeColor: theme.colorScheme.primaryColor,
            activeTrackColor: theme.colorScheme.primaryColor.withValues(alpha: 0.5),
            inactiveTrackColor: theme.colorScheme.primaryColor.withValues(alpha: 0.2),
            onChanged:
                (value) =>
                    manager.toggleNotification(notificationId: notificationId, enable: value, defaultTime: defaultTime),
          ),
          onTap:
              () => manager.toggleNotification(
                notificationId: notificationId,
                enable: !isEnabled,
                defaultTime: defaultTime,
              ),
        );
      },
    );
  }
}

class AlarmTimeRow extends StatelessWidget {
  const AlarmTimeRow({
    super.key,
    required this.manager,
    required this.notificationId,
    required this.title,
    required this.icon,
    required this.defaultTime,
    this.isFridayOnly = false,
  });

  final MgMore manager;
  final int notificationId;
  final String title;
  final String icon;
  final TimeOfDay defaultTime;
  final bool isFridayOnly;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<MLocalNotification>>(
      valueListenable: manager.notificationListenable(notificationId),
      builder: (_, box, __) {
        final notification = box.get(notificationId);
        final String timeLabel = manager.formatNotificationTimeLabel(notificationId, defaultTime);
        return WSettingsRowItem(
          title: title,
          icon: icon,
          subtitle: isFridayOnly ? 'Every Friday'.translated : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(timeLabel.translateTime(), style: context.theme.textTheme.primary16W400),
              10.widthBox,
              WLocalizeRotation(child: Assets.icons.backGold.svg(width: 20.w, height: 20.h)),
            ],
          ),
          onTap: () async {
            final initialTime =
                notification != null
                    ? TimeOfDay(hour: notification.scheduledAt.hour, minute: notification.scheduledAt.minute)
                    : defaultTime;
            final TimeOfDay? selected = await showWTimePickerDialog(context, initialTime: initialTime);
            if (selected != null) {
              await manager.updateNotificationTime(
                notificationId: notificationId,
                selectedTime: selected,
                defaultTime: defaultTime,
              );
            }
          },
        );
      },
    );
  }
}
