import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/core/widgets/w_settings_section_header.dart';
import 'package:al_muslim/modules/werd/data/models/m_werd_plan_option.dart';
import 'package:al_muslim/modules/werd/managers/mg_werd.dart';
import 'package:al_muslim/modules/werd/presentation/widgets/w_new_werd_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WNewWerdBottomSheet extends StatefulWidget {
  const WNewWerdBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const WNewWerdBottomSheet(),
    );
  }

  @override
  State<WNewWerdBottomSheet> createState() => _WNewWerdBottomSheetState();
}

class _WNewWerdBottomSheetState extends State<WNewWerdBottomSheet> {
  late final MgWerd _mgWerd;

  @override
  void initState() {
    super.initState();
    _mgWerd = Modular.get<MgWerd>();
    _mgWerd.loadOptions();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mgWerd,
      builder: (context, _) {
        final isLoading = _mgWerd.isLoading && !_mgWerd.hasData;
        final errorMessage = _mgWerd.errorMessage;
        final suggestedOptions = _mgWerd.suggestedOptions;
        final otherOptions = _mgWerd.otherOptions;

        return Container(
          constraints: BoxConstraints(maxHeight: context.height * 0.75),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                8.heightBox,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(Icons.close, color: context.theme.colorScheme.primaryColor),
                          ),
                          Expanded(
                            child: Text(
                              'New Werd'.translated,
                              textAlign: TextAlign.center,
                              style: context.textTheme.primary18W500,
                            ),
                          ),
                          SizedBox(width: 48.w),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isLoading && !_mgWerd.hasData)
                  Expanded(
                    child: Center(child: CircularProgressIndicator(color: context.theme.colorScheme.primaryColor)),
                  )
                else if (errorMessage != null)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            errorMessage,
                            textAlign: TextAlign.center,
                            style: context.textTheme.primary14W400,
                          ),
                        ),
                        12.heightBox,
                        TextButton(onPressed: () => _mgWerd.loadOptions(), child: Text('Retry'.translated)),
                      ],
                    ),
                  )
                else if (!_mgWerd.hasData)
                  Expanded(
                    child: Center(
                      child: Text('No werd plans found'.translated, style: context.textTheme.primary14W400),
                    ),
                  )
                else
                  _buildContent(context, suggestedOptions, otherOptions),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<MWerdPlanOption> suggestedOptions,
    List<MWerdPlanOption> otherOptions,
  ) {
    return Expanded(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WSettingsSectionHeader(title: 'Suggested'.translated),
                8.heightBox,
                if (suggestedOptions.isNotEmpty)
                  _buildOptionList(context, suggestedOptions)
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                    child: Text('No suggested plans'.translated, style: context.textTheme.primary14W400),
                  ),
                12.heightBox,
                WSettingsSectionHeader(title: 'All'.translated),
              ],
            ),
          ),
          12.heightBox,
          if (otherOptions.isNotEmpty)
            _buildOptionList(context, otherOptions)
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Text('No werd plans found'.translated, style: context.textTheme.primary14W400),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionList(BuildContext context, List<MWerdPlanOption> options) {
    return Column(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          WNewWerdOptionItem(option: options[i], onTap: () => _selectOption(context, options[i])),
          if (i < options.length - 1)
            Divider(color: context.theme.colorScheme.secondaryColor, height: 1, indent: 20.w, endIndent: 20.w),
        ],
      ],
    );
  }

  Future<void> _selectOption(BuildContext context, MWerdPlanOption option) async {
    await _mgWerd.selectOption(option);
    if (!mounted) return;
    Navigator.of(context).pop();
    Future.microtask(() => Modular.to.pushNamed(RoutesNames.werd.werdDetails));
  }
}
