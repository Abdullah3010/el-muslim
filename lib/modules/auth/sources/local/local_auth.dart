import 'package:al_muslim/modules/auth/data/models/m_user.dart';
import 'package:al_muslim/modules/auth/sources/local/box_user.dart';
import 'package:hive_ce/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class LocalAuth {
  BoxUser hBox = BoxUser();

  MUser? get() => hBox.box.get(0);

  Future<void> createUpdate(MUser data) async {
    await hBox.box.put(0, data);
  }

  Future<bool> clear() async {
    await hBox.box.clear();
    return true;
  }

  ValueListenable<Box<MUser>> listenable() {
    return hBox.box.listenable();
  }
}
