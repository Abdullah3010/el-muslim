import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/num_ext.dart';

class WInputPrefixIcon extends StatelessWidget {
  const WInputPrefixIcon({super.key, required this.icon, this.withStar = true, this.withDvider = true});

  final String icon;
  final bool withStar;
  final bool withDvider;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          10.widthBox,
          if (withStar)
            Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: SvgPicture.asset(Assets.icons.requiredField.path, width: 10.w, height: 10.h),
            ),
          8.widthBox,
          SvgPicture.asset(icon),
          8.widthBox,
          if (withDvider) const VerticalDivider(color: Colors.grey, thickness: 1, width: 1, indent: 14, endIndent: 14),
          10.widthBox,
        ],
      ),
    );
  }
}
