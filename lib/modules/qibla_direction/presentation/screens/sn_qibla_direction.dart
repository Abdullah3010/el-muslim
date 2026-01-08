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
    _mgQibla = Modular.get<MgQibla>();
    try {
      _deviceSupportFuture = _mgQibla.deviceSupportFuture;
      _mgQibla.refreshLocationStatus();
    } catch (e) {
      Constants.talker.error(" ======>> Error in Qibla Direction screen initState: $e");
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
                  child: WLocalizeRotation(reverse: true, child: Assets.icons.backBlack.svg()),
                ),
              ),
            ),
          ),
          FutureBuilder<bool?>(
            future: _deviceSupportFuture,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingIndicator();
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.data == true) {
                return QiblahCompass(
                  locationStatusStream: _mgQibla.locationStatusStream,
                  onRetry: () => _mgQibla.refreshLocationStatus(),
                );
              }
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
