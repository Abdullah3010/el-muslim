import 'package:flutter/material.dart';
import 'package:al_muslim/core/constants/cst_config_key.dart';
import 'package:al_muslim/core/constants/cst_fake_data.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Constants {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static CSTConfigKey get configKeys => CSTConfigKey();
  static CstFakeData get fakeData => CstFakeData();

  static bool get showTalker => false;

  static final Talker talker = TalkerFlutter.init(
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(enable: true, defaultTitle: 'ELMUSLIM LOGGER', enableColors: true),
    ),
  );

  static List<int> successStatusCodes = [200, 201, 202, 204];

  static int navbarHeight = 105;

  static String prayTimeApiKey = '3cbJ9hkDgWoIex0tIhfM0wrcE9sazUhCotASgShkJy4bAnVT';

  /// Notification id bases
  static const int prayNotificationBaseId = 4200;
  static const int werdNotificationBaseId = 1000;
}
