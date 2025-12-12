import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_daily_awrad_alarm_item.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_time_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnDailyAwradAlarm extends StatefulWidget {
  const SnDailyAwradAlarm({super.key});

  @override
  State<SnDailyAwradAlarm> createState() => _SnDailyAwradAlarmState();
}

class _SnDailyAwradAlarmState extends State<SnDailyAwradAlarm> {
  late final MgWerd _mgWerd;

  @override
  void initState() {
    super.initState();
    _mgWerd = Modular.get<MgWerd>();
    if (_mgWerd.selectedOption == null && !_mgWerd.isPlanLoading) {
      _mgWerd.loadSelectedPlan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mgWerd,
      builder: (context, _) {
        final List<MLocalNotification> notifications = _mgWerd.notificationReminders;
        final bool isLoading = _mgWerd.isPlanLoading;

        return WSharedScaffold(
          appBar: WSharedAppBar(
            title: 'Daily Awrad Alarm'.translated,
            action: IconButton(
              icon: Icon(Icons.add, color: context.theme.colorScheme.primaryColor),
              onPressed: _mgWerd.selectedOption == null ? null : _addNotification,
            ),
          ),
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : notifications.isEmpty
                  ? _buildEmptyState(context)
                  : Column(
                    children: [
                      Text(
                        'You can set more than one alarm to remind you to read your daily Quran recitation.'.translated,
                        textAlign: TextAlign.center,
                        style: context.textTheme.primary14W400,
                      ),
                      34.heightBox,
                      Expanded(
                        child: ListView.separated(
                          // padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return WDailyAwradAlarmItem(
                              timeLabel: _formatTime(notification.scheduledAt).translateNumbers(),
                              isOn: notification.isEnabled,
                              showSettings: true,
                              showDelete: true,
                              onToggle: (value) => _mgWerd.toggleNotification(notification.id, value),
                              onSettingsTap: () => _pickTime(notification),
                              onDelete: () => _mgWerd.deleteNotification(notification.id),
                            );
                          },
                          separatorBuilder: (_, __) => 14.heightBox,
                          itemCount: notifications.length,
                        ),
                      ),
                    ],
                  ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You can set multiple alarms to remind you to read the daily awrad'.translated.translateNumbers(),
              textAlign: TextAlign.center,
              style: context.textTheme.primary14W400,
            ),
            16.heightBox,
            Text(
              'No reminders yet'.translated,
              style: context.textTheme.primary14W400.copyWith(color: context.theme.colorScheme.gray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hourOfPeriod = dateTime.hour % 12;
    final hour = hourOfPeriod == 0 ? 12 : hourOfPeriod;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  Future<void> _pickTime(MLocalNotification notification) async {
    final timeOfDay = TimeOfDay(hour: notification.scheduledAt.hour, minute: notification.scheduledAt.minute);
    final TimeOfDay? selected = await showWTimePickerDialog(context, initialTime: timeOfDay);
    if (selected != null) {
      await _mgWerd.updateNotificationTime(notification.id, selected);
    }
  }

  Future<void> _addNotification() async {
    final TimeOfDay? selected = await showWTimePickerDialog(context);
    if (selected != null) {
      await _mgWerd.addNotification(selected);
    }
  }
}
