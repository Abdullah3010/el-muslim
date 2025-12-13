import 'package:al_muslim/core/assets/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemes {
  static ThemeData get light => ThemeData(
    fontFamily: FontFamily.changa,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,

    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xFFF2AF29),
      circularTrackColor: Color(0xFFE0E0E0),
      linearTrackColor: Color(0xFFE0E0E0),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(const Color(0xFFD8B74E)),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        const Color primary = Color(0xFFD8B74E);
        if (states.contains(WidgetState.selected)) {
          return primary.withValues(alpha: 0.5);
        }
        return primary.withValues(alpha: 0.2);
      }),
      overlayColor: WidgetStateProperty.resolveWith<Color>((states) {
        const Color primary = Color(0xFFD8B74E);
        return states.contains(WidgetState.selected) ? primary.withValues(alpha: 0.25) : primary.withValues(alpha: 0.2);
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Color(0xFFfdfbf6)),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      hintStyle: TextStyle(color: const Color(0xFF000000), fontSize: 18.sp, fontWeight: FontWeight.w400, height: 1.1),
      errorStyle: TextStyle(color: const Color(0xFFFF0000), fontSize: 18.sp, fontWeight: FontWeight.w700, height: 1.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: const Color(0xFFF2AF29), width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: const Color(0xFFF2AF29), width: 1.w),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: const Color(0xFFF2AF29), width: 1.w),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: const Color(0xFFABABAB), width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: const Color(0xFFFF3E3E), width: 1.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: const Color(0xFFFF3E3E), width: 1.w),
      ),
    ),
  );
}
