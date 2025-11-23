import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/widgets/w_settings_row_item.dart';
import 'package:al_muslim/core/widgets/w_settings_section_header.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/adhan_reminder_picker_bottom_sheet.dart';

class SnAdhanSettings extends StatefulWidget {
  const SnAdhanSettings({super.key, this.adhanIndex});

  final int? adhanIndex;

  @override
  State<SnAdhanSettings> createState() => _SnAdhanSettingsState();
}

class _SnAdhanSettingsState extends State<SnAdhanSettings> {
  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      padding: EdgeInsets.zero,
      appBar: WSharedAppBar(
        title: widget.adhanIndex != null ? 'Adhan ${widget.adhanIndex}' : 'Adhan Settings',
        withBack: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          WSettingsSectionHeader(title: 'Before Adhan Notification'.translated),
          WSettingsRowItem(
            title: 'Notify Before Adhan'.translated,
            icon: Assets.icons.notification.path,

            onTap: () {
              AdhanReminderPickerBottomSheet.show(context, initialIndex: 0);
            },
          ),
          WSettingsSectionHeader(title: 'Before Adhan Notification'.translated),
          WSettingsRowItem(title: 'Stop'.translated, icon: Assets.icons.notification.path, onTap: () {}),
          WSettingsRowItem(title: 'Silent'.translated, icon: Assets.icons.notification.path, onTap: () {}),
          WSettingsRowItem(title: 'Device alert sound'.translated, icon: Assets.icons.notification.path, onTap: () {}),
          WSettingsRowItem(
            title: 'أذان الحرم المكي ـ علي الملا'.translated,
            icon: Assets.icons.notification.path,
            onTap: () {},
          ),
          WSettingsRowItem(title: 'أذان المدينة'.translated, icon: Assets.icons.notification.path, onTap: () {}),
        ],
      ),
    );
  }
}
