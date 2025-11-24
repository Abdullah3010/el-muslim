import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_daily_awrad_alarm_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnDailyAwradAlarm extends StatefulWidget {
  const SnDailyAwradAlarm({super.key});

  @override
  State<SnDailyAwradAlarm> createState() => _SnDailyAwradAlarmState();
}

class _SnDailyAwradAlarmState extends State<SnDailyAwradAlarm> {
  late List<_DailyAlarm> _alarms;

  @override
  void initState() {
    super.initState();
    _alarms = [
      _DailyAlarm(time: const TimeOfDay(hour: 16, minute: 0), isOn: true, showSettings: true),
      _DailyAlarm(time: const TimeOfDay(hour: 17, minute: 0)),
      _DailyAlarm(time: const TimeOfDay(hour: 18, minute: 0)),
      _DailyAlarm(time: const TimeOfDay(hour: 19, minute: 0)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      appBar: WSharedAppBar(title: 'Daily Awrad Alarm'.translated),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        children: [
          Text(
            'You can set multiple alarms to remind you to read the daily awrad'.translated.translateNumbers(),
            style: context.textTheme.primary14W400,
            textAlign: TextAlign.center,
          ),
          24.heightBox,
          ...List.generate(_alarms.length, (index) {
            final _DailyAlarm alarm = _alarms[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index == _alarms.length - 1 ? 0 : 12.h),
              child: WDailyAwradAlarmItem(
                timeLabel: _formatTime(alarm.time).translateNumbers(),
                isOn: alarm.isOn,
                showSettings: alarm.showSettings,
                onToggle: (value) => setState(() => _alarms[index] = alarm.copyWith(isOn: value)),
                onSettingsTap: () => _showTimePicker(index),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay timeOfDay) {
    final int hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final String minute = timeOfDay.minute.toString().padLeft(2, '0');
    final String period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  Future<void> _showTimePicker(int index) async {
    final _DailyAlarm alarm = _alarms[index];
    TimeOfDay tempTime = alarm.time;

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
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
                    initialDateTime: DateTime(0, 1, 1, tempTime.hour, tempTime.minute),
                    onDateTimeChanged: (dateTime) {
                      tempTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
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
                      setState(() {
                        _alarms[index] = alarm.copyWith(time: tempTime);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Confirm'.translated, style: context.textTheme.white16W500),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DailyAlarm {
  const _DailyAlarm({required this.time, this.isOn = false, this.showSettings = false});

  final TimeOfDay time;
  final bool isOn;
  final bool showSettings;

  _DailyAlarm copyWith({TimeOfDay? time, bool? isOn, bool? showSettings}) {
    return _DailyAlarm(
      time: time ?? this.time,
      isOn: isOn ?? this.isOn,
      showSettings: showSettings ?? this.showSettings,
    );
  }
}
