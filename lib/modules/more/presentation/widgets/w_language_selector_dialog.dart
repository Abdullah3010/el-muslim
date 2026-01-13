import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/notification/hourly_zekr/hourly_zekr_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class WLanguageSelectorDialog extends StatelessWidget {
  const WLanguageSelectorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, barrierDismissible: true, builder: (_) => const WLanguageSelectorDialog());
  }

  @override
  Widget build(BuildContext context) {
    final String currentCode = LocalizeAndTranslate.getLanguageCode();

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(color: context.theme.colorScheme.white, borderRadius: BorderRadius.circular(22.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(Icons.close, color: context.theme.colorScheme.primaryColor2),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    'Language'.translated,
                    textAlign: TextAlign.center,
                    style: context.textTheme.primary16W500,
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
            20.heightBox,
            Row(
              children: [
                Expanded(
                  child: _LanguageButton(
                    title: 'Arabic'.translated,
                    isSelected: currentCode == 'ar',
                    onTap: () => _onLanguageSelected(context, 'ar'),
                  ),
                ),
                12.widthBox,
                Expanded(
                  child: _LanguageButton(
                    title: 'English'.translated,
                    isSelected: currentCode == 'en',
                    onTap: () => _onLanguageSelected(context, 'en'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onLanguageSelected(BuildContext context, String code) async {
    if (LocalizeAndTranslate.getLanguageCode() == code) {
      Navigator.of(context).pop();
      return;
    }

    context.setLanguageCode(code);
    LocalizeAndTranslate.setLanguageCode(code);

    final hourlyZekrService = HourlyZekrNotificationService();
    await hourlyZekrService.rescheduleIfNeeded();

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _LanguageButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryColor2 : colors.secondaryColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.primaryColor2.withValues(alpha: isSelected ? 1 : 0.3)),
        ),
        child: Center(
          child: Text(
            title,
            style: context.textTheme.primary16W500.copyWith(color: isSelected ? colors.white : colors.primaryColor2),
          ),
        ),
      ),
    );
  }
}
