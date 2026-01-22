/// Qatar-specific prayer time adjustments in minutes
/// Fajr: +1, Dhuhr: +1, Asr: +2, Maghrib: +2, Isha: +2
Map<String, int> getQatarPrayerAdjustments() {
  return {'Fajr': 1, 'Dhuhr': 1, 'Asr': 2, 'Maghrib': 2, 'Isha': 2};
}

/// Returns true if the country code is Qatar (QA)
bool isQatarCountryCode(String? code) {
  if (code == null || code.trim().isEmpty) return false;
  return code.trim().toUpperCase() == 'QA';
}

/// Adjusts a time string (HH:mm) by adding the specified minutes
String adjustTimeByMinutes(String time, int minutes) {
  if (time.isEmpty || minutes == 0) return time;

  final parts = time.split(':');
  if (parts.length != 2) return time;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return time;

  final totalMinutes = hour * 60 + minute + minutes;
  final newHour = (totalMinutes ~/ 60) % 24;
  final newMinute = totalMinutes % 60;

  return '${newHour.toString().padLeft(2, '0')}:${newMinute.toString().padLeft(2, '0')}';
}

int getPrayerMethodByCountryCode(String? code) {
  if (code == null || code.trim().isEmpty) {
    return 3;
  }

  switch (code.trim().toUpperCase()) {
    case 'EG':
      return 5;
    case 'SA':
      return 4;
    case 'AE':
      return 16;
    case 'QA':
      return 10;
    case 'KW':
      return 9;
    case 'BH':
    case 'OM':
      return 8;
    case 'TN':
      return 18;
    case 'DZ':
      return 19;
    case 'MA':
      return 21;
    case 'JO':
      return 23;
    case 'TR':
      return 13;
    case 'RU':
      return 14;
    case 'IR':
      return 7;
    case 'PK':
    case 'IN':
    case 'BD':
      return 1;
    case 'SG':
      return 11;
    case 'MY':
      return 17;
    case 'ID':
      return 20;
    case 'FR':
      return 12;
    case 'PT':
      return 22;
    default:
      return 3;
  }
}
