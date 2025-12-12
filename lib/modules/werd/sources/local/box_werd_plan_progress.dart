import 'package:al_muslim/core/utils/hive_box_base.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_day.dart';
import 'package:hive_ce/hive.dart';

/// Stores plan progress keyed by plan id. Values are persisted as List<MWerdDay>.
class BoxWerdPlanProgress extends HiveBoxBase<dynamic> {
  BoxWerdPlanProgress() : super('werd_plan_progress_box');

  @override
  Future<bool> init() async {
    if (!Hive.isAdapterRegistered(MWerdDayAdapter().typeId)) {
      Hive.registerAdapter(MWerdDayAdapter());
    }
    return super.init();
  }
}
