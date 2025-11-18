import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../managers/mg_prayer_time.dart';

class PrayerTimeCard extends StatelessWidget {
  const PrayerTimeCard({required this.entry, this.isHighlighted = false, super.key});

  final PrayerTimeEntry entry;
  final bool isHighlighted;

  String get _formattedTime {
    final period = entry.dateTime.hour < 12 ? 'ص' : 'م';
    final formatted = DateFormat('hh:mm').format(entry.dateTime);
    return '$formatted $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
      decoration: BoxDecoration(color: isHighlighted ? context.theme.colorScheme.secondaryColor : Colors.transparent),
      child: Row(
        children: [
          Expanded(child: Text(entry.name.translated, style: context.theme.textTheme.primary16W500)),
          Text(_formattedTime, style: context.theme.textTheme.primary16W500),
          38.horizontalSpace,
          Assets.icons.mute.svg(),
        ],
      ),
    );
  }
}
