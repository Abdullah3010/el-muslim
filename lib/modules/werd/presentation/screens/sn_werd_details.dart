import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_details_completion_button.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_details_progress.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_details_reminder.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_details_verse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SnWerdDetails extends StatelessWidget {
  const SnWerdDetails({super.key, required this.option});

  final MWerdPlanOption option;

  static const List<MWerdDetailSegment> _segments = [
    MWerdDetailSegment(
      titleAr: 'من الفاتحة: 1',
      titleEn: 'From Al-Fatihah: 1',
      subtitleAr: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      subtitleEn: 'In the name of Allah, the Merciful, the Compassionate',
    ),
    MWerdDetailSegment(
      titleAr: 'إلى البقرة: 141',
      titleEn: 'To Al-Baqarah: 141',
      subtitleAr: 'بَلْقَادْ هَدَىٰ لَهَا لَمْ تَغْشَهَا ؟',
      subtitleEn: 'That is the verse for whom He provided guidance',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isArabic = LocalizeAndTranslate.getLanguageCode() == 'ar';
    final String planTitle = isArabic ? option.titleAr : option.titleEn;

    return WSharedScaffold(
      padding: EdgeInsets.zero,
      withNavBar: true,
      appBar: WSharedAppBar(title: 'Werd Details'.translated),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          12.heightBox,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Text('${'Werd Day'.translated} 1', style: context.textTheme.primary16W500),
              ),
              6.heightBox,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: Text(planTitle, style: context.textTheme.primary20W500, textAlign: TextAlign.center),
              ),
              14.heightBox,
              ..._segments.map(
                (segment) => WNewWerdDetailsVerse(
                  title: isArabic ? segment.titleAr : segment.titleEn,
                  subtitle: isArabic ? segment.subtitleAr : segment.subtitleEn,
                ),
              ),
              20.heightBox,
              WNewWerdDetailsCompletionButton(title: 'Complete Werd'.translated, onPressed: () {}),
              20.heightBox,
              WNewWerdDetailsReminder(label: 'Daily Werd'.translated, timeLabel: '03:30 PM'),
              20.heightBox,
              WNewWerdDetailsProgress(
                progress: 0.68,
                previousWerds: 3,
                upcomingWerds: 9,
                statusLabel: 'You are behind by 7 days'.translated,
              ),
              18.heightBox,
              InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 18.w),
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.secondaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Text('All Werds'.translated, style: context.textTheme.primary16W500),
                      const Spacer(),
                      Text('30', style: context.textTheme.primary16W500),
                      10.widthBox,
                      WLocalizeRotation(reverse: true, child: Assets.icons.backGold.svg(width: 18.w, height: 18.h)),
                    ],
                  ),
                ),
              ),
              22.heightBox,
              InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.secondaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [Text('Delete Werd'.translated, style: context.textTheme.red16W500), const Spacer()],
                  ),
                ),
              ),

              Constants.navbarHeight.heightBox,
            ],
          ),
        ],
      ),
    );
  }
}

@immutable
class MWerdDetailSegment {
  const MWerdDetailSegment({
    required this.titleAr,
    required this.titleEn,
    required this.subtitleAr,
    required this.subtitleEn,
  });

  final String titleAr;
  final String titleEn;
  final String subtitleAr;
  final String subtitleEn;
}
