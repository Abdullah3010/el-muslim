import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_settings_section_header.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WNewWerdBottomSheet extends StatelessWidget {
  const WNewWerdBottomSheet({super.key});

  static const List<MWerdPlanOption> _options = [
    MWerdPlanOption(
      titleAr: 'ختمة 240 يوما',
      titleEn: 'Werd 240 days',
      subtitleAr: 'الورد اليومي ربع',
      subtitleEn: 'Daily portion 1/4 Juz',
    ),
    MWerdPlanOption(
      titleAr: 'ختمة 120 يوما',
      titleEn: 'Werd 120 days',
      subtitleAr: 'الورد اليومي نصف',
      subtitleEn: 'Daily portion 1/2 Juz',
    ),
    MWerdPlanOption(
      titleAr: 'ختمة 80 يوما',
      titleEn: 'Werd 80 days',
      subtitleAr: 'الورد اليومي 3 أرباع',
      subtitleEn: 'Daily portion 3/4 Juz',
    ),
    MWerdPlanOption(
      titleAr: 'ختمة 60 يوما',
      titleEn: 'Werd 60 days',
      subtitleAr: 'الورد اليومي 4 أرباع',
      subtitleEn: 'Daily portion 1 Juz',
    ),
    MWerdPlanOption(
      titleAr: 'ختمة 40 يوما',
      titleEn: 'Werd 40 days',
      subtitleAr: 'الورد اليومي 6 أرباع',
      subtitleEn: 'Daily portion 1.5 Juz',
    ),
    MWerdPlanOption(
      titleAr: 'ختمة 30 يوما',
      titleEn: 'Werd 30 days',
      subtitleAr: 'الورد اليومي 2 جزء',
      subtitleEn: 'Daily portion 2 Juz',
    ),
    MWerdPlanOption(
      titleAr: 'ختمة 29 يوما',
      titleEn: 'Werd 29 days',
      subtitleAr: 'الورد اليومي 2.5 جزء',
      subtitleEn: 'Daily portion 2.5 Juz',
    ),
  ];

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const WNewWerdBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const recommendedOption = MWerdPlanOption(
      titleAr: 'ختمة 30 يوما',
      titleEn: 'Werd 30 days',
      subtitleAr: 'الورد اليومي 1 جزء',
      subtitleEn: 'Daily portion 1 Juz',
    );

    return Container(
      constraints: BoxConstraints(maxHeight: context.height * 0.75),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            8.heightBox,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: context.theme.colorScheme.primaryColor),
                      ),
                      Expanded(
                        child: Text(
                          'New Werd'.translated,
                          textAlign: TextAlign.center,
                          style: context.textTheme.primary18W500,
                        ),
                      ),
                      SizedBox(width: 48.w),
                    ],
                  ),
                  WSettingsSectionHeader(title: 'Suggested'.translated),
                  8.heightBox,
                ],
              ),
            ),
            WNewWerdOptionItem(option: recommendedOption, onTap: () => _selectOption(context, recommendedOption)),
            WSettingsSectionHeader(title: 'All'.translated),
            Expanded(child: ListView(children: [12.heightBox, _buildOptionList(context, _options)])),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionList(BuildContext context, List<MWerdPlanOption> options) {
    return Column(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          WNewWerdOptionItem(option: options[i], onTap: () => _selectOption(context, options[i])),
          if (i < options.length - 1)
            Divider(color: context.theme.colorScheme.secondaryColor, height: 1, indent: 20.w, endIndent: 20.w),
        ],
      ],
    );
  }

  void _selectOption(BuildContext context, MWerdPlanOption option) {
    Navigator.of(context).pop();
    Future.microtask(() => Modular.to.pushNamed(RoutesNames.werd.werdDetails, arguments: option));
  }
}
