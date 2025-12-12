import 'package:al_muslim/core/services/notification/notification_box/box_notification.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_day.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/sources/local/box_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/sources/local/box_werd_plan_progress.dart';

class WerdLocalDataSource {
  WerdLocalDataSource({
    BoxWerdPlanOption? box,
    BoxWerdPlanProgress? progressBox,
    BoxNotification? notificationBox,
  })  : _box = box ?? BoxWerdPlanOption(),
        _progressBox = progressBox ?? BoxWerdPlanProgress(),
        _notificationBox = notificationBox ?? BoxNotification();

  static const String _selectedPlanKey = 'selected_plan';

  final BoxWerdPlanOption _box;
  final BoxWerdPlanProgress _progressBox;
  final BoxNotification _notificationBox;

  Future<void> init() async {
    await Future.wait([_box.init(), _progressBox.init(), _notificationBox.init()]);
  }

  Future<MWerdPlanOption?> getSelectedPlan() async {
    await init();
    return _box.box.get(_selectedPlanKey);
  }

  Future<void> saveSelectedPlan(MWerdPlanOption option) async {
    await init();
    await _box.box.put(_selectedPlanKey, option);
  }

  Future<void> clearSelectedPlan() async {
    await init();
    await _box.box.delete(_selectedPlanKey);
  }

  Future<List<MWerdDay>> getPlanDays(int planId) async {
    await init();
    final savedDays = _progressBox.box.get(planId.toString());
    if (savedDays == null) return const [];
    if (savedDays is Iterable) {
      return List<MWerdDay>.from(savedDays.cast<MWerdDay>());
    }
    return const [];
  }

  Future<void> savePlanDays(int planId, List<MWerdDay> days) async {
    await init();
    await _progressBox.box.put(planId.toString(), days);
  }

  Future<void> clearPlanDays(int planId) async {
    await init();
    await _progressBox.box.delete(planId.toString());
  }

  Future<void> saveNotification(MLocalNotification notification) async {
    await init();
    await _notificationBox.box.put(notification.id, notification);
  }

  Future<void> saveNotifications(List<MLocalNotification> notifications) async {
    await init();
    final box = _notificationBox.box;
    for (final notification in notifications) {
      await box.put(notification.id, notification);
    }
  }

  Future<void> deleteNotification(int notificationId) async {
    await init();
    await _notificationBox.box.delete(notificationId);
  }
}
