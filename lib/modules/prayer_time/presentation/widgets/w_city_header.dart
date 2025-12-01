import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WCityHeader extends StatelessWidget {
  const WCityHeader({required this.cityName, this.subtitle, this.onSettings, super.key});

  final String cityName;
  final String? subtitle;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFD6A400);
    return Row(
      children: [
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: accentColor.withValues(alpha: 0.15)),
          child: const Icon(Icons.place, color: accentColor, size: 26),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle ?? 'Prayer Times',
              style: TextStyle(fontSize: 14.sp, color: Colors.black54, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6.h),
            Text(cityName, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: Colors.black)),
          ],
        ),
        const Spacer(),
        if (onSettings != null) IconButton(onPressed: onSettings, icon: const Icon(Icons.settings)),
      ],
    );
  }
}
