import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WOtherAzkarSearchField extends StatelessWidget {
  const WOtherAzkarSearchField({super.key, required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        cursorColor: context.theme.colorScheme.primaryColor2,
        cursorHeight: 20.h,
        decoration: InputDecoration(
          hintText: 'azkar_search_other'.translated,
          hintStyle: context.theme.textTheme.primary16W500.copyWith(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: context.theme.colorScheme.primaryColor2),
          filled: true,
          fillColor: context.theme.colorScheme.white,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: context.theme.colorScheme.lightGray.withValues(alpha: 0.4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: context.theme.colorScheme.lightGray.withValues(alpha: 0.4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: context.theme.colorScheme.primaryColor2),
          ),
        ),
      ),
    );
  }
}
