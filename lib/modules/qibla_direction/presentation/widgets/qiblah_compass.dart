import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/values/app_colors.dart';
import 'package:al_muslim/modules/qibla_direction/data/models/m_qibla_compass_state.dart';
import 'package:al_muslim/modules/qibla_direction/data/models/m_qibla_location_state.dart';
import 'package:al_muslim/modules/qibla_direction/data/services/qibla_calculation_service.dart';
import 'package:al_muslim/modules/qibla_direction/managers/mg_qibla.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/widgets/loading_indicator.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/widgets/location_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QiblahCompass extends StatefulWidget {
  const QiblahCompass({super.key, required this.locationStatusStream, required this.onRetry});

  final Stream<MQiblaLocationState> locationStatusStream;
  final VoidCallback onRetry;

  @override
  State<QiblahCompass> createState() => _QiblahCompassState();
}

class _QiblahCompassState extends State<QiblahCompass> {
  late final MgQibla _mgQibla;
  Future<void>? _compassInitFuture;

  @override
  void initState() {
    super.initState();
    Constants.talker.info('[QiblahCompass] initState called');
    _mgQibla = Modular.get<MgQibla>();
    Constants.talker.info('[QiblahCompass] MgQibla obtained from Modular');
  }

  Future<void> _initCompass() async {
    Constants.talker.info('[QiblahCompass] _initCompass called');
    await _mgQibla.initializeCompass();
    Constants.talker.info('[QiblahCompass] _initCompass completed');
  }

  @override
  Widget build(BuildContext context) {
    Constants.talker.debug('[QiblahCompass] build called');
    return Container(
      alignment: Alignment.center,
      child: StreamBuilder<MQiblaLocationState>(
        stream: widget.locationStatusStream,
        builder: (context, snapshot) {
          Constants.talker.debug(
            '[QiblahCompass] StreamBuilder - connectionState: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, hasError: ${snapshot.hasError}',
          );

          if (snapshot.hasError) {
            Constants.talker.error('[QiblahCompass] Location stream error: ${snapshot.error}');
            return LocationErrorWidget(message: snapshot.error.toString(), onRetry: widget.onRetry);
          }

          // Use stream data or fall back to cached last state (fixes timing issue on iOS)
          var state = snapshot.data;
          if (state == null && snapshot.connectionState == ConnectionState.waiting) {
            state = _mgQibla.lastLocationState;
            if (state != null) {
              Constants.talker.info('[QiblahCompass] Using cached lastLocationState (stream waiting)');
            }
          }

          if (state == null) {
            Constants.talker.info('[QiblahCompass] Location stream waiting, no cached state...');
            return const LoadingIndicator();
          }

          Constants.talker.info(
            '[QiblahCompass] Location state - isEnabled: ${state.isEnabled}, isPermissionDenied: ${state.isPermissionDenied}, isPermissionDeniedForever: ${state.isPermissionDeniedForever}',
          );

          if (!state.isEnabled) {
            Constants.talker.warning('[QiblahCompass] Location services not enabled');
            return LocationErrorWidget(message: 'Please enable location services'.translated, onRetry: widget.onRetry);
          }

          if (state.isPermissionDenied) {
            Constants.talker.warning('[QiblahCompass] Location permission denied');
            return LocationErrorWidget(message: 'Location permission denied'.translated, onRetry: widget.onRetry);
          }

          if (state.isPermissionDeniedForever) {
            Constants.talker.warning('[QiblahCompass] Location permission denied forever');
            return LocationErrorWidget(
              message: 'Location permission denied forever'.translated,
              onRetry: widget.onRetry,
            );
          }

          Constants.talker.info('[QiblahCompass] Location OK, initializing compass...');
          _compassInitFuture ??= _initCompass();
          return FutureBuilder<void>(
            future: _compassInitFuture,
            builder: (context, futureSnapshot) {
              Constants.talker.debug(
                '[QiblahCompass] FutureBuilder - connectionState: ${futureSnapshot.connectionState}, hasError: ${futureSnapshot.hasError}',
              );
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                Constants.talker.info('[QiblahCompass] Compass init waiting - showing loading indicator');
                return const WQiblaLoadingIndicator();
              }
              if (futureSnapshot.hasError) {
                Constants.talker.error('[QiblahCompass] Compass init error: ${futureSnapshot.error}');
              }
              Constants.talker.info('[QiblahCompass] Compass init complete - showing compass widget');
              final stream = _mgQibla.compassStream;
              Constants.talker.info('[QiblahCompass] Compass stream is ${stream == null ? "NULL" : "available"}');
              return WQiblahCompassWidget(compassStream: stream);
            },
          );
        },
      ),
    );
  }
}

