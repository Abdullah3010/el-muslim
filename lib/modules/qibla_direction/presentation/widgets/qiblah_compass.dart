import 'dart:math' show pi;

import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/modules/qibla_direction/data/models/m_qibla_location_state.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/widgets/loading_indicator.dart';
import 'package:al_muslim/modules/qibla_direction/presentation/widgets/location_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/values/app_colors.dart';

class QiblahCompass extends StatelessWidget {
  const QiblahCompass({super.key, required this.locationStatusStream, required this.onRetry});

  final Stream<MQiblaLocationState> locationStatusStream;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: StreamBuilder<MQiblaLocationState>(
        stream: locationStatusStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingIndicator();
          }

          if (snapshot.hasError) {
            return LocationErrorWidget(message: snapshot.error.toString(), onRetry: onRetry);
          }

          final state = snapshot.data;
          if (state == null) {
            return const LoadingIndicator();
          }

          if (!state.isEnabled) {
            return LocationErrorWidget(message: 'Please enable location services'.translated, onRetry: onRetry);
          }

          if (state.isPermissionDenied) {
            return LocationErrorWidget(message: 'Location permission denied'.translated, onRetry: onRetry);
          }

          if (state.isPermissionDeniedForever) {
            return LocationErrorWidget(message: 'Location permission denied forever'.translated, onRetry: onRetry);
          }

          return const QiblahCompassWidget();
        },
      ),
    );
  }
}

class QiblahCompassWidget extends StatelessWidget {
  const QiblahCompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        final qiblahDirection = snapshot.data!;
        final isQiblahCorrect =
            (qiblahDirection.direction.abs() >= qiblahDirection.offset.abs() - 5.0 &&
                qiblahDirection.direction.abs() <= qiblahDirection.offset.abs() + 5.0);

        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Assets.icons.kaaba.svg(),
            Assets.icons.compassBigBackground.svg(),
            // Assets.icons.compassSmallBackground.svg(),
            Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, 8),
                  child:
                      isQiblahCorrect ? Assets.icons.compassCircleCorrect.svg() : Assets.icons.compassCircleWrong.svg(),
                ),
                isQiblahCorrect ? Assets.icons.compassCircleCorrect.svg() : Assets.icons.compassCircleWrong.svg(),
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
                    color: (isQiblahCorrect ? Colors.green : Colors.red).withValues(alpha: 0.30),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Assets.icons.kaaba.svg(width: 60.w, height: 60.h),
            ),
            Transform.rotate(
              angle: (qiblahDirection.qiblah * (pi / 180) * -1),
              alignment: Alignment.center,
              child: isQiblahCorrect ? Assets.icons.compassPinCorrect.svg() : Assets.icons.compassPinWrong.svg(),
            ),
            Container(
              width: context.width,
              margin: EdgeInsets.only(top: context.height * 0.7),
              child: _buildDirectionText(qiblahDirection.offset, qiblahDirection.direction),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDirectionText(double offset, double directionOffset) {
    final bool isCorrect = directionOffset.abs() >= offset.abs() - 5.0 && directionOffset.abs() <= offset.abs() + 5.0;

    if (isCorrect) {
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

    final direction = directionOffset > offset.abs() ? 'rotate left'.translated : 'rotate right'.translated;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.rotate(
          angle: directionOffset > offset.abs() ? pi : 0,
          child: Assets.icons.rotateRightIcon.svg(width: 24.h, height: 24.h),
        ),
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
