import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';

class DSNotification {
  final BoxNotification boxNotification;

  DSNotification(this.boxNotification);

  Future<MLocalNotification> createUpdate(MLocalNotification notification) async {
    await boxNotification.box.put(notification.id, notification);
    return notification;
  }

  Future<MLocalNotification?> getById(int id) async {
    return boxNotification.box.get(id);
  }

  List<MLocalNotification> getAll() {
    return boxNotification.box.values.toList();
  }

  Future<MLocalNotification?> setEnabled(int id, bool isEnabled) async {
    final existing = await getById(id);
    if (existing == null) return null;

    final MLocalNotification updated = existing.copyWith(isEnabled: isEnabled);
    await createUpdate(updated);
    return updated;
  }

  Future<void> delete(int id) async {
    await boxNotification.box.delete(id);
  }

  Future<void> clear() async {
    await boxNotification.box.clear();
  }
}
