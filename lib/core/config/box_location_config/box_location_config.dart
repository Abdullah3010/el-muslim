import 'package:al_muslim/core/config/box_location_config/m_location_config.dart';
import 'package:al_muslim/core/utils/hive_box_base.dart';

class BoxLocationConfig extends HiveBoxBase<MLocationConfig> {
  BoxLocationConfig() : super('location_config', MLocationConfigAdapter());
}
