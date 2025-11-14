class RoutesNames {
  static String get baseUrl => '/';

  static CoreRoutes core = CoreRoutes();
  static MoreRoutes more = MoreRoutes();
  static PrayerTimeRoutes prayTime = PrayerTimeRoutes();
  static IndexRoutes index = IndexRoutes();
  static AzkarRoutes azkar = AzkarRoutes();
  static WerdRoutes werd = WerdRoutes();
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
}

class IndexRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}index/';

  String get indexMain => baseUrl;
}

class AzkarRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}azkar/';

  String get azkarMain => baseUrl;
}

class WerdRoutes {
  static String get baseUrl => '${RoutesNames.baseUrl}werd/';

  String get werdMain => baseUrl;
}
