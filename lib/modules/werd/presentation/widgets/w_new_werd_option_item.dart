import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class WNewWerdOptionItem extends StatelessWidget {
  const WNewWerdOptionItem({super.key, required this.option, this.onTap});

  final MWerdPlanOption option;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final String subtitle = context.isRTL ? option.subtitleAr : option.subtitleEn;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 20.w),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: context.isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(context.isRTL ? option.titleAr : option.titleEn, style: context.textTheme.primary16W500),
                if (subtitle.isNotEmpty) ...[4.heightBox, Text(subtitle, style: context.textTheme.primary14W400)],
              ],
            ),
            const Spacer(),

            WLocalizeRotation(child: Assets.icons.backGold.svg(width: 14.w, height: 14.h)),
          ],
        ),
      ),
    );
  }
}
