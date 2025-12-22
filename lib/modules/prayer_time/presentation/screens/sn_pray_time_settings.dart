import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_settings_row_item.dart';
import 'package:al_muslim/core/widgets/w_settings_section_header.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'dart:async';

import 'package:al_muslim/core/config/box_location_config/ds_location_config.dart';
import 'package:al_muslim/modules/prayer_time/data/models/m_city_option.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_location_selection.dart';
import 'package:al_muslim/modules/prayer_time/managers/mg_prayer_time.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/w_change_location_dialog.dart';
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
  late final MgPrayerTime _mgPrayerTime;
  late final MgLocationSelection _mgLocationSelection;
  String? _selectedCityLabel;

  @override
  void initState() {
    super.initState();
    _mgPrayerTime = Modular.get<MgPrayerTime>();
    _mgLocationSelection = Modular.get<MgLocationSelection>();
  }

  Future<void> _openLocationSelection() async {
    final navigation = Modular.to.pushNamed<MCityOption>(RoutesNames.prayTime.locationSelection);
    unawaited(_prepareLocationSelection());

    final result = await navigation;
    if (!mounted) return;
    if (result != null) {
      final languageCode = LocalizeAndTranslate.getLanguageCode();
      final cityDisplay = result.name(languageCode);
      final storedLocation = Modular.get<DSLocationConfig>().getCurrent();
      final fallbackCountry = storedLocation?.country ?? '';
      final countryDisplay =
          _mgLocationSelection.countryDisplayName.isNotEmpty
              ? _mgLocationSelection.countryDisplayName
              : fallbackCountry;
      final countryForGeocoding =
          _mgLocationSelection.countryApiName.isNotEmpty ? _mgLocationSelection.countryApiName : fallbackCountry;
      final saved = await _mgPrayerTime.applyManualLocation(
        cityDisplay: cityDisplay,
        countryDisplay: countryDisplay,
        cityForGeocoding: result.en,
        countryForGeocoding: countryForGeocoding,
      );
      if (!mounted) return;
      if (saved) {
        setState(() {
          _selectedCityLabel = cityDisplay;
        });
      }
    }
  }

  Future<void> _prepareLocationSelection() async {
    final storedLocation = Modular.get<DSLocationConfig>().getCurrent();
    if (storedLocation != null &&
        storedLocation.latitude != 0 &&
        storedLocation.longitude != 0 &&
        storedLocation.country.isNotEmpty) {
      await _mgLocationSelection.loadForLocation(
        latitude: storedLocation.latitude,
        longitude: storedLocation.longitude,
        countryDisplayName: storedLocation.country,
      );
      return;
    }

    if (!_mgLocationSelection.hasCities && !_mgLocationSelection.isLoading) {
      _mgLocationSelection.beginLoading();
    }

    final candidate = await _mgPrayerTime.fetchLocationCandidate();
    if (!mounted) return;
    if (candidate == null) {
      await _mgLocationSelection.loadForLocation(latitude: 0, longitude: 0, countryDisplayName: '');
      return;
    }
    await _mgLocationSelection.loadForLocation(
      latitude: candidate.latitude,
      longitude: candidate.longitude,
      countryDisplayName: candidate.country,
    );
  }

  Future<void> _promptLocationChange() async {
    final candidate = await _mgPrayerTime.fetchLocationCandidate();
    if (!mounted) return;
    final resolvedLabel =
        (candidate?.displayName ?? '').isNotEmpty ? candidate!.displayName : _mgPrayerTime.currentLocationLabel;
    final shouldApply = await showDialog<bool>(
      context: context,
      builder: (context) => WChangeLocationDialog(locationLabel: resolvedLabel, canConfirm: candidate != null),
    );
    if (!mounted) return;
    if (shouldApply == true && candidate != null) {
      await _mgPrayerTime.applyLocation(candidate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      padding: EdgeInsets.zero,
      appBar: WSharedAppBar(title: 'Time Settings'.translated, withBack: true),
      body: AnimatedBuilder(
        animation: _mgPrayerTime,
        builder: (context, child) {
          return ListView(
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
                trailing: Text(_mgPrayerTime.currentLocationLabel, style: context.textTheme.primary16W400),
                onTap: _promptLocationChange,
              ),
              WSettingsRowItem(
                title: 'Automatic location detection'.translated,
                trailing: Switch(
                  value: _mgPrayerTime.isAutoDetectEnabled,
                  onChanged: (value) => _mgPrayerTime.setAutoDetectEnabled(value),
                ),
                onTap: () => _mgPrayerTime.setAutoDetectEnabled(!_mgPrayerTime.isAutoDetectEnabled),
              ),
              WSettingsRowItem(
                title: 'Manual location selection'.translated,
                trailing:
                    _selectedCityLabel != null
                        ? Text(_selectedCityLabel!, style: context.textTheme.primary16W400)
                        : null,
                onTap: _openLocationSelection,
              ),
            ],
          );
        },
      ),
    );
  }
}
