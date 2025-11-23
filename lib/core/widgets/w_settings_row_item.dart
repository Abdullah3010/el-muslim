import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WSettingsRowItem extends StatelessWidget {
  final String title;
  final String? icon;
  final Widget? trailing;
  final VoidCallback? onTap;

  const WSettingsRowItem({super.key, required this.title, this.icon, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60.h,
        padding: EdgeInsets.symmetric(horizontal: 19.w),
        child: Row(
          children: [
            if (icon != null) ...[SvgPicture.asset(icon!, width: 22.w, height: 22.h), 12.widthBox],
            Text(title, style: context.textTheme.primary16W500),
            const Spacer(),
            trailing ?? SvgPicture.asset(Assets.icons.backGold.path, width: 20.w, height: 20.h),
          ],
        ),
      ),
    );
  }
}
