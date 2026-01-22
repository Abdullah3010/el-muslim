class MPrayerTime {
  const MPrayerTime({
    required this.times,
    required this.date,
    required this.qibla,
    required this.prohibitedTimes,
    required this.timezone,
  });

  final MPrayerTimes times;
  final MPrayerDate date;
  final MPrayerQibla qibla;
  final MPrayerProhibitedTimes prohibitedTimes;
  final MPrayerTimezone timezone;

  factory MPrayerTime.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final metaTimezone = meta['timezone']?.toString() ?? '';
    final timingSource = json['timings'] as Map<String, dynamic>? ?? json['times'] as Map<String, dynamic>? ?? {};
    return MPrayerTime(
      times: MPrayerTimes.fromJson(timingSource),
      date: MPrayerDate.fromJson(json['date'] as Map<String, dynamic>? ?? {}),
      qibla: MPrayerQibla.fromJson(json['qibla'] as Map<String, dynamic>? ?? {}),
      prohibitedTimes: MPrayerProhibitedTimes.fromJson(json['prohibited_times'] as Map<String, dynamic>? ?? {}),
      timezone:
          metaTimezone.isNotEmpty
              ? MPrayerTimezone.fromAladhan(metaTimezone)
              : MPrayerTimezone.fromJson(json['timezone'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class MPrayerTimes {
  const MPrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.firstThird,
    required this.lastThird,
    required this.raw,
  });

  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;
  final String firstThird;
  final String lastThird;
  final Map<String, String> raw;

  factory MPrayerTimes.fromJson(Map<String, dynamic> json) {
    final mapped = json.map((key, value) => MapEntry(key, _cleanTimeValue((value ?? '').toString())));
    return MPrayerTimes(
      fajr: mapped['Fajr'] ?? '',
      sunrise: mapped['Sunrise'] ?? '',
      dhuhr: mapped['Dhuhr'] ?? '',
      asr: mapped['Asr'] ?? '',
      sunset: mapped['Sunset'] ?? '',
      maghrib: mapped['Maghrib'] ?? '',
      isha: mapped['Isha'] ?? '',
      imsak: mapped['Imsak'] ?? '',
      midnight: mapped['Midnight'] ?? '',
      firstThird: mapped['Firstthird'] ?? '',
      lastThird: mapped['Lastthird'] ?? '',
      raw: mapped,
    );
  }

  static String _cleanTimeValue(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    return trimmed.split(' ').first;
  }
}

class MPrayerDate {
  const MPrayerDate({required this.readable, required this.timestamp, required this.hijri, required this.gregorian});

  final String readable;
  final String timestamp;
  final MPrayerDateHijri hijri;
  final MPrayerDateGregorian gregorian;

  factory MPrayerDate.fromJson(Map<String, dynamic> json) {
    return MPrayerDate(
      readable: json['readable'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      hijri: MPrayerDateHijri.fromJson(json['hijri'] as Map<String, dynamic>? ?? {}),
      gregorian: MPrayerDateGregorian.fromJson(json['gregorian'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class MPrayerDateHijri {
  const MPrayerDateHijri({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
    required this.holidays,
    required this.adjustedHolidays,
    required this.method,
    required this.shift,
  });

  final String date;
  final String format;
  final String day;
  final MPrayerDateWeekdayHijri weekday;
  final MPrayerDateMonthHijri month;
  final String year;
  final MPrayerDateDesignation designation;
  final List<String> holidays;
  final List<String> adjustedHolidays;
  final String method;
  final int shift;

  factory MPrayerDateHijri.fromJson(Map<String, dynamic> json) {
    return MPrayerDateHijri(
      date: json['date'] as String? ?? '',
      format: json['format'] as String? ?? '',
      day: json['day'] as String? ?? '',
      weekday: MPrayerDateWeekdayHijri.fromJson(json['weekday'] as Map<String, dynamic>? ?? {}),
      month: MPrayerDateMonthHijri.fromJson(json['month'] as Map<String, dynamic>? ?? {}),
      year: json['year'] as String? ?? '',
      designation: MPrayerDateDesignation.fromJson(json['designation'] as Map<String, dynamic>? ?? {}),
      holidays:
          (json['holidays'] as List<dynamic>? ?? [])
              .map((e) => e?.toString() ?? '')
              .where((value) => value.isNotEmpty)
              .toList(),
      adjustedHolidays:
          (json['adjustedHolidays'] as List<dynamic>? ?? [])
              .map((e) => e?.toString() ?? '')
              .where((value) => value.isNotEmpty)
              .toList(),
      method: json['method'] as String? ?? '',
      shift: json['shift'] as int? ?? 0,
    );
  }
}

class MPrayerDateGregorian {
  const MPrayerDateGregorian({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
    required this.designation,
  });

  final String date;
  final String format;
  final String day;
  final MPrayerDateWeekdayGregorian weekday;
  final MPrayerDateMonthGregorian month;
  final String year;
  final MPrayerDateDesignation designation;

  factory MPrayerDateGregorian.fromJson(Map<String, dynamic> json) {
    return MPrayerDateGregorian(
      date: json['date'] as String? ?? '',
      format: json['format'] as String? ?? '',
      day: json['day'] as String? ?? '',
      weekday: MPrayerDateWeekdayGregorian.fromJson(json['weekday'] as Map<String, dynamic>? ?? {}),
      month: MPrayerDateMonthGregorian.fromJson(json['month'] as Map<String, dynamic>? ?? {}),
      year: json['year'] as String? ?? '',
      designation: MPrayerDateDesignation.fromJson(json['designation'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class MPrayerDateWeekdayHijri {
  const MPrayerDateWeekdayHijri({required this.en, required this.ar});

  final String en;
  final String ar;

  factory MPrayerDateWeekdayHijri.fromJson(Map<String, dynamic> json) {
    return MPrayerDateWeekdayHijri(en: json['en'] as String? ?? '', ar: json['ar'] as String? ?? '');
  }
}

class MPrayerDateWeekdayGregorian {
  const MPrayerDateWeekdayGregorian({required this.en});

  final String en;

  factory MPrayerDateWeekdayGregorian.fromJson(Map<String, dynamic> json) {
    return MPrayerDateWeekdayGregorian(en: json['en'] as String? ?? '');
  }
}

class MPrayerDateMonthHijri {
  const MPrayerDateMonthHijri({required this.number, required this.en, required this.ar, required this.days});

  final int number;
  final String en;
  final String ar;
  final int days;

  factory MPrayerDateMonthHijri.fromJson(Map<String, dynamic> json) {
    return MPrayerDateMonthHijri(
      number: json['number'] as int? ?? 0,
      en: json['en'] as String? ?? '',
      ar: json['ar'] as String? ?? '',
      days: json['days'] as int? ?? 0,
    );
  }
}

class MPrayerDateMonthGregorian {
  const MPrayerDateMonthGregorian({required this.number, required this.en});

  final int number;
  final String en;

  factory MPrayerDateMonthGregorian.fromJson(Map<String, dynamic> json) {
    return MPrayerDateMonthGregorian(number: json['number'] as int? ?? 0, en: json['en'] as String? ?? '');
  }
}

class MPrayerDateDesignation {
  const MPrayerDateDesignation({required this.abbreviated, required this.expanded});

  final String abbreviated;
  final String expanded;

  factory MPrayerDateDesignation.fromJson(Map<String, dynamic> json) {
    return MPrayerDateDesignation(
      abbreviated: json['abbreviated'] as String? ?? '',
      expanded: json['expanded'] as String? ?? '',
    );
  }
}

class MPrayerQibla {
  const MPrayerQibla({required this.direction, required this.distance});

  final MPrayerQiblaDirection direction;
  final MPrayerQiblaDistance distance;

  factory MPrayerQibla.fromJson(Map<String, dynamic> json) {
    return MPrayerQibla(
      direction: MPrayerQiblaDirection.fromJson(json['direction'] as Map<String, dynamic>? ?? {}),
      distance: MPrayerQiblaDistance.fromJson(json['distance'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class MPrayerQiblaDirection {
  const MPrayerQiblaDirection({required this.degrees, required this.from, required this.clockwise});

  final double degrees;
  final String from;
  final bool clockwise;

  factory MPrayerQiblaDirection.fromJson(Map<String, dynamic> json) {
    return MPrayerQiblaDirection(
      degrees: (json['degrees'] as num?)?.toDouble() ?? 0,
      from: json['from'] as String? ?? '',
      clockwise: json['clockwise'] as bool? ?? false,
    );
  }
}

class MPrayerQiblaDistance {
  const MPrayerQiblaDistance({required this.value, required this.unit});

  final double value;
  final String unit;

  factory MPrayerQiblaDistance.fromJson(Map<String, dynamic> json) {
    return MPrayerQiblaDistance(value: (json['value'] as num?)?.toDouble() ?? 0, unit: json['unit'] as String? ?? '');
  }
}

class MPrayerProhibitedTimes {
  const MPrayerProhibitedTimes({required this.sunrise, required this.noon, required this.sunset});

  final MPrayerProhibitedTimeWindow sunrise;
  final MPrayerProhibitedTimeWindow noon;
  final MPrayerProhibitedTimeWindow sunset;

  factory MPrayerProhibitedTimes.fromJson(Map<String, dynamic> json) {
    return MPrayerProhibitedTimes(
      sunrise: MPrayerProhibitedTimeWindow.fromJson(json['sunrise'] as Map<String, dynamic>? ?? {}),
      noon: MPrayerProhibitedTimeWindow.fromJson(json['noon'] as Map<String, dynamic>? ?? {}),
      sunset: MPrayerProhibitedTimeWindow.fromJson(json['sunset'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class MPrayerProhibitedTimeWindow {
  const MPrayerProhibitedTimeWindow({required this.start, required this.end});

  final String start;
  final String end;

  factory MPrayerProhibitedTimeWindow.fromJson(Map<String, dynamic> json) {
    return MPrayerProhibitedTimeWindow(start: json['start'] as String? ?? '', end: json['end'] as String? ?? '');
  }
}

class MPrayerTimezone {
  const MPrayerTimezone({required this.name, required this.utcOffset, required this.abbreviation});

  final String name;
  final String utcOffset;
  final String abbreviation;

  factory MPrayerTimezone.fromAladhan(String timezone) {
    return MPrayerTimezone(name: timezone, utcOffset: '', abbreviation: '');
  }

  factory MPrayerTimezone.fromJson(Map<String, dynamic> json) {
    return MPrayerTimezone(
      name: json['name'] as String? ?? '',
      utcOffset: json['utc_offset'] as String? ?? '',
      abbreviation: json['abbreviation'] as String? ?? '',
    );
  }
}
