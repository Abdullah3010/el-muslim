class RoutesNames {
  static String get baseUrl => '/';

  static CoreRoutes core = CoreRoutes();
  static MoreRoutes more = MoreRoutes();
  static PrayerTimeRoutes prayTime = PrayerTimeRoutes();
  static IndexRoutes index = IndexRoutes();
  static AzkarRoutes azkar = AzkarRoutes();
  static WerdRoutes werd = WerdRoutes();
  static QiblaRoutes qibla = QiblaRoutes();
  static QuranRoutes quran = QuranRoutes();
}

class CoreRoutes {
  static String get baseUrl => RoutesNames.baseUrl;

  String get splash => baseUrl;

  String get logger => '${baseUrl}logger';
}

class MoreRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}more/';

  String get moreMain => baseUrl;
}

class PrayerTimeRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}pray_time/';

  String get prayTimeMain => baseUrl;
  String get prayTimeSettings => '${baseUrl}settings';
  String get adhanNotifications => '${baseUrl}adhan_notifications';
  String get adhanSettings => '${baseUrl}adhan_settings';
  String get locationSelection => '${baseUrl}location_selection';
}

class IndexRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}index/';

  String get indexMain => baseUrl;
}

class AzkarRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}azkar/';

  String get azkarMain => baseUrl;
  String get zekrbase => '${baseUrl}zekr/:categoryId';
  String zekr(int categoryId) => '${baseUrl}zekr/$categoryId';
}

class WerdRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}werd/';

  String get werdMain => baseUrl;
  String get werdDetails => '${baseUrl}details';
  String get previousWerd => '${baseUrl}previous';
  String get nextWerd => '${baseUrl}next';
  String get dailyAwradAlarm => '${baseUrl}daily_awrad_alarm';
}

class QiblaRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}qibla/';

  String get qiblaMain => baseUrl;
}

class QuranRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}quran/';

  String get quranMain => baseUrl;
}
