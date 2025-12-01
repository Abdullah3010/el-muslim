import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../managers/mg_prayer_time.dart';

class WPrayerTimeCard extends StatefulWidget {
  const WPrayerTimeCard({required this.entry, this.isHighlighted = false, super.key});

  final PrayerTimeEntry entry;
  final bool isHighlighted;

  @override
  State<WPrayerTimeCard> createState() => _WPrayerTimeCardState();
}

class _WPrayerTimeCardState extends State<WPrayerTimeCard> {
  bool isMuted = false;

  String get _formattedTime {
    final period = widget.entry.dateTime.hour < 12 ? 'ص' : 'م';
    final formatted = DateFormat('hh:mm').format(widget.entry.dateTime);
    return '${formatted.translateNumbers()} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: widget.isHighlighted ? context.theme.colorScheme.secondaryColor : Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(child: Text(widget.entry.name.translated, style: context.theme.textTheme.primary16W500)),
          Text(_formattedTime, style: context.theme.textTheme.primary16W500),
          38.horizontalSpace,
          InkWell(
            onTap: () {
              setState(() {
                isMuted = !isMuted;
              });
            },
            child: isMuted ? Assets.icons.mute.svg() : Assets.icons.unmute.svg(),
          ),
        ],
      ),
    );
  }
}
