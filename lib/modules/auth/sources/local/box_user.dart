import 'package:al_muslim/core/utils/hive_box_base.dart';
import 'package:al_muslim/modules/auth/data/models/m_user.dart';

class BoxUser extends HiveBoxBase<MUser> {
  BoxUser() : super('users', MUserAdapter());
}
