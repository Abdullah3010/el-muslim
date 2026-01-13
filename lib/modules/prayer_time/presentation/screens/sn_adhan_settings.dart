import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/widgets/w_settings_row_item.dart';
import 'package:al_muslim/core/widgets/w_settings_section_header.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_prayer_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SnAdhanSettings extends StatefulWidget {
  const SnAdhanSettings({super.key, this.adhanIndex});

  final int? adhanIndex;

  @override
  State<SnAdhanSettings> createState() => _SnAdhanSettingsState();
}

class _SnAdhanSettingsState extends State<SnAdhanSettings> {
  @override
  Widget build(BuildContext context) {
    final mgPrayerTime = Modular.get<MgPrayerTime>();
    final int index = widget.adhanIndex ?? 0;
    final String prayerName = mgPrayerTime.prayerNames[index.clamp(0, mgPrayerTime.prayerNames.length - 1)];
    return WSharedScaffold(
      padding: EdgeInsets.zero,
      appBar: WSharedAppBar(
        title: widget.adhanIndex != null ? '${'Adhan'.translated} ${prayerName.translated} ' : 'Adhan Settings',
        withBack: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          WSettingsSectionHeader(title: 'Adhan Settings'.translated),
          WSettingsRowItem(title: 'Silent'.translated, icon: Assets.icons.notification.path, onTap: () {}),
          // WSettingsRowItem(title: 'Device alert sound'.translated, icon: Assets.icons.notification.path, onTap: () {}),
          // WSettingsRowItem(
          //   title: 'أذان الحرم المكي ـ علي الملا'.translated,
          //   icon: Assets.icons.notification.path,
          //   onTap: () {},
          // ),
          // WSettingsRowItem(title: 'أذان المدينة'.translated, icon: Assets.icons.notification.path, onTap: () {}),
        ],
      ),
    );
  }
}
