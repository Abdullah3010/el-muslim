import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_app_button.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SnWerd extends StatelessWidget {
  const SnWerd({super.key});

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      withNavBar: true,
      appBar: WSharedAppBar(title: 'Werd'.translated),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          70.heightBox,
          Text('Werd Description'.translated, style: context.textTheme.primary18W500, textAlign: TextAlign.center),
          50.heightBox,
          Center(
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

                    Text('Start New Werd'.translated, style: context.textTheme.white16W500),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
