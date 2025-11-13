import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:al_muslim/core/constants/cst_config_key.dart';
import 'package:al_muslim/core/constants/cst_fake_data.dart';
import 'package:al_muslim/core/utils/enums.dart';
import 'package:talker_flutter/talker_flutter.dart';

class Constants {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static APIState get apiState => APIState.dev;

  static CSTConfigKey get configKeys => CSTConfigKey();
  static CstFakeData get fakeData => CstFakeData();

  static bool get showTalker => false;

  static final Talker talker = TalkerFlutter.init(
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(
        enable: true,
        defaultTitle: 'BNB',
        // enableColors: true,
      ),
    ),
  );

  static String get countryCode => '+963';

  static List<int> successStatusCodes = [200, 201, 202, 204];

  static int navbarHeight = 85;

  /// Cached categories for search/filter dropdowns
  static List<String> filterCategoryNames = const ['All'];
  static Map<String, String> filterCategoryNameToId = const {};

  static bool authenticatedError = false;

  static bool isRefreshingToken = false;
  static Completer<bool>? refreshCompleter;
  static final List<PendingRequest> pendingRequests = <PendingRequest>[];
}

class PendingRequest {
  final RequestOptions requestOptions;
  final RequestInterceptorHandler handler;

  PendingRequest({required this.requestOptions, required this.handler});
}
