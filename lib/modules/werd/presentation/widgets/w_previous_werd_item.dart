import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_day.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class WPreviousWerdItem extends StatelessWidget {
  const WPreviousWerdItem({super.key, required this.day, this.isFromAllWerds = false});

  final MWerdDay day;
  final bool isFromAllWerds;

  @override
  Widget build(BuildContext context) {
    final statusText = day.isFinished ? 'Finished'.translated : 'Unfinished'.translated;
    final statusColor = day.isFinished ? context.theme.colorScheme.green : context.theme.colorScheme.red;
    final statusIcon = day.isFinished ? Icons.check_circle : Icons.watch_later_outlined;

    return InkWell(
      onTap: () => _openDay(day),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_dayTitle(context, day), style: context.textTheme.primary16W500),
                  Text(
                    '${_fromText(context, day).translateNumbers()} ${_toText(context, day).translateNumbers()}',
                    style: context.textTheme.primary16W500,
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (isFromAllWerds)
              Padding(
                padding: EdgeInsetsDirectional.only(start: 12.w),
                child: Tooltip(
                  message: statusText,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                    child: Icon(statusIcon, color: statusColor, size: 18.w),
                  ),
                ),
              ),
            8.widthBox,
            WLocalizeRotation(child: Assets.icons.backGold.svg(width: 16.w, height: 16.h)),
          ],
        ),
      ),
    );
  }

  String _dayTitle(BuildContext context, MWerdDay day) =>
      '${'Werd Day'.translated} ${day.dayNumber.toString().translateNumbers()}';

  String _fromText(BuildContext context, MWerdDay day) =>
      '${'From'.translated} ${context.isRTL ? day.startSurahAr : day.startSurahEn} : ${day.startAyahNumber}';

  String _toText(BuildContext context, MWerdDay day) =>
      '${'To'.translated} ${'Surah'.translated} ${context.isRTL ? day.endSurahAr : day.endSurahEn} : ${day.endAyahNumber}';

  void _openDay(MWerdDay day) {
    Modular.get<MgWerd>().openDay(day.dayNumber);
    Modular.to.pushNamed(RoutesNames.werd.werdDetails);
  }
}
