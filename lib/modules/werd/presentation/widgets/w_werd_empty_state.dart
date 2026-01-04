import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class WWerdEmptyState extends StatelessWidget {
  final MgWerd mgWerd;
  final void Function(bool hasCurrentWerd) onPrimaryAction;

  const WWerdEmptyState({super.key, required this.mgWerd, required this.onPrimaryAction});

  @override
  Widget build(BuildContext context) {
    final option = mgWerd.selectedOption;
    final title = option != null ? (context.isRTL ? option.titleAr : option.titleEn) : 'Werd Description'.translated;
    final subtitle = option != null ? (context.isRTL ? option.subtitleAr : option.subtitleEn) : null;
    final daysLabel = option != null ? (context.isRTL ? '${option.days} يوماً' : '${option.days} days') : null;
    final hasCurrentWerd = mgWerd.selectedPlanDay != null;
    final buttonLabel = hasCurrentWerd ? 'Continue Werd'.translated : 'Start New Werd'.translated;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        70.heightBox,
        Text(title, style: context.textTheme.primary18W500, textAlign: TextAlign.center),
        if (subtitle != null) ...[
          12.heightBox,
          Text(subtitle, style: context.textTheme.primary14W400, textAlign: TextAlign.center),
        ],
        if (daysLabel != null) ...[
          8.heightBox,
          Text(daysLabel, style: context.textTheme.primary14W400, textAlign: TextAlign.center),
        ],
        20.heightBox,
        Center(
          child: GestureDetector(
            onTap: () => onPrimaryAction(hasCurrentWerd),
            child: Container(
              width: 171.w,
              height: 53.h,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primaryColor,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      context.isRTL ? Icons.arrow_back : Icons.arrow_forward,
                      color: context.theme.colorScheme.white,
                    ),
                    Text(buttonLabel, style: context.textTheme.white16W500),
                  ],
                ),
              ),
            ),
          ),
        ),
        35.heightBox,
        Assets.icons.quranLogo.svg(width: 300.w, height: 300.h),
      ],
    );
  }
}
