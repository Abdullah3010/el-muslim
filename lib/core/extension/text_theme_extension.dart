import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension TextStyleExtension on TextTheme {
  /// [Button]
  TextStyle get button =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: const Color(0xFF323844), height: 1.8);

  /// [primary]
  TextStyle get primary16W500 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: const Color(0xFFD8B74E));

  TextStyle get primary20W500 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp, color: const Color(0xFFD8B74E));

  /// [darkGrey]
  TextStyle get darkGrey14w500 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: const Color(0xFF323844), height: 1.8);
}
