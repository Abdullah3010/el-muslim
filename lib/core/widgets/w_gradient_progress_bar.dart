import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WGradientProgressBar extends StatelessWidget {
  const WGradientProgressBar({super.key, required this.value, this.height = 14});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    final theme = Theme.of(context);
    final gradient = LinearGradient(
      colors: [theme.colorScheme.goldLight3, theme.colorScheme.goldBright3, theme.colorScheme.goldDark2],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final filledWidth = constraints.maxWidth * clamped;
          return Stack(
            children: [
              Container(width: constraints.maxWidth, height: height.h, color: theme.colorScheme.lightGray),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: filledWidth,
                height: height.h,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.r), gradient: gradient),
              ),
            ],
          );
        },
      ),
    );
  }
}
