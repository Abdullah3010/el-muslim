import 'package:al_muslim/core/utils/hive_box_base.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_day.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:hive_ce/hive.dart';

class BoxWerdPlanOption extends HiveBoxBase<MWerdPlanOption> {
  BoxWerdPlanOption() : super('werd_plan_box', MWerdPlanOptionAdapter());

  @override
  Future<bool> init() async {
    if (!Hive.isAdapterRegistered(MWerdDayAdapter().typeId)) {
      Hive.registerAdapter(MWerdDayAdapter());
    }
    if (!Hive.isAdapterRegistered(MLocalNotificationAdapter().typeId)) {
      Hive.registerAdapter(MLocalNotificationAdapter());
    }
    return super.init();
  }
}
