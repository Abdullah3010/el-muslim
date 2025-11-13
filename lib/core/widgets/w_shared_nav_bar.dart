import 'package:al_muslim/modules/core/managers/mg_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:provider/provider.dart';

class WSharedNavBar extends StatefulWidget {
  const WSharedNavBar({super.key});

  @override
  State<WSharedNavBar> createState() => _WSharedNavBarState();
}

class _WSharedNavBarState extends State<WSharedNavBar> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Consumer<MgCore>(
        builder: (context, manager, _) {
          return Container(
            height: 63.h,
            width: context.width * 0.8,
            padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 20.h),
            margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: context.theme.colorScheme.secondaryBlue,
              borderRadius: BorderRadius.circular(32.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10.r, offset: Offset(0, -1.h)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(manager.activeIcons.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 18.w),
                  child: InkWell(
                    onTap: () => manager.setNavBarIndex(index),
                    child: SvgPicture.asset(
                      manager.navIndex == index ? manager.activeIcons[index] : manager.inactiveIcons[index],
                      width: 24.w,
                      height: 24.h,
                      colorFilter:
                          manager.navIndex != 1
                              ? ColorFilter.mode(
                                manager.navIndex == index
                                    ? context.theme.colorScheme.primaryOrange
                                    : context.theme.colorScheme.white,
                                BlendMode.srcIn,
                              )
                              : null,
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
