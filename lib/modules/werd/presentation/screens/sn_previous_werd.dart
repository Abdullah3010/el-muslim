import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_previous_werd_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SnPreviousWerd extends StatelessWidget {
  const SnPreviousWerd({super.key});

  static const List<_PreviousWerd> _previousWerds = [
    _PreviousWerd(
      titleAr: 'الورد 1',
      titleEn: 'Werd 1',
      fromAr: 'سورة الفاتحة - آية 1',
      fromEn: 'Surah Al-Fatiha - Verse 1',
      toAr: 'الى سورة البقرة - آية 282',
      toEn: 'To Surah Al-Baqara - Verse 282',
    ),
    _PreviousWerd(
      titleAr: 'الورد 2',
      titleEn: 'Werd 2',
      fromAr: 'سورة البقرة - آية 283',
      fromEn: 'Surah Al-Baqara - Verse 283',
      toAr: 'الي سورة النساء - آية 113',
      toEn: 'To Surah An-Nisa - Verse 113',
    ),
    _PreviousWerd(
      titleAr: 'الورد 3',
      titleEn: 'Werd 3',
      fromAr: 'سورة البقرة - آية 283',
      fromEn: 'Surah Al-Baqara - Verse 283',
      toAr: 'الي سورة النساء - آية 113',
      toEn: 'To Surah An-Nisa - Verse 113',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      appBar: WSharedAppBar(title: 'Previous Awrads'.translated),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        itemBuilder: (context, index) {
          final _PreviousWerd item = _previousWerds[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title(context).translateNumbers(), style: context.textTheme.primary16W500),
              10.heightBox,
              WPreviousWerdItem(fromText: item.fromText(context), toText: item.toText(context)),
            ],
          );
        },
        separatorBuilder: (_, __) => 16.heightBox,
        itemCount: _previousWerds.length,
      ),
    );
  }
}

class _PreviousWerd {
  const _PreviousWerd({
    required this.titleAr,
    required this.titleEn,
    required this.fromAr,
    required this.fromEn,
    required this.toAr,
    required this.toEn,
  });

  final String titleAr;
  final String titleEn;
  final String fromAr;
  final String fromEn;
  final String toAr;
  final String toEn;

  String title(BuildContext context) => context.isRTL ? titleAr : titleEn;

  String fromText(BuildContext context) => context.isRTL ? fromAr : fromEn;

  String toText(BuildContext context) => context.isRTL ? toAr : toEn;
}
