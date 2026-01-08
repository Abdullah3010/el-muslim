import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class WSurahRow extends StatelessWidget {
  const WSurahRow({super.key, required this.surah, this.onTap});

  final MQuranIndex surah;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 5.h),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Directionality(
                  textDirection: LocalizeAndTranslate.getLanguageCode() == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                  child: Row(
                    children: [
                      Container(
                        width: 26.w,
                        height: 26.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.theme.colorScheme.secondaryColor,
                        ),
                        child: Center(
                          child: Text(
                            surah.number.toString().translateNumbers(),
                            style: context.textTheme.primary14W400,
                          ),
                        ),
                      ),
                      12.widthBox,
                      Text(
                        context.isRTL ? surah.name.ar : surah.name.transliteration,
                        style: context.textTheme.primary18W500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '${'Page'.translated} ${surah.firstPage.madani.toString().translateNumbers()}',
                  style: context.textTheme.primary16W500,
                ),
                8.widthBox,
                WLocalizeRotation(child: Assets.icons.backGold.svg(width: 18.w, height: 18.h)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
