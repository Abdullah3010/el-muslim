import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WPreviousWerdItem extends StatelessWidget {
  const WPreviousWerdItem({super.key, required this.fromText, required this.toText, this.onTap});

  final String fromText;
  final String toText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.secondaryColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 300.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fromText.translateNumbers(), style: context.textTheme.primary16W500),
                  6.heightBox,
                  Text(toText.translateNumbers(), style: context.textTheme.primary16W500),
                ],
              ),
            ),
            const Spacer(),
            WLocalizeRotation(reverse: true, child: Assets.icons.backGold.svg(width: 16.w, height: 16.h)),
          ],
        ),
      ),
    );
  }
}
