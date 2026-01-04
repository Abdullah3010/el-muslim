import 'dart:async';

import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/modules/core/managers/mg_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SNSplash extends StatefulWidget {
  const SNSplash({super.key});

  @override
  State<SNSplash> createState() => _SNSplashState();
}

class _SNSplashState extends State<SNSplash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await Modular.get<MgCore>().initAppData();
      Modular.get<MgCore>().setNavBarIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      withSafeArea: false,
      padding: EdgeInsets.zero,
      body: Container(
        width: context.width,
        height: context.height,
        decoration: BoxDecoration(color: context.theme.colorScheme.secondaryColor),
        padding: EdgeInsets.symmetric(horizontal: 60.w),
        child: Column(
          children: [
            200.heightBox,
            Container(
              height: 300.h,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(60.r)),
              clipBehavior: Clip.antiAlias,
              child: Assets.icons.quranLogo.svg(),
            ),
            Text('Al-Muslim'.translated, style: context.textTheme.primary18W500.copyWith(fontSize: 50.sp)),
            50.heightBox,
            const CircularProgressIndicator.adaptive(),
          ],
        ),
      ),
    );
  }
}
