import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_bottom_sheet.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_previous_werd_item.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_werd_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          padding: EdgeInsets.zero,
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : option == null || upcomingDays.isEmpty
                  ? WWerdEmptyState(mgWerd: _mgWerd, onPrimaryAction: _handlePrimaryAction)
                  : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 22.h),
                    itemBuilder: (context, index) {
                      final day = upcomingDays[index];
                      return WPreviousWerdItem(day: day);
                    },
                    separatorBuilder:
                        (_, __) => Divider(
                          height: 8.h,
                          color: context.theme.colorScheme.primaryLightOrange.withValues(alpha: 0.6),
                          endIndent: 18.w,
                          indent: 18.w,
                        ),
                    itemCount: upcomingDays.length,
                  ),
        );
      },
    );
  }

  void _handlePrimaryAction(bool hasCurrentWerd) {
    if (hasCurrentWerd) {
      Modular.to.pushNamed(RoutesNames.werd.werdDetails);
    } else {
      WNewWerdBottomSheet.show(context);
    }
  }
}
