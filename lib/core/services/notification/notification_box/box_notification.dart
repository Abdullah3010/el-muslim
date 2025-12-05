import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/utils/helper_hive.dart';
import 'package:hive/hive.dart';

import 'package:flutter/cupertino.dart';

class BoxNotification {
  late Box<MLocalNotification> _box;

  final String _boxName = 'notification_box';

  /// [box] is the box for the notifications.
  Box<MLocalNotification> get box => _box;

  /// [init] initializes the box for the notifications.
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(MLocalNotificationAdapter().typeId)) {
      Hive.registerAdapter(MLocalNotificationAdapter());
    }
    _box = await HelperHive.tryInitBox<MLocalNotification>(_boxName);
    debugPrint('Hive.Box.open: $_boxName -- Length: ${_box.length}');
  }
}
