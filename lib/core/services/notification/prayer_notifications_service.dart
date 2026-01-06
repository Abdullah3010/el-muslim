import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class PrayerNotificationsService {
  static const String assetPath = 'assets/json/notifictaions/pray_notifications.json';

  Map<String, PrayerNotificationTemplate>? _cache;

  Future<PrayerNotificationTemplate?> templateForPrayer(String prayerName) async {
    final templates = await _loadTemplates();
    return templates[prayerName.toLowerCase()];
  }

  Future<Map<String, PrayerNotificationTemplate>> _loadTemplates() async {
    if (_cache != null) return _cache!;
    final jsonString = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map) {
      _cache = <String, PrayerNotificationTemplate>{};
      return _cache!;
    }

    final defaultLocale = decoded['default_locale']?.toString() ?? 'en';
    final rawNotifications = decoded['notifications'];
    if (rawNotifications is! List) {
      _cache = <String, PrayerNotificationTemplate>{};
      return _cache!;
    }

    final Map<String, PrayerNotificationTemplate> templates = {};
    for (final raw in rawNotifications) {
      if (raw is! Map) continue;
      final map = raw.cast<String, dynamic>();
      final schedule = map['schedule'] is Map ? (map['schedule'] as Map).cast<String, dynamic>() : <String, dynamic>{};
      final scheduleType = schedule['type']?.toString().toLowerCase() ?? '';
      if (scheduleType != 'prayer') continue;
      final prayer = schedule['prayer']?.toString().toLowerCase() ?? '';
      if (prayer.isEmpty) continue;

      final content = map['content'] is Map ? (map['content'] as Map).cast<String, dynamic>() : <String, dynamic>{};
      final title = _localizedValue(content['title'], defaultLocale);
      final body = _localizedValue(content['body'], defaultLocale);
      final enabled = map['enabled'] is bool ? map['enabled'] as bool : true;
      final rawPayload = map['payload'];
      final resolvedPayload = _resolvedPayload(rawPayload);

      templates[prayer] = PrayerNotificationTemplate(
        prayer: prayer,
        title: title,
        body: body,
        payload: resolvedPayload.payload,
        deepLink: resolvedPayload.deepLink,
        isEnabled: enabled,
      );
    }

    _cache = templates;
    return templates;
  }

  String _localizedValue(dynamic raw, String defaultLocale) {
    if (raw is Map) {
      String resolvedLocale;
      try {
        resolvedLocale = LocalizeAndTranslate.getLanguageCode();
      } catch (_) {
        resolvedLocale = defaultLocale;
      }
      final current = raw[resolvedLocale]?.toString();
      if (current != null && current.isNotEmpty) return current;
      final fallback = raw[defaultLocale]?.toString();
      if (fallback != null && fallback.isNotEmpty) return fallback;
      for (final value in raw.values) {
        final resolved = value?.toString() ?? '';
        if (resolved.isNotEmpty) return resolved;
      }
    }
    return raw?.toString() ?? '';
  }

  _ResolvedPayload _resolvedPayload(dynamic rawPayload) {
    Map<String, dynamic> payload = <String, dynamic>{};
    String? deepLink;
    if (rawPayload is Map) {
      final mutable = rawPayload.cast<String, dynamic>();
      final params = mutable.remove('params');
      final routeValue = mutable.remove('route') ?? mutable.remove('deepLink') ?? mutable.remove('deeplink');
      payload = Map<String, dynamic>.from(mutable);
      if (params is Map) {
        payload.addAll(params.cast<String, dynamic>());
      }
      deepLink = _resolveDeepLink(routeValue?.toString());
    }
    return _ResolvedPayload(payload: payload, deepLink: deepLink);
  }

  String? _resolveDeepLink(String? route) {
    if (route == null || route.isEmpty) return null;
    return route;
  }
}

class PrayerNotificationTemplate {
  const PrayerNotificationTemplate({
    required this.prayer,
    required this.title,
    required this.body,
    required this.payload,
    required this.isEnabled,
    this.deepLink,
  });

  final String prayer;
  final String title;
  final String body;
  final Map<String, dynamic> payload;
  final bool isEnabled;
  final String? deepLink;
}

class _ResolvedPayload {
  const _ResolvedPayload({required this.payload, this.deepLink});

  final Map<String, dynamic> payload;
  final String? deepLink;
}
