import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
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
            height: Constants.navbarHeight.h,
            width: context.width,
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            decoration: BoxDecoration(color: context.theme.colorScheme.primaryColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(manager.navBarItems.length, (index) {
                return InkWell(
                  onTap: () => manager.setNavBarIndex(index),
                  child: SizedBox(
                    width: (context.width / manager.navBarItems.length) - 18.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          (manager.navIndex == index
                                  ? manager.navBarItems[index].activeIcon
                                  : manager.navBarItems[index].inactiveIcon) ??
                              '',
                          width: 30.w,
                          height: 30.h,
                        ),
                        6.heightBox,
                        Text(
                          manager.navBarItems[index].label ?? '',
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.onPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
