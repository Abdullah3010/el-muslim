import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/notification/notification_box/m_notification.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_localize_rotation.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/index/managers/mg_index.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_detail_segment.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_details_completion_button.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_details_progress.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_details_reminder.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_details_verse.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SnWerdDetails extends StatefulWidget {
  const SnWerdDetails({super.key, this.initialOption});

  final MWerdPlanOption? initialOption;

  @override
  State<SnWerdDetails> createState() => _SnWerdDetailsState();
}

class _SnWerdDetailsState extends State<SnWerdDetails> {
  late final MgWerd _mgWerd;

  @override
  void initState() {
    super.initState();
    _mgWerd = Modular.get<MgWerd>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.initialOption != null) {
        _mgWerd.selectOption(widget.initialOption!);
      } else {
        _mgWerd.loadSelectedPlan();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mgWerd,
      builder: (context, _) {
        final option = _mgWerd.selectedOption;
        final day = _mgWerd.selectedPlanDay;
        final MLocalNotification? primaryNotification = _mgWerd.primaryNotification;
        final bool isArabic = LocalizeAndTranslate.getLanguageCode() == 'ar';
        final isLoading = _mgWerd.isPlanDetailsLoading || _mgWerd.isPlanLoading;

        if (option == null) {
          return WSharedScaffold(
            padding: EdgeInsets.zero,
            withNavBar: true,
            appBar: WSharedAppBar(title: 'Al-Werd'.translated),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Select a werd plan to view details'.translated, textAlign: TextAlign.center),
                  12.heightBox,
                  TextButton(onPressed: () => Modular.to.pop(), child: Text('Back'.translated)),
                ],
              ),
            ),
          );
        }

        if (isLoading && day == null) {
          return WSharedScaffold(
            padding: EdgeInsets.zero,
            withNavBar: true,
            appBar: WSharedAppBar(title: 'Al-Werd'.translated),
            body: const Center(child: CircularProgressIndicator.adaptive()),
          );
        }

        if (day == null) {
          return WSharedScaffold(
            padding: EdgeInsets.zero,
            withNavBar: true,
            appBar: WSharedAppBar(title: 'Al-Werd'.translated),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No werd day selected'.translated, textAlign: TextAlign.center),
                  12.heightBox,
                  TextButton(onPressed: () => _mgWerd.loadPlanDay(), child: Text('Reload'.translated)),
                ],
              ),
            ),
          );
        }

        final String planTitle = isArabic ? option.titleAr : option.titleEn;
        final List<MWerdDetailSegment> segments = _mgWerd.currentDaySegments;
        final double progress = _mgWerd.progress.clamp(0, 1).toDouble();
        final int previousWerds = _mgWerd.finishedDaysCount;
        final int remainingDaysRaw = _mgWerd.remainingDaysCount;
        final int remainingDays = remainingDaysRaw < 0 ? 0 : remainingDaysRaw;
        final int upcomingWerds = (remainingDays - (day.isFinished ? 0 : 1)).clamp(0, remainingDays).toInt();
        final String statusLabel =
            day.isFinished
                ? 'Completed'.translated
                : '${'Remaining'.translated}: ${remainingDays.toString().translateNumbers()}';

        return WSharedScaffold(
          padding: EdgeInsets.zero,
          withNavBar: true,
          appBar: WSharedAppBar(title: 'Al-Werd'.translated),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              12.heightBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Text(
                      '${'Werd Day'.translated} ${day.dayNumber}'.translateNumbers(),
                      style: context.textTheme.primary16W500,
                    ),
                  ),
                  6.heightBox,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Text(planTitle, style: context.textTheme.primary20W500, textAlign: TextAlign.center),
                  ),
                  14.heightBox,
                  if (isLoading)
                    const Center(child: CircularProgressIndicator.adaptive())
                  else if (_mgWerd.planDetailsError != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Text(_mgWerd.planDetailsError ?? '', style: context.textTheme.primary14W400),
                    )
                  else if (segments.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Text('No plan details found'.translated, style: context.textTheme.primary14W400),
                    )
                  else
                    ...segments.map((segment) {
                      final int pageNumber =
                          segment.startPageNumber != 0 ? segment.startPageNumber : segment.endPageNumber;
                      return WNewWerdDetailsVerse(
                        title: isArabic ? segment.titleAr : segment.titleEn,
                        subtitle: isArabic ? segment.subtitleAr : segment.subtitleEn,
                        onTap: pageNumber > 0 ? () => _openPage(pageNumber) : null,
                      );
                    }),
                  20.heightBox,
                  WNewWerdDetailsCompletionButton(
                    title: 'Complete Werd'.translated,
                    onPressed: day.isFinished ? null : _onCompleteCurrentWerd,
                  ),
                  20.heightBox,
                  WNewWerdDetailsReminder(
                    label: 'Daily Werd'.translated,
                    notification: primaryNotification,
                    onToggle: (value) => _toggleReminder(primaryNotification, value),
                    onTap: _openReminders,
                  ),
                  20.heightBox,
                  WNewWerdDetailsProgress(
                    progress: progress,
                    previousWerds: previousWerds,
                    upcomingWerds: upcomingWerds,
                    statusLabel: statusLabel,
                  ),
                  18.heightBox,
                  InkWell(
                    onTap: _openAllWerds,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 18.w),
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.secondaryColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Text('All Werds'.translated, style: context.textTheme.primary16W500),
                          const Spacer(),
                          Text('${_mgWerd.totalDays}'.translateNumbers(), style: context.textTheme.primary16W500),
                          10.widthBox,
                          WLocalizeRotation(child: Assets.icons.backGold.svg(width: 18.w, height: 18.h)),
                        ],
                      ),
                    ),
                  ),
                  22.heightBox,
                  InkWell(
                    onTap: () {
                      Modular.to.pop();
                      _mgWerd.deleteCurrentWerdPlan();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
      },
    );
  }

  Future<void> _onCompleteCurrentWerd() async {
    await _mgWerd.markCurrentDayFinished();
  }

  void _openPage(int pageNumber) {
    if (pageNumber <= 0) return;
    Modular.get<MgIndex>().selectPage(pageNumber);
  }

  void _openAllWerds() {
    Modular.to.pushNamed(RoutesNames.werd.allWerds);
  }

  void _openReminders() {
    Modular.to.pushNamed(RoutesNames.werd.dailyAwradAlarm);
  }

  void _toggleReminder(MLocalNotification? notification, bool value) {
    if (notification == null) return;
    _mgWerd.toggleNotification(notification.id, value);
  }
}
