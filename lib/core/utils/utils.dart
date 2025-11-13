import 'package:flutter/services.dart';
import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static void changeOrientationLandScape() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  static void changeOrientationPortrait() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  static Future<void> initDeviceData(TargetPlatform platform) async {
    String? deviceId = DSAppConfig.getConfigValue(Constants.configKeys.deviceId);
    String? deviceType = DSAppConfig.getConfigValue(Constants.configKeys.deviceType);

    if (deviceId == null || deviceId == '') {
      deviceId = const Uuid().v4();
      await DSAppConfig.setConfigValue(Constants.configKeys.deviceId, deviceId);
    }
    if (deviceType == null || deviceType == '') {
      deviceType = platform.name;
      await DSAppConfig.setConfigValue(Constants.configKeys.deviceType, deviceType);
    }

    Constants.talker.info('initDeviceData.deviceId: $deviceId');
    Constants.talker.info('initDeviceData.deviceType: $deviceType');
  }
}
