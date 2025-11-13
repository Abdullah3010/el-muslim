import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_app_button.dart';

class WAppBottomSheet extends StatelessWidget {
  const WAppBottomSheet({
    super.key,
    this.mainActionTitle,
    this.maxHeight,
    this.maxWidth,
    this.onMainAction,
    this.titleText,
    this.buttonWidth,
    this.removeBack,
    this.titleWidget,
    this.withCancel = false,
    this.withConstraints = true,
    required this.child,
  });

  final Widget child;
  final double? maxHeight;
  final double? maxWidth;
  final double? buttonWidth;
  final String? mainActionTitle;
  final void Function()? onMainAction;

  final bool? removeBack;
  final bool? withConstraints;
  final bool? withCancel;
  final String? titleText;
  final Widget? titleWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          withConstraints == true
              ? BoxConstraints(maxHeight: maxHeight ?? double.infinity, maxWidth: maxWidth ?? context.width * 0.8)
              : null,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        top: 32.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10.h,
      ),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40.r), topRight: Radius.circular(40.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!(removeBack == true))
                InkWell(
                  onTap: () => Modular.to.pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.rotate(
                      angle: context.languageCode == 'ar' ? 180 * 3.14 / 180 : 0,
                      child: SvgPicture.asset(
                        Assets.icons.backArrow.path,
                        colorFilter: ColorFilter.mode(context.theme.colorScheme.secondaryBlue, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              if (titleWidget != null) titleWidget ?? const SizedBox(),
              if (titleText != null && titleWidget == null && titleText?.isEmpty == false)
                Expanded(
                  child: Text(titleText ?? '', style: context.textTheme.blue16w500, textAlign: TextAlign.center),
                ),
              40.widthBox,
            ],
          ),
          24.verticalSpace,
          if (withConstraints == true) Expanded(child: child) else child,
          20.verticalSpace,
          if (mainActionTitle != null && mainActionTitle?.isNotEmpty == true && onMainAction != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  (withCancel ?? false)
                      ? [
                        Expanded(child: WAppButton(title: mainActionTitle ?? '', onTap: onMainAction ?? () {})),
                        60.horizontalSpace,
                        Expanded(
                          child: WAppButton(
                            title: 'Cancel',
                            isFilled: false,
                            onTap: () {
                              Modular.to.pop();
                            },
                          ),
                        ),
                      ]
                      : [WAppButton(width: buttonWidth, title: mainActionTitle ?? '', onTap: onMainAction ?? () {})],
            ),
          20.verticalSpace,
        ],
      ),
    );
  }
}
