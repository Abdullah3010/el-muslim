import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_day.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_bottom_sheet.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_previous_werd_item.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_werd_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SnNextWerd extends StatefulWidget {
  const SnNextWerd({super.key});

  @override
  State<SnNextWerd> createState() => _SnNextWerdState();
}

class _SnNextWerdState extends State<SnNextWerd> {
  late final MgWerd _mgWerd;

  @override
  void initState() {
    super.initState();
    _mgWerd = Modular.get<MgWerd>();
    if (_mgWerd.selectedOption == null && !_mgWerd.isPlanLoading) {
      _mgWerd.loadSelectedPlan();
    } else if (_mgWerd.planDays.isEmpty && !_mgWerd.isPlanDetailsLoading) {
      _mgWerd.loadPlanDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mgWerd,
      builder: (context, _) {
        final isLoading = _mgWerd.isPlanLoading || _mgWerd.isPlanDetailsLoading;
        final option = _mgWerd.selectedOption;
        final upcomingDays = _mgWerd.upcomingDays;

        return WSharedScaffold(
          appBar: WSharedAppBar(title: 'Next Awrads'.translated),
          body: isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : option == null || upcomingDays.isEmpty
                  ? WWerdEmptyState(
                      mgWerd: _mgWerd,
                      onPrimaryAction: _handlePrimaryAction,
                    )
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                      itemBuilder: (context, index) {
                        final day = upcomingDays[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_dayTitle(context, day).translateNumbers(), style: context.textTheme.primary16W500),
                            10.heightBox,
                            WPreviousWerdItem(
                              fromText: _fromText(context, day),
                              toText: _toText(context, day),
                              onTap: () => _openDay(day),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (_, __) => 16.heightBox,
                      itemCount: upcomingDays.length,
                    ),
        );
      },
    );
  }

  String _dayTitle(BuildContext context, MWerdDay day) =>
      context.isRTL ? 'الورد ${day.dayNumber}' : 'Werd ${day.dayNumber}';

  String _fromText(BuildContext context, MWerdDay day) =>
      context.isRTL ? 'سورة ${day.startSurahAr} - آية ${day.startAyahNumber}' : 'Surah ${day.startSurahEn} - Verse ${day.startAyahNumber}';

  String _toText(BuildContext context, MWerdDay day) =>
      context.isRTL ? 'إلى سورة ${day.endSurahAr} - آية ${day.endAyahNumber}' : 'To Surah ${day.endSurahEn} - Verse ${day.endAyahNumber}';

  void _openDay(MWerdDay day) {
    _mgWerd.openDay(day.dayNumber);
    Modular.to.pushNamed(RoutesNames.werd.werdDetails);
  }

  void _handlePrimaryAction(bool hasCurrentWerd) {
    if (hasCurrentWerd) {
      Modular.to.pushNamed(RoutesNames.werd.werdDetails);
    } else {
      WNewWerdBottomSheet.show(context);
    }
  }
}
