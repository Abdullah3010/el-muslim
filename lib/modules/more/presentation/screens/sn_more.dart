import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/notification/notification_box/ds_notification.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/index/managers/mg_index.dart';
import 'package:al_muslim/modules/more/presentation/widgets/w_settings_item_divider.dart';
import 'package:al_muslim/core/widgets/w_settings_row_item.dart';
import 'package:al_muslim/core/widgets/w_settings_section_header.dart';
import 'package:al_muslim/modules/quran/managers/mg_quran.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnMore extends StatelessWidget {
  const SnMore({super.key});

  @override
  Widget build(BuildContext context) {
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
              Modular.get<MgQuran>().openQuranFromBookmark();
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
            onTap: () {
              final notifications = Modular.get<DSNotification>().getAll();
              notifications.forEach((notification) async {
                // await Modular.get<DSNotification>().createUpdate(notification.copyWith(repeatDaily: true));
                print(" ========================================= ");
                print(" =====>>>> ${notification.id} - ${notification.isEnabled} ");
                print(" =====>>>> ${notification.title} - ${notification.body} ");
                print(" =====>>>> ${notification.deepLink} - ${notification.scheduledAt} ");
                print(" =====>>>> ${notification.payload} - ${notification.isEnabled} ");
                print(" =====>>>> ${notification.repeatDaily}  ");
              });
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
          WSettingsRowItem(
            title: 'Morning Adhkar Alarm'.translated,
            icon: Assets.icons.sun.path,
            trailing: Switch(value: true, onChanged: (value) {}),
            onTap: () {},
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Morning Adhkar Time'.translated,
            icon: Assets.icons.clock.path,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('07:26 ص'.translated, style: context.theme.textTheme.primary16W400),
                10.widthBox,
                Assets.icons.backGold.svg(width: 20.w, height: 20.h),
              ],
            ),
            onTap: () {},
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Evening Adhkar Alarm'.translated,
            icon: Assets.icons.moon.path,
            trailing: Switch(value: true, onChanged: (value) {}),
            onTap: () {},
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Evening Adhkar Time'.translated,
            icon: Assets.icons.clock.path,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('07:26 ص'.translated, style: context.theme.textTheme.primary16W400),
                10.widthBox,
                Assets.icons.backGold.svg(width: 20.w, height: 20.h),
              ],
            ),
            onTap: () {},
          ),

          // ===== 6. Sunan Alarms =====
          WSettingsSectionHeader(title: 'Sunan Alarms'.translated),
          WSettingsRowItem(
            title: 'Surah Al-Mulk Alarm'.translated,
            icon: Assets.icons.notification.path,
            trailing: Switch(value: true, onChanged: (value) {}),
            onTap: () {},
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Surah Al-Mulk Time'.translated,
            icon: Assets.icons.clock.path,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('07:26 ص'.translated, style: context.theme.textTheme.primary16W400),
                10.widthBox,
                Assets.icons.backGold.svg(width: 20.w, height: 20.h),
              ],
            ),
            onTap: () {},
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Surah Al-Baqara Alarm'.translated,
            icon: Assets.icons.notification.path,
            trailing: Switch(value: true, onChanged: (value) {}),
            onTap: () {},
          ),
          const WSettingsItemDivider(),
          WSettingsRowItem(
            title: 'Surah Al-Baqara Time'.translated,
            icon: Assets.icons.clock.path,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('07:26 ص'.translated, style: context.theme.textTheme.primary16W400),
                10.widthBox,
                Assets.icons.backGold.svg(width: 20.w, height: 20.h),
              ],
            ),
            onTap: () {},
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
          WSettingsRowItem(title: 'Language'.translated, icon: Assets.icons.settings.path, onTap: () {}),
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
}
