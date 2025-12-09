import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class WNotificationSwitcher extends StatefulWidget {
  const WNotificationSwitcher({super.key, this.notificationId});

  final int? notificationId;

  @override
  State<WNotificationSwitcher> createState() => _WNotificationSwitcherState();
}

class _WNotificationSwitcherState extends State<WNotificationSwitcher> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Modular.get<BoxNotification>().box.listenable(),
      builder: (_, box, __) {
        final MLocalNotification? notification = widget.notificationId != null ? box.get(widget.notificationId) : null;
        return Switch(
          value: notification?.isEnabled ?? false,
          onChanged: (value) {
            if (widget.notificationId != null && notification != null) {
              Modular.get<LocalNotificationService>().scheduleNotification(
                notification: notification.copyWith(isEnabled: value),
              );
            }
          },
        );
      },
    );
  }
}
