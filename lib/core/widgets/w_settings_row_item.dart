import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WSettingsRowItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const WSettingsRowItem({super.key, required this.title, this.subtitle, this.icon, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: subtitle != null ? 70.h : 60.h,
        padding: EdgeInsets.symmetric(horizontal: 19.w),
        child: Row(
          children: [
            if (icon != null) ...[SvgPicture.asset(icon!, width: 22.w, height: 22.h), 12.widthBox],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.textTheme.primary16W500),
                  if (subtitle != null) ...[
                    Text(subtitle!, style: context.textTheme.primary14W400.copyWith(color: Colors.grey)),
                  ],
                ],
              ),
            ),
            trailing ??
                WLocalizeRotation(child: SvgPicture.asset(Assets.icons.backGold.path, width: 20.w, height: 20.h)),
          ],
        ),
      ),
    );
  }
}
