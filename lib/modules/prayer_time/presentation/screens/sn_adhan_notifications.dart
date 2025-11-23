import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_settings_row_item.dart';
import 'package:al_muslim/core/widgets/w_settings_section_header.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SnAdhanNotifications extends StatefulWidget {
  const SnAdhanNotifications({super.key});

  @override
  State<SnAdhanNotifications> createState() => _SnAdhanNotificationsState();
}

class _SnAdhanNotificationsState extends State<SnAdhanNotifications> {
  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      padding: EdgeInsets.zero,
      appBar: WSharedAppBar(title: 'Adhan Notifications'.translated, withBack: true),
      body: ListView(
        children: [
          WSettingsSectionHeader(title: 'Prayer Notifications'.translated),
          WSettingsRowItem(
            title: 'Fajr'.translated,
            icon: Assets.icons.notification.path,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.prayTime.adhanSettings, arguments: {'adhanIndex': 0});
            },
          ),
          WSettingsRowItem(
            title: 'Sunrise'.translated,
            icon: Assets.icons.notification.path,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.prayTime.adhanSettings, arguments: {'adhanIndex': 1});
            },
          ),
          WSettingsRowItem(
            title: 'Dhuhr'.translated,
            icon: Assets.icons.notification.path,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.prayTime.adhanSettings, arguments: {'adhanIndex': 2});
            },
          ),
          WSettingsRowItem(
            title: 'Asr'.translated,
            icon: Assets.icons.notification.path,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.prayTime.adhanSettings, arguments: {'adhanIndex': 3});
            },
          ),
          WSettingsRowItem(
            title: 'Maghrib'.translated,
            icon: Assets.icons.notification.path,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.prayTime.adhanSettings, arguments: {'adhanIndex': 4});
            },
          ),
          WSettingsRowItem(
            title: 'Isha'.translated,
            icon: Assets.icons.notification.path,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.prayTime.adhanSettings, arguments: {'adhanIndex': 5});
            },
          ),
        ],
      ),
    );
  }
}
