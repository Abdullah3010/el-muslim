import 'package:hive/hive.dart';

class HelperHive {
  static Future<Box<BoxType>> tryInitBox<BoxType>(String boxName) async {
    late Box<BoxType> box;
    try {
      box = await Hive.openBox<BoxType>(boxName);
    } catch (e) {
      await Hive.deleteBoxFromDisk(boxName);
      box = await Hive.openBox<BoxType>(boxName);
    }

    return box;
  }
}
