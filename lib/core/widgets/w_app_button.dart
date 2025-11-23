import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';

class WAppButton extends StatefulWidget {
  const WAppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isFilled = true,
    this.isDisabled = false,
    this.width,
    this.height,
    this.style,
    this.fontSize,
    this.padding,
    this.radius,
    this.color,
    this.borderColor,
    this.icon,
    this.backgroundColor,
    this.textDirection,
    this.customChild,
    this.withShadow = true,
    this.iconRight = false,
    this.iconLeft = true,
  });

  final String title;
  final bool isFilled;
  final bool isDisabled;
  final bool withShadow;
  final bool iconRight;
  final bool iconLeft;
  final Function() onTap;
  final double? width;
  final double? height;
  final double? radius;
  final double? fontSize;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final Widget? customChild;
  final Widget? icon;
  final Color? backgroundColor;
  final TextDirection? textDirection;

  @override
  State<WAppButton> createState() => _WAppButtonState();
}

class _WAppButtonState extends State<WAppButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (!isLoading && !widget.isDisabled) ? onTap : null,
      child: Container(
        width: widget.width ?? 323.w,
        height: widget.height ?? 44.h,
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 26.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius ?? 16.r),
          boxShadow:
              widget.withShadow
                  ? [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 3.r, offset: const Offset(0, 4)),
                  ]
                  : null,
          color:
              widget.color ??
              ((widget.backgroundColor != null)
                  ? widget.backgroundColor
                  : widget.isFilled
                  ? (!(widget.isDisabled) ? context.theme.colorScheme.buttonColor : context.theme.colorScheme.lightGray)
                  : (!(widget.isDisabled)
                      ? context.theme.colorScheme.white
                      : context.theme.colorScheme.lightGray.withValues(alpha: 0.7))),
          border:
              !widget.isFilled
                  ? Border.all(
                    color:
                        widget.borderColor ??
                        (!(widget.isDisabled)
                            ? context.theme.colorScheme.buttonColor
                            : context.theme.colorScheme.lightGray),
                    width: 1.w,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  )
                  : null,
        ),
        child:
            isLoading
                ? CupertinoActivityIndicator(color: context.theme.colorScheme.white)
                : Center(
                  child: Directionality(
                    textDirection: widget.textDirection ?? TextDirection.ltr,
                    child:
                        widget.customChild ??
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.iconLeft && widget.icon != null) widget.icon!,
                            if (widget.iconLeft && widget.icon != null) 10.widthBox,
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style:
                                  widget.style ??
                                  context.textTheme.button.copyWith(
                                    fontSize: widget.fontSize,
                                    color:
                                        widget.isFilled
                                            ? (!(widget.isDisabled)
                                                ? context.theme.colorScheme.white
                                                : context.theme.colorScheme.lightGray)
                                            : (!(widget.isDisabled)
                                                ? context.theme.colorScheme.buttonColor
                                                : context.theme.colorScheme.lightGray),
                                  ),
                            ),
                            if (widget.iconRight && widget.icon != null) widget.icon!,
                            if (widget.iconRight && widget.icon != null) 10.widthBox,
                          ],
                        ),
                  ),
                ),
      ),
    );
  }

  Future<void> onTap() async {
    if (!widget.isDisabled) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      await widget.onTap();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
