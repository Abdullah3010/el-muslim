import 'dart:math' as math;

import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

class WQiblaLoadingIndicator extends StatefulWidget {
  const WQiblaLoadingIndicator({super.key});

  @override
  State<WQiblaLoadingIndicator> createState() => _WQiblaLoadingIndicatorState();
}

class _WQiblaLoadingIndicatorState extends State<WQiblaLoadingIndicator> with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  int _currentStep = 0;
  final List<String> _loadingSteps = ['qibla_loading_location', 'qibla_loading_calculating', 'qibla_loading_compass'];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();

    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _startStepAnimation();
  }

  void _startStepAnimation() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && _currentStep < _loadingSteps.length - 1) {
        setState(() => _currentStep++);
        _startStepAnimation();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 160.w,
                  height: 160.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        Theme.of(context).primaryColor.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Transform.rotate(angle: _rotationController.value * 2 * math.pi, child: child);
                  },
                  child: Assets.icons.compassSmallBackground.svg(width: 130.w, height: 130.w),
                ),
                Container(
                  width: 55.w,
                  height: 55.w,
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2)],
                  ),
                  child: Assets.icons.kaaba.svg(),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _loadingSteps[_currentStep].translated,
              key: ValueKey(_currentStep),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.black),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'qibla_loading_please_wait'.translated,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: 180.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                minHeight: 6.h,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _loadingSteps.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: index == _currentStep ? 24.w : 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: index <= _currentStep ? Theme.of(context).primaryColor : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
