import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_settings_row_item.dart';
import 'package:al_muslim/core/widgets/w_settings_section_header.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/prayer_time/data/models/m_city_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';

class SnPrayTimeSettings extends StatefulWidget {
  const SnPrayTimeSettings({super.key});

  @override
  State<SnPrayTimeSettings> createState() => _SnPrayTimeSettingsState();
}

class _SnPrayTimeSettingsState extends State<SnPrayTimeSettings> {
  String? _selectedCityLabel;

  Future<void> _openLocationSelection() async {
    final result = await Modular.to.pushNamed<MCityOption>(RoutesNames.prayTime.locationSelection);
    if (result != null) {
      setState(() {
        _selectedCityLabel = result.name(LocalizeAndTranslate.getLanguageCode());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      padding: EdgeInsets.zero,
      appBar: WSharedAppBar(title: 'Time Settings'.translated, withBack: true),
      body: ListView(
        children: [
          WSettingsSectionHeader(title: 'Qiblah'.translated),
          WSettingsRowItem(
            title: 'Qiblah Direction'.translated,
            icon: Assets.icons.qipla.path,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.qibla.qiblaMain);
            },
          ),
          WSettingsSectionHeader(title: 'Notifications'.translated),
          WSettingsRowItem(
            title: 'Adhan Notifications'.translated,
            icon: Assets.icons.notification.path,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.prayTime.adhanNotifications);
            },
          ),
          WSettingsSectionHeader(title: 'Location'.translated),
          WSettingsRowItem(
            title: 'Current Location'.translated,
            trailing:
                _selectedCityLabel != null
                    ? Text(_selectedCityLabel!, style: context.textTheme.primary16W400)
                    : const SizedBox.shrink(),
            onTap: _openLocationSelection,
          ),
          WSettingsRowItem(
            title: 'Automatic location detection'.translated,
            trailing: Switch(value: true, onChanged: (value) {}),
            onTap: () {},
          ),
          WSettingsRowItem(title: 'Manual location selection'.translated, onTap: () {}),
        ],
      ),
    );
  }
}
