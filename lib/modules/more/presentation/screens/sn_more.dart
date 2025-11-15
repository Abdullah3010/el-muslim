import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/more/presentation/widgets/w_settings_item_divider.dart';
import 'package:al_muslim/modules/more/presentation/widgets/w_settings_row_item.dart';
import 'package:al_muslim/modules/more/presentation/widgets/w_settings_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SnMore extends StatelessWidget {
  const SnMore({super.key});

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      appBar: WSharedAppBar(title: 'More'.translated),
      padding: EdgeInsets.zero,
      withNavBar: true,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // ===== 1. Current Khatma =====
          WSettingsSectionHeader(title: 'Current Khatma'.translated),
          WSettingsRowItem(title: 'Current Khatma'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Previous Awrads'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Next Awrads'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Bookmark'.translated, onTap: () {}),

          // ===== 2. Quranic Sunan =====
          WSettingsSectionHeader(title: 'Quranic Sunan'.translated),
          WSettingsRowItem(title: 'Surah Al-Kahf'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Surah Al-Mulk'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Surah Al-Baqara'.translated, onTap: () {}),

          // ===== 3. Settings =====
          WSettingsSectionHeader(title: 'Settings'.translated),
          WSettingsRowItem(title: 'Daily Awrad Alarm'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Start New Khatma'.translated, onTap: () {}),

          // ===== 4. Prayer Times =====
          WSettingsSectionHeader(title: 'Prayer Times'.translated),
          WSettingsRowItem(title: 'Prayer Time Settings'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Qibla Direction'.translated,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.qibla.qiblaMain);
            },
          ),

          // ===== 5. Adhkar Alarms =====
          WSettingsSectionHeader(title: 'Adhkar Alarms'.translated),
          WSettingsRowItem(title: 'Morning Adhkar Alarm'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Morning Adhkar Time'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Evening Adhkar Alarm'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Evening Adhkar Time'.translated, onTap: () {}),

          // ===== 6. Sunan Alarms =====
          WSettingsSectionHeader(title: 'Sunan Alarms'.translated),
          WSettingsRowItem(title: 'Surah Al-Mulk Alarm'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Surah Al-Mulk Time'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Surah Al-Baqara Alarm'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Surah Al-Baqara Time'.translated, onTap: () {}),

          // ===== 7. Statistics =====
          WSettingsSectionHeader(title: 'Statistics'.translated),
          WSettingsRowItem(title: 'Number of Khatmas'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Last Completed Khatma'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Time Spent in Quran'.translated, onTap: () {}),

          // ===== 8. Others =====
          WSettingsSectionHeader(title: 'Others'.translated),
          WSettingsRowItem(title: 'Language'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Contact Us'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'About App'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Terms & Conditions'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Share App'.translated, onTap: () {}),
        ],
      ),
    );
  }
}
