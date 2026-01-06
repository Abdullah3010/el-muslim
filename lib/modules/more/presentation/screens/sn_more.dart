import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/notification/local_notification_service.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_settings_row_item.dart';
import 'package:al_muslim/core/widgets/w_settings_section_header.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/index/managers/mg_index.dart';
import 'package:al_muslim/modules/more/managers/mg_more.dart';
import 'package:al_muslim/modules/more/presentation/widgets/w_alarm_row.dart';
import 'package:al_muslim/modules/more/presentation/widgets/w_language_selector_dialog.dart';
import 'package:al_muslim/modules/more/presentation/widgets/w_settings_item_divider.dart';
import 'package:al_muslim/modules/quran/presentation/widgets/w_quran_library_bookmarks_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_library/quran_library.dart';

class SnMore extends StatelessWidget {
  const SnMore({super.key});

  @override
  Widget build(BuildContext context) {
    final mgMore = Modular.get<MgMore>();

    return WSharedScaffold(
      appBar: WSharedAppBar(title: 'More'.translated, withBack: false),
      padding: EdgeInsets.zero,
      withNavBar: true,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // ===== 1. Current Khatma =====
          GestureDetector(
            onTap: () => Modular.to.pushNamed(RoutesNames.werd.previousWerd),
            child: WSettingsSectionHeader(title: 'Current Khatma'.translated),
          ),
          WSettingsRowItem(
            title: 'Previous Awrads'.translated,
            onTap: () => Modular.to.pushNamed(RoutesNames.werd.previousWerd),
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Next Awrads'.translated,
            onTap: () => Modular.to.pushNamed(RoutesNames.werd.nextWerd),
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Bookmark'.translated,
            onTap: () {
              _openQuranBookmarks(context);
            },
          ),

          // ===== 2. Quranic Sunan =====
          WSettingsSectionHeader(title: 'Quranic Sunan'.translated),
          WSettingsRowItem(
            title: 'Surah Al-Kahf'.translated,
            onTap: () {
              Modular.get<MgIndex>().selectIndex(17);
            },
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Surah Al-Mulk'.translated,
            onTap: () {
              Modular.get<MgIndex>().selectIndex(66);
            },
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Surah Al-Baqara'.translated,
            onTap: () {
              Modular.get<MgIndex>().selectIndex(1);
            },
          ),

          // ===== 3. Settings =====
          WSettingsSectionHeader(title: 'Settings'.translated),
          WSettingsRowItem(
            title: 'Daily Awrad Alarm'.translated,
            icon: Assets.icons.notification.path,
            onTap: () => Modular.to.pushNamed(RoutesNames.werd.dailyAwradAlarm),
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Start New Khatma'.translated,
            onTap: () async {
              Modular.get<LocalNotificationService>().debugPrintScheduledNotifications();
              // Modular.get<LocalNotificationService>().showTestNotification();
            },
          ),

          // ===== 4. Prayer Times =====
          WSettingsSectionHeader(title: 'Prayer Times'.translated),
          WSettingsRowItem(title: 'Prayer Time Settings'.translated, icon: Assets.icons.mosque.path, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Qiblah Direction'.translated,
            icon: Assets.icons.qipla.path,
            onTap: () {
              Modular.to.pushNamed(RoutesNames.qibla.qiblaMain);
            },
          ),

          // ===== 5. Adhkar Alarms =====
          WSettingsSectionHeader(title: 'Adhkar Alarms'.translated),
          AlarmEnableRow(
            manager: mgMore,
            notificationId: Constants.morningAzkarNotificationId,
            title: 'Morning Adhkar Alarm'.translated,
            icon: Assets.icons.sun.path,
            defaultTime: const TimeOfDay(hour: 7, minute: 26),
          ),
          const WSettingsItemDivider(),
          AlarmTimeRow(
            manager: mgMore,
            notificationId: Constants.morningAzkarNotificationId,
            title: 'Morning Adhkar Time'.translated,
            icon: Assets.icons.clock.path,
            defaultTime: const TimeOfDay(hour: 7, minute: 26),
          ),
          const WSettingsItemDivider(),
          AlarmEnableRow(
            manager: mgMore,
            notificationId: Constants.eveningAzkarNotificationId,
            title: 'Evening Adhkar Alarm'.translated,
            icon: Assets.icons.moon.path,
            defaultTime: const TimeOfDay(hour: 19, minute: 0),
          ),
          const WSettingsItemDivider(),
          AlarmTimeRow(
            manager: mgMore,
            notificationId: Constants.eveningAzkarNotificationId,
            title: 'Evening Adhkar Time'.translated,
            icon: Assets.icons.clock.path,
            defaultTime: const TimeOfDay(hour: 19, minute: 0),
          ),

          // ===== 6. Sunan Alarms =====
          WSettingsSectionHeader(title: 'Sunan Alarms'.translated),
          AlarmEnableRow(
            manager: mgMore,
            notificationId: Constants.almulkQuranNotificationId,
            title: 'Surah Al-Mulk Alarm'.translated,
            icon: Assets.icons.notification.path,
            defaultTime: const TimeOfDay(hour: 7, minute: 26),
          ),
          const WSettingsItemDivider(),
          AlarmTimeRow(
            manager: mgMore,
            notificationId: Constants.almulkQuranNotificationId,
            title: 'Surah Al-Mulk Time'.translated,
            icon: Assets.icons.clock.path,
            defaultTime: const TimeOfDay(hour: 7, minute: 26),
          ),
          const WSettingsItemDivider(),
          AlarmEnableRow(
            manager: mgMore,
            notificationId: Constants.albakraQuranNotificationId,
            title: 'Surah Al-Baqara Alarm'.translated,
            icon: Assets.icons.notification.path,
            defaultTime: const TimeOfDay(hour: 7, minute: 26),
          ),
          const WSettingsItemDivider(),
          AlarmTimeRow(
            manager: mgMore,
            notificationId: Constants.albakraQuranNotificationId,
            title: 'Surah Al-Baqara Time'.translated,
            icon: Assets.icons.clock.path,
            defaultTime: const TimeOfDay(hour: 7, minute: 26),
          ),

          // ===== 7. Statistics =====
          WSettingsSectionHeader(title: 'Statistics'.translated),
          WSettingsRowItem(
            title: 'Number of Khatmas'.translated,
            trailing: Text('-'.translated, style: context.theme.textTheme.primary16W400),
            onTap: () {},
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Last Completed Khatma'.translated,
            trailing: Text('-'.translated, style: context.theme.textTheme.primary16W400),
            onTap: () {},
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Time Spent in Quran'.translated,
            icon: Assets.icons.clock.path,
            trailing: Text('Hour'.translated, style: context.theme.textTheme.primary16W400),
            onTap: () {},
          ),

          // ===== 8. Others =====
          WSettingsSectionHeader(title: 'Others'.translated),
          WSettingsRowItem(
            title: 'Language'.translated,
            icon: Assets.icons.settings.path,
            onTap: () => WLanguageSelectorDialog.show(context),
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Contact Us'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'About App'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Terms & Conditions'.translated, onTap: () {}),
          const WSettingsItemDivider(),
          WSettingsRowItem(title: 'Share App'.translated, trailing: Assets.icons.share.svg(), onTap: () {}),
          Constants.navbarHeight.verticalSpace,
        ],
      ),
    );
  }

  Future<void> _openQuranBookmarks(BuildContext context) async {
    final BookmarkModel? selected = await WQuranLibraryBookmarksSheet.show(context);
    if (selected == null) return;
    Modular.to.pushNamed(RoutesNames.quran.quranMain, arguments: selected);
  }
}
