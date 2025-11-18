import 'package:al_muslim/modules/prayer_time/managers/mg_prayer_time.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/prayer_time_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerTimesListWidget extends StatelessWidget {
  const PrayerTimesListWidget({required this.entries, required this.highlightedPrayer, super.key});

  final List<PrayerTimeEntry> entries;
  final String highlightedPrayer;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children:
          entries.map((entry) => PrayerTimeCard(entry: entry, isHighlighted: highlightedPrayer == entry.name)).toList(),
    );
  }
}
