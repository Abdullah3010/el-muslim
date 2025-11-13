import 'package:al_muslim/core/assets/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension TextStyleExtension on TextTheme {
  /// [darkGrey]
  TextStyle get darkGrey14w500 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: const Color(0xFF323844), height: 1.8);

  TextStyle get darkGrey18w500 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp, color: const Color(0xFF323844), height: 1.8);

  TextStyle get darkGrey14w700 =>
      TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: const Color(0xFF323844), height: 1.8);
  TextStyle get darkGrey16w500 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: const Color(0xFF323844));
  TextStyle get darkGrey16w700 =>
      TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp, color: const Color(0xFF323844));

  TextStyle get darkGrey12w500 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp, color: const Color(0xFF323844));

  /// [grey]
  TextStyle get grey12w600 => TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp, color: const Color(0xFF7E8190));
  TextStyle get grey12w400 => TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: const Color(0xFF7E8190));
  TextStyle get grey14w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: const Color(0xFF7E8190));
  TextStyle get grey14w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: const Color(0xFF7E8190));
  TextStyle get grey10w400 => TextStyle(fontWeight: FontWeight.w400, fontSize: 10.sp, color: const Color(0xFF7E8190));

  /// [LightGrey]
  TextStyle get lightGrey12w500 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp, color: const Color(0xFFABABAB));
  TextStyle get lightGrey12w400 =>
      TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: const Color(0xFFABABAB));
  TextStyle get lightGrey18w500 =>
      TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp, color: const Color(0xFFABABAB));

  /// [red]
  TextStyle get red18w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp, color: const Color(0xFFFF0000));

  /// [Blue]
  TextStyle get blue18w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue22w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 22.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue24w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 24.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue16w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue16w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: const Color(0xFF1C7C8B));

  TextStyle get blue14w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue14w600 => TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue20w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp, color: const Color(0xFF1C7C8B));

  TextStyle get blue16w400 => TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue12w400 => TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue12w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue18w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp, color: const Color(0xFF1C7C8B));
  TextStyle get blue12w600 => TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp, color: const Color(0xFF1C7C8B));

  TextStyle get blue14w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: const Color(0xFF1C7C8B));

  TextStyle get blue20w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp, color: const Color(0xFF1C7C8B));

  /// [Mint]
  TextStyle get mint14w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: const Color(0xFF35CDE2));

  TextStyle get mint12w800 => TextStyle(fontWeight: FontWeight.w800, fontSize: 12.sp, color: const Color(0xFF35CDE2));
  TextStyle get mint24w800 => TextStyle(fontWeight: FontWeight.w800, fontSize: 24.sp, color: const Color(0xFF35CDE2));
  TextStyle get mint12w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp, color: const Color(0xFF35CDE2));
  TextStyle get mint14w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: const Color(0xFF35CDE2));
  TextStyle get mint18w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp, color: const Color(0xFF35CDE2));

  TextStyle get mint20w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp, color: const Color(0xFF35CDE2));

  /// [White]
  TextStyle get white25w800 => TextStyle(fontWeight: FontWeight.w800, fontSize: 24.sp, color: const Color(0xffffffff));

  TextStyle get white14w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: const Color(0xffffffff));

  TextStyle get white10w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 10.sp, color: const Color(0xffffffff));
  TextStyle get white13w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp, color: const Color(0xffffffff));

  TextStyle get white12w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 12.sp, color: const Color(0xffffffff));

  TextStyle get white18w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp, color: const Color(0xffffffff));

  TextStyle get white18w400 => TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp, color: const Color(0xffffffff));

  TextStyle get white14w800 => TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp, color: const Color(0xffffffff));

  TextStyle get white14w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: const Color(0xffffffff));

  TextStyle get white16w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp, color: const Color(0xffffffff));
  TextStyle get white16w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp, color: const Color(0xffffffff));
  TextStyle get white12w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp, color: const Color(0xffffffff));
  TextStyle get white12w600 => TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp, color: const Color(0xffffffff));
  TextStyle get white16w400 => TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp, color: const Color(0xffffffff));
  TextStyle get white14w400 => TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp, color: const Color(0xffffffff));
  TextStyle get white14w600 => TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xffffffff));

  TextStyle get white28w800 => TextStyle(fontWeight: FontWeight.w800, fontSize: 28.sp, color: const Color(0xffffffff));

  /// [black]

  /// ==================>

  TextStyle get black24w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 24.sp, color: const Color(0xff000000));
  TextStyle get black15w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp, color: const Color(0xff000000));
  TextStyle get black16w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp, color: const Color(0xff000000));
  TextStyle get black18w00 => TextStyle(fontWeight: FontWeight.w700, fontSize: 18.sp, color: const Color(0xff000000));
  TextStyle get black16w600 => TextStyle(fontWeight: FontWeight.w700, fontSize: 16.sp, color: const Color(0xff000000));
  TextStyle get black12w400 => TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: const Color(0xff000000));
  TextStyle get black12w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 12.sp, color: const Color(0xff000000));
  TextStyle get black14w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp, color: const Color(0xff000000));
  TextStyle get black20w800 => TextStyle(fontWeight: FontWeight.w800, fontSize: 20.sp, color: const Color(0xff000000));
  TextStyle get black22w700 => TextStyle(fontWeight: FontWeight.w700, fontSize: 22.sp, color: const Color(0xff000000));
  TextStyle get black12w600 => TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp, color: const Color(0xff000000));
  TextStyle get black14w600 => TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp, color: const Color(0xff000000));
  TextStyle get black14w500 => TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp, color: const Color(0xff000000));

  /// [button]
  TextStyle get button => TextStyle(fontWeight: FontWeight.w400, fontSize: 16.sp, color: const Color(0xffffffff));

  /// ==================>>>>>
  /// [Arial Font Family]
  /// [black]
  TextStyle get black24w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );
  TextStyle get black24w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 24.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );

  TextStyle get black12w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );

  TextStyle get black14w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );

  TextStyle get black16w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );

  TextStyle get black14w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );

  TextStyle get black16w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );

  TextStyle get black18w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );

  TextStyle get black20w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );

  TextStyle get black18w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    color: const Color(0xff000000),
    fontFamily: FontFamily.arial,
  );

  /// [White]
  TextStyle get white12w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: const Color(0xffffffff),
    fontFamily: FontFamily.arial,
  );
  TextStyle get white12w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    color: const Color(0xffffffff),
    fontFamily: FontFamily.arial,
  );
  TextStyle get white16w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: const Color(0xffffffff),
    fontFamily: FontFamily.arial,
  );
  TextStyle get white18w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    color: const Color(0xffffffff),
    fontFamily: FontFamily.arial,
  );
  TextStyle get white18w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: const Color(0xffffffff),
    fontFamily: FontFamily.arial,
  );

  /// [Blue]
  TextStyle get grey18w400Arial =>
      TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp, color: const Color(0xFF7E8190));

  TextStyle get grey12w400Arial =>
      TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: const Color(0xFF7E8190));

  /// [Blue]
  TextStyle get blue18w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    color: const Color(0xFF168FD0),
    fontFamily: FontFamily.arial,
  );
  TextStyle get blue12w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    color: const Color(0xFF168FD0),
    fontFamily: FontFamily.arial,
  );

  /// [Orange]
  TextStyle get orange24w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    color: const Color(0xFFF2AF29),
    fontFamily: FontFamily.arial,
  );

  TextStyle get orange20w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
    color: const Color(0xFFF2AF29),
    fontFamily: FontFamily.arial,
  );

  TextStyle get orange18w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    color: const Color(0xFFF2AF29),
    fontFamily: FontFamily.arial,
  );

  TextStyle get orange16w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
    color: const Color(0xFFF2AF29),
    fontFamily: FontFamily.arial,
  );

  TextStyle get orange14w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    color: const Color(0xFFF2AF29),
    fontFamily: FontFamily.arial,
  );
  TextStyle get orange18w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: const Color(0xFFF2AF29),
    fontFamily: FontFamily.arial,
  );

  TextStyle get orange12w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    color: const Color(0xFFF2AF29),
    fontFamily: FontFamily.arial,
  );

  /// [Green]
  TextStyle get green12w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 12.sp,
    color: const Color(0xFF16D09A),
    fontFamily: FontFamily.arial,
  );
  TextStyle get green18w700Arial => TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18.sp,
    color: const Color(0xFF16D09A),
    fontFamily: FontFamily.arial,
  );
  TextStyle get green18w400Arial => TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
    color: const Color(0xFF16D09A),
    fontFamily: FontFamily.arial,
  );
}
