import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_previous_werd_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnAllWerds extends StatefulWidget {
  const SnAllWerds({super.key});

  @override
  State<SnAllWerds> createState() => _SnAllWerdsState();
}

class _SnAllWerdsState extends State<SnAllWerds> {
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
        final days = _mgWerd.planDays;

        return WSharedScaffold(
          appBar: WSharedAppBar(title: 'All Werds'.translated),
          padding: EdgeInsets.zero,
          body:
              isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : option == null
                  ? _buildMessage(context, 'Select a werd plan first'.translated)
                  : days.isEmpty
                  ? _buildMessage(context, _mgWerd.planDetailsError ?? 'No werd plans found'.translated)
                  : ListView.separated(
                    itemBuilder: (context, index) {
                      final day = days[index];

                      return WPreviousWerdItem(day: day, isFromAllWerds: true);
                    },
                    separatorBuilder:
                        (_, __) => Divider(
                          height: 8.h,
                          color: context.theme.colorScheme.primaryLightOrange.withValues(alpha: 0.6),
                          endIndent: 18.w,
                          indent: 18.w,
                        ),
                    itemCount: days.length,
                  ),
        );
      },
    );
  }

  Widget _buildMessage(BuildContext context, String text) {
    return Center(child: Text(text, style: context.textTheme.primary14W400, textAlign: TextAlign.center));
  }
}
