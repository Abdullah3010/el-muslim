import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WNotificationTimeSelect extends StatefulWidget {
  const WNotificationTimeSelect({super.key, this.notification});

  final MLocalNotification? notification;

  @override
  State<WNotificationTimeSelect> createState() => _WNotificationTimeSelectState();
}

class _WNotificationTimeSelectState extends State<WNotificationTimeSelect> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    final initialDate = widget.notification?.scheduledAt ?? DateTime.now();
    _selectedTime = TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: context.width * 0.82,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180.h,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false,
                initialDateTime: DateTime(0, 1, 1, _selectedTime.hour, _selectedTime.minute),
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
                  });
                },
              ),
            ),
            SizedBox(
              height: 48.h,
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: context.theme.colorScheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                ),
                onPressed: () {
                  final notification = widget.notification;
                  if (notification != null) {
                    final service = Modular.get<LocalNotificationService>();
                    final scheduledAt = service.nextInstanceOf(_selectedTime);
                    service.scheduleNotification(
                      notification: notification.copyWith(scheduledAt: scheduledAt),
                    );
                  }
                  Modular.to.pop();
                },
                child: Text('Confirm'.translated, style: context.textTheme.white16W500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
