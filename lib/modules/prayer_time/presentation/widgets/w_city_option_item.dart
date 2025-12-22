import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:al_muslim/modules/prayer_time/data/models/m_city_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class WCityOptionItem extends StatelessWidget {
  const WCityOptionItem({super.key, required this.city, this.onTap});

  final MCityOption city;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String name = city.name(LocalizeAndTranslate.getLanguageCode());

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(children: [Expanded(child: Text(name, style: context.textTheme.primary18W500))]),
      ),
    );
  }
}
