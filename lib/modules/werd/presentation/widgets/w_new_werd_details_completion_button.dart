import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WNewWerdDetailsCompletionButton extends StatelessWidget {
  const WNewWerdDetailsCompletionButton({super.key, required this.title, this.onPressed});

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 171.w,
          height: 53.h,
          decoration: BoxDecoration(
            color: context.theme.colorScheme.primaryColor,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Assets.icons.check.svg(), 8.widthBox, Text(title, style: context.textTheme.white16W500)],
            ),
          ),
        ),
      ),
    );
  }
}
