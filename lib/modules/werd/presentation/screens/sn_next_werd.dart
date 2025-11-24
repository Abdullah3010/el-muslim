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

class SnNextWerd extends StatelessWidget {
  const SnNextWerd({super.key});

  static const List<_NextWerd> _nextWerds = [
    _NextWerd(
      titleAr: 'الورد 4',
      titleEn: 'Werd 4',
      fromAr: 'سورة المائدة - آية 1',
      fromEn: 'Surah Al-Ma\'idah - Verse 1',
      toAr: 'الي سورة المائدة - آية 50',
      toEn: 'To Surah Al-Ma\'idah - Verse 50',
    ),
    _NextWerd(
      titleAr: 'الورد 5',
      titleEn: 'Werd 5',
      fromAr: 'سورة المائدة - آية 51',
      fromEn: 'Surah Al-Ma\'idah - Verse 51',
      toAr: 'الي سورة المائدة - آية 120',
      toEn: 'To Surah Al-Ma\'idah - Verse 120',
    ),
    _NextWerd(
      titleAr: 'الورد 6',
      titleEn: 'Werd 6',
      fromAr: 'سورة الأنعام - آية 1',
      fromEn: 'Surah Al-An\'am - Verse 1',
      toAr: 'الي سورة الأنعام - آية 50',
      toEn: 'To Surah Al-An\'am - Verse 50',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      appBar: WSharedAppBar(title: 'Next Awrads'.translated),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        itemBuilder: (context, index) {
          final _NextWerd item = _nextWerds[index];
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
        itemCount: _nextWerds.length,
      ),
    );
  }
}

class _NextWerd {
  const _NextWerd({
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
