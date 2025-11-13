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
    this.withBack = true,
    this.withScaffoldBackground = false,
    this.onBackTap,
  });

  final String? title;
  final bool withBack;
  final bool withScaffoldBackground;
  final Widget? action;
  final void Function()? onBackTap;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: context.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Center(child: Text(title ?? '', style: context.textTheme.orange24w700Arial, textAlign: TextAlign.center)),
          Row(
            children: [
              12.widthBox,
              if (withBack) ...[
                InkWell(
                  onTap:
                      onBackTap ??
                      () {
                        Modular.to.pop();
                      },
                  child: Transform.rotate(
                    angle: context.languageCode == 'ar' ? 180 * 3.14 / 180 : 0,
                    child: SizedBox(
                      width: 16.w,
                      height: 28.h,
                      child: SvgPicture.asset(
                        Assets.icons.newIcons.backIcon.path,
                        colorFilter: ColorFilter.mode(context.theme.colorScheme.primaryOrange, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              if (action != null) action! else 40.widthBox,
            ],
          ),
        ],
      ),
    );
  }
}
