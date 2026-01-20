import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SnAboutApp extends StatelessWidget {
  const SnAboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = LocalizeAndTranslate.getLanguageCode();
    final isArabic = languageCode == 'ar';
    final body = isArabic ? Constants.aboutArabicText : Constants.aboutEnglishText;
    final textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return WSharedScaffold(
      appBar: WSharedAppBar(title: 'About App'.translated),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Directionality(
          textDirection: textDirection,
          child: Text(body, textAlign: TextAlign.justify, style: context.textTheme.primary18W500.copyWith(height: 1.9)),
        ),
      ),
    );
  }
}
