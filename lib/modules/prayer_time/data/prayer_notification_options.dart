class PrayerNotificationOption {
  const PrayerNotificationOption({required this.labelKey, required this.offsetMinutes});

  final String labelKey;
  final int offsetMinutes;
}

const List<PrayerNotificationOption> prayerNotificationOptions = [
  PrayerNotificationOption(labelKey: 'At prayer time', offsetMinutes: 0),
  PrayerNotificationOption(labelKey: 'Before 5 minutes', offsetMinutes: 5),
  PrayerNotificationOption(labelKey: 'Before 10 minutes', offsetMinutes: 10),
  PrayerNotificationOption(labelKey: 'Before 15 minutes', offsetMinutes: 15),
  PrayerNotificationOption(labelKey: 'Before 20 minutes', offsetMinutes: 20),
  PrayerNotificationOption(labelKey: 'After 25 minutes', offsetMinutes: -25),
  PrayerNotificationOption(labelKey: 'After 30 minutes', offsetMinutes: -30),
  PrayerNotificationOption(labelKey: 'After 35 minutes', offsetMinutes: -35),
];

const List<PrayerNotificationOption> preAdhanNotificationOptions = [
  PrayerNotificationOption(labelKey: 'No reminder', offsetMinutes: 0),
  PrayerNotificationOption(labelKey: 'Before 5 minutes', offsetMinutes: 5),
  PrayerNotificationOption(labelKey: 'Before 10 minutes', offsetMinutes: 10),
  PrayerNotificationOption(labelKey: 'Before 15 minutes', offsetMinutes: 15),
  PrayerNotificationOption(labelKey: 'Before 20 minutes', offsetMinutes: 20),
];
