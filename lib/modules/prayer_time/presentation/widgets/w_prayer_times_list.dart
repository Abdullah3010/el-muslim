import 'dart:async';

import 'package:al_muslim/modules/prayer_time/managers/mg_prayer_time.dart';
import 'package:al_muslim/modules/prayer_time/data/prayer_notification_options.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/w_adhan_reminder_picker_bottom_sheet.dart';
import 'package:al_muslim/modules/prayer_time/presentation/widgets/w_prayer_time_card.dart';
import 'package:flutter/material.dart';

class WPrayerTimesList extends StatelessWidget {
  const WPrayerTimesList({
    required this.entries,
    required this.highlightedPrayer,
    required this.manager,
    super.key,
  });

  final List<PrayerTimeEntry> entries;
  final String highlightedPrayer;
  final MgPrayerTime manager;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children:
          entries.map((entry) {
            final isMuted = manager.isPrayerMuted(entry.name);
            final reminderLabelKey = manager.preAdhanLabelKeyForPrayer(entry.name);
            Future<void> handleSelectReminder() async {
              final selected = await WAdhanReminderPickerBottomSheet.show(
                context,
                initialIndex: manager.preAdhanIndexForPrayer(entry.name),
                options: preAdhanNotificationOptions,
              );
              if (selected != null) {
                await manager.updatePreAdhanReminder(entry.name, selected);
              }
            }

            return WPrayerTimeCard(
              entry: entry,
              isHighlighted: highlightedPrayer == entry.name,
              isMuted: isMuted,
              reminderLabelKey: reminderLabelKey,
              onToggleMute: () {
                manager.setPrayerNotificationEnabled(entry.name, isMuted);
              },
              onSelectReminder: () => unawaited(handleSelectReminder()),
            );
          }).toList(),
    );
  }
}