class WQiblahCompassWidget extends StatelessWidget {
  const WQiblahCompassWidget({super.key, required this.compassStream});

  final Stream<MQiblaCompassState>? compassStream;

  @override
  Widget build(BuildContext context) {
    Constants.talker.debug(
      '[WQiblahCompassWidget] build called - compassStream is ${compassStream == null ? "NULL" : "available"}',
    );

    if (compassStream == null) {
      Constants.talker.warning('[WQiblahCompassWidget] Compass stream is null, showing loading');
      return const LoadingIndicator();
    }

    return StreamBuilder<MQiblaCompassState>(
      stream: compassStream,
      builder: (_, AsyncSnapshot<MQiblaCompassState> snapshot) {
        Constants.talker.debug(
          '[WQiblahCompassWidget] StreamBuilder - connectionState: ${snapshot.connectionState}, hasData: ${snapshot.hasData}, hasError: ${snapshot.hasError}',
        );

        if (snapshot.connectionState == ConnectionState.waiting) {
          Constants.talker.info('[WQiblahCompassWidget] Compass stream waiting...');
          return const LoadingIndicator();
        }

        if (snapshot.hasError) {
          Constants.talker.error('[WQiblahCompassWidget] Compass stream error: ${snapshot.error}');
          return Center(child: Text('Compass error: ${snapshot.error}'));
        }

        final compassState = snapshot.data;
        if (compassState == null) {
          Constants.talker.warning('[WQiblahCompassWidget] Compass state is null');
          return const LoadingIndicator();
        }

        Constants.talker.debug(
          '[WQiblahCompassWidget] Compass state - heading: ${compassState.deviceHeading.toStringAsFixed(1)}, qibla: ${compassState.qiblaBearing.toStringAsFixed(1)}, offset: ${compassState.offset.toStringAsFixed(1)}, facing: ${compassState.isFacingQibla}',
        );

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Assets.icons.kaaba.svg(),
            Assets.icons.compassBigBackground.svg(),
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, 8),
                  child:
                      compassState.isFacingQibla
                          ? Assets.icons.compassCircleCorrect.svg()
                          : Assets.icons.compassCircleWrong.svg(),
                ),
                compassState.isFacingQibla
                    ? Assets.icons.compassCircleCorrect.svg()
                    : Assets.icons.compassCircleWrong.svg(),
              ],
            ),
            Container(
              width: 95.w,
              height: 95.w,
              margin: EdgeInsets.only(bottom: context.height * 0.56),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (compassState.isFacingQibla ? Colors.green : Colors.red).withValues(alpha: 0.30),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Assets.icons.kaaba.svg(width: 60.w, height: 60.h),
            ),
            Transform.rotate(
              angle: compassState.rotationAngleRad,
              alignment: Alignment.center,
              child:
                  compassState.isFacingQibla
                      ? Assets.icons.compassPinCorrect.svg()
                      : Assets.icons.compassPinWrong.svg(),
            ),
            Container(
              width: context.width,
              margin: EdgeInsets.only(top: context.height * 0.7),
              child: _buildDirectionText(compassState),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDirectionText(MQiblaCompassState state) {
    if (state.isFacingQibla) {
      return Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          children: [
            TextSpan(
              text: 'The direction of the Qiblah is '.translated,
              style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: ' correct '.translated,
              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' now'.translated,
              style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    final isRotateRight = state.rotationDirection == QiblaRotationDirection.right;
    final direction = isRotateRight ? 'rotate right'.translated : 'rotate left'.translated;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.flip(flipX: !isRotateRight, child: Assets.icons.rotateRightIcon.svg(width: 24.h, height: 24.h)),
        10.widthBox,
        Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            children: [
              TextSpan(
                text: 'Rotate '.translated,
                style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w500),
              ),
              TextSpan(text: direction, style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.bold)),
              TextSpan(
                text: ' to face the Qiblah'.translated,
                style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
