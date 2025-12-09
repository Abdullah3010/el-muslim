import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/utils/hive_box_base.dart';

class BoxNotification extends HiveBoxBase<MLocalNotification> {
  BoxNotification() : super('notification_box', MLocalNotificationAdapter());
}
