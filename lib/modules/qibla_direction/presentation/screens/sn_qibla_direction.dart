import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/qibla_direction/managers/mg_qibla.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/widgets/loading_indicator.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/widgets/qiblah_compass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SnQiblaDirection extends StatefulWidget {
  const SnQiblaDirection({super.key});

  @override
  State<SnQiblaDirection> createState() => _SnQiblaDirectionState();
}

class _SnQiblaDirectionState extends State<SnQiblaDirection> {
  late final MgQibla _mgQibla;
  late final Future<bool?> _deviceSupportFuture;

  @override
  void initState() {
    super.initState();
    Constants.talker.info('[SnQiblaDirection] initState called');
    _mgQibla = Modular.get<MgQibla>();
    Constants.talker.info('[SnQiblaDirection] MgQibla obtained from Modular');
    try {
      _deviceSupportFuture = _mgQibla.deviceSupportFuture;
      Constants.talker.info('[SnQiblaDirection] Device support future assigned');
      _mgQibla.refreshLocationStatus();
      Constants.talker.info('[SnQiblaDirection] refreshLocationStatus called');
    } catch (e, stackTrace) {
      Constants.talker.error('[SnQiblaDirection] Error in initState: $e');
      Constants.talker.error('[SnQiblaDirection] StackTrace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      padding: EdgeInsets.zero,
      withSafeArea: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.amber,
            child: Assets.images.quiplaBg.image(fit: BoxFit.fitHeight),
          ),
          Positioned(
            top: 40.h,
            right: 0,
            child: Container(
              width: context.width,
              height: 60.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: WSharedAppBar(
                leading: InkWell(
                  onTap: () {
                    Modular.to.pop();
                  },
                  child:
                      context.isRTL
                          ? WLocalizeRotation(reverse: true, child: Assets.icons.backBlack.svg())
                          : Assets.icons.backBlack.svg(),
                ),
              ),
            ),
          ),
          FutureBuilder<bool?>(
            future: _deviceSupportFuture,
            builder: (_, snapshot) {
              Constants.talker.debug(
                '[SnQiblaDirection] FutureBuilder - connectionState: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, hasError: ${snapshot.hasError}, data: ${snapshot.data}',
              );

              if (snapshot.connectionState == ConnectionState.waiting) {
                Constants.talker.info('[SnQiblaDirection] Device support check waiting...');
                return const LoadingIndicator();
              }

              if (snapshot.hasError) {
                Constants.talker.error('[SnQiblaDirection] Device support check error: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              Constants.talker.info('[SnQiblaDirection] Device support result: ${snapshot.data}');

              if (snapshot.data == true) {
                Constants.talker.info('[SnQiblaDirection] Device supports compass - showing QiblahCompass');
                return QiblahCompass(
                  locationStatusStream: _mgQibla.locationStatusStream,
                  onRetry: () {
                    Constants.talker.info('[SnQiblaDirection] Retry button pressed');
                    _mgQibla.refreshLocationStatus();
                  },
                );
              }
              Constants.talker.warning(
                '[SnQiblaDirection] Device does NOT support compass - snapshot.data=${snapshot.data}',
              );
              return Center(
                child: Text(
                  'Your device does not support compass functionality.'.translated,
                  style: context.textTheme.primary16W500.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
              // return QiblahMaps(resolvePosition: _mgQibla.fetchUserPosition);
            },
          ),
        ],
      ),
    );
  }
}
