import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WSharedContainer extends StatelessWidget {
  const WSharedContainer({
    required this.child,
    required this.childWidth,
    this.top,
    this.topHeight,
    this.button,
    this.padding,
    this.buttonHeight,
    super.key,
  });

  final Widget child;
  final double childWidth;
  final double? buttonHeight;
  final Widget? top;
  final double? topHeight;
  final Widget? button;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: childWidth,
          margin: EdgeInsets.only(bottom: buttonHeight ?? 0, top: topHeight ?? 0),
          padding: padding ?? EdgeInsets.all(25.w),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.white,
            borderRadius: BorderRadius.circular(40.r),
            boxShadow: const [BoxShadow(color: Color(0x3610A666), blurRadius: 32, offset: Offset(0, 16))],
          ),
          child: child,
        ),
        if (top != null && topHeight != null) Positioned(top: topHeight! / 2, child: Skeleton.leaf(child: top!)),
        if (button != null && buttonHeight != null)
          Positioned(bottom: buttonHeight! / 2, child: Skeleton.leaf(child: button!)),
      ],
    );
  }
}
