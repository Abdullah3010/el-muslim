import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';

class WSharedAppBar extends StatelessWidget {
  const WSharedAppBar({
    super.key,
    this.title,
    this.action,
    this.leading,
    this.leadingInfo,
    this.withBack = true,
    this.withScaffoldBackground = false,
    this.onBackTap,
  });

  final String? title;
  final bool withBack;
  final bool withScaffoldBackground;
  final Widget? action;
  final Widget? leading;
  final Widget? leadingInfo;
  final void Function()? onBackTap;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Center(child: Text(title ?? '', style: context.textTheme.primary20W500, textAlign: TextAlign.center)),
          Row(
            children: [
              12.widthBox,
              if (withBack && leading == null) ...[
                InkWell(
                  onTap:
                      onBackTap ??
                      () {
                        Modular.to.pop();
                      },
                  child: Transform.rotate(
                    angle: context.languageCode == 'ar' ? 180 * 3.14 / 180 : 0,
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: SvgPicture.asset(
                        Assets.icons.backGold.path,
                        colorFilter: ColorFilter.mode(context.theme.colorScheme.primaryColor2, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
              if (leading != null) leading!,
              if (leadingInfo != null) ...[8.widthBox, leadingInfo!],
              const Spacer(),
              if (action != null) action! else 40.widthBox,
            ],
          ),
        ],
      ),
    );
  }
}
