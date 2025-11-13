import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_app_button.dart';

class WAppDialog extends StatelessWidget {
  const WAppDialog({
    super.key,
    required this.mainActionTitle,
    required this.secondActionTitle,
    required this.onMainAction,
    required this.onSecondAction,
    this.withExit = true,
    this.titleText,
    this.description,
    this.radius,
    this.padding,
    this.mainActionColor,
    this.secondaryBorderColor,
    this.secondaryTextColor,
    this.showCloseIcon = true,
    this.titleStyle,
  });

  final String mainActionTitle;
  final String secondActionTitle;
  final void Function() onMainAction;
  final void Function() onSecondAction;
  final String? titleText;
  final String? description;
  final bool withExit;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final Color? mainActionColor;
  final Color? secondaryBorderColor;
  final Color? secondaryTextColor;
  final TextStyle? titleStyle;
  final bool showCloseIcon;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius ?? 20.r)),
      backgroundColor: context.theme.colorScheme.white,
      child: Stack(
        children: [
          Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(titleText ?? '', textAlign: TextAlign.center, style: titleStyle ?? context.textTheme.blue16w500),
                if (description != null) ...[
                  16.heightBox,
                  Text(description!, textAlign: TextAlign.center, style: context.textTheme.darkGrey14w500),
                ],
                24.heightBox,
                Row(
                  children: [
                    Expanded(
                      child: WAppButton(
                        title: secondActionTitle,
                        onTap: onSecondAction,
                        height: 50.h,
                        radius: 12.r,
                        isFilled: false,
                        withShadow: false,
                        borderColor: secondaryBorderColor ?? theme.colorScheme.buttonColor,
                        style: context.textTheme.button.copyWith(
                          color: secondaryTextColor ?? theme.colorScheme.buttonColor,
                        ),
                      ),
                    ),
                    12.widthBox,
                    Expanded(
                      child: WAppButton(
                        title: mainActionTitle,
                        onTap: onMainAction,
                        height: 50.h,
                        radius: 12.r,
                        withShadow: false,
                        color: mainActionColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showCloseIcon)
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
                splashRadius: 20,
              ),
            ),
        ],
      ),
    );
  }
}
