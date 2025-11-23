import 'package:al_muslim/modules/prayer_time/managers/mg_prayer_time.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/w_prayer_time_card.dart';
import 'package:flutter/material.dart';

class WPrayerTimesList extends StatelessWidget {
  const WPrayerTimesList({required this.entries, required this.highlightedPrayer, super.key});

  final List<PrayerTimeEntry> entries;
  final String highlightedPrayer;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children:
          entries
              .map((entry) => WPrayerTimeCard(entry: entry, isHighlighted: highlightedPrayer == entry.name))
              .toList(),
    );
  }
}
