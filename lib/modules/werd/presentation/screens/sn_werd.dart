import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_bottom_sheet.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SnWerd extends StatefulWidget {
  const SnWerd({super.key});

  @override
  State<SnWerd> createState() => _SnWerdState();
}

class _SnWerdState extends State<SnWerd> {
  late final MgWerd _mgWerd;
  late final VoidCallback _listener;
  bool _shouldAutoOpenSaved = true;

  @override
  void initState() {
    super.initState();
    _mgWerd = Modular.get<MgWerd>();
    _listener = _handleUpdates;
    _mgWerd.addListener(_listener);
    _mgWerd.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mgWerd,
      builder: (context, _) {
        final option = _mgWerd.selectedOption;
        final title = option != null ? (context.isRTL ? option.titleAr : option.titleEn) : 'Werd Description'.translated;
        final subtitle = option != null ? (context.isRTL ? option.subtitleAr : option.subtitleEn) : null;
        final daysLabel =
            option != null ? (context.isRTL ? '${option.days} يوماً' : '${option.days} days') : null;
        final hasCurrentWerd = _mgWerd.selectedPlanDay != null;
        final buttonLabel = hasCurrentWerd ? 'Continue Werd'.translated : 'Start New Werd'.translated;

        return WSharedScaffold(
          withNavBar: true,
          appBar: WSharedAppBar(title: 'Werd'.translated),
          body: _mgWerd.isPlanLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    70.heightBox,
                    Text(title, style: context.textTheme.primary18W500, textAlign: TextAlign.center),
                    if (subtitle != null) ...[
                      12.heightBox,
                      Text(subtitle, style: context.textTheme.primary14W400, textAlign: TextAlign.center),
                    ],
                    if (daysLabel != null) ...[
                      8.heightBox,
                      Text(daysLabel, style: context.textTheme.primary14W400, textAlign: TextAlign.center),
                    ],
                    50.heightBox,
                    Center(
                      child: GestureDetector(
                        onTap: () => _handlePrimaryAction(hasCurrentWerd),
                        child: Container(
                          width: 171.w,
                          height: 53.h,
                          decoration: BoxDecoration(
                            color: context.theme.colorScheme.primaryColor,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  context.isRTL ? Icons.arrow_back : Icons.arrow_forward,
                                  color: context.theme.colorScheme.white,
                                ),
                                Text(buttonLabel, style: context.textTheme.white16W500),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mgWerd.removeListener(_listener);
    super.dispose();
  }

  void _handlePrimaryAction(bool hasCurrentWerd) {
    _shouldAutoOpenSaved = false;
    if (hasCurrentWerd) {
      Modular.to.pushNamed(RoutesNames.werd.werdDetails);
    } else {
      WNewWerdBottomSheet.show(context);
    }
  }

  void _handleUpdates() {
    if (!_shouldAutoOpenSaved) return;
    if (_mgWerd.isPlanLoading || _mgWerd.isPlanDetailsLoading) return;
    if (_mgWerd.selectedPlanDay == null) return;

    _shouldAutoOpenSaved = false;
    Modular.to.pushNamed(RoutesNames.werd.werdDetails);
  }
}
