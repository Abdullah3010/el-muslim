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
    return Consumer<MgCore>(
      builder: (context, manager, _) {
        final activeColor = context.theme.colorScheme.primaryColor;
        final inactiveColor = context.theme.colorScheme.gray;

        return Container(
          height: Constants.navbarHeight.h,
          width: context.width,
          padding: EdgeInsets.only(top: 12.h, left: 18.w, right: 18.w),
          decoration: const BoxDecoration(color: Colors.white),
          child: SafeArea(
            bottom: true,
            top: false,
            right: true,
            left: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(manager.navBarItems.length, (index) {
                final item = manager.navBarItems[index];
                final isActive = manager.navIndex == index;
                final labelStyle = context.theme.textTheme.bodySmall?.copyWith(
                  color: isActive ? activeColor : inactiveColor,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  height: 1.1,
                );

                return Expanded(
                  child: InkWell(
                    onTap: () => manager.setNavBarIndex(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            (isActive ? item.activeIcon : item.inactiveIcon) ?? '',
                            width: 26.w,
                            height: 26.h,
                            colorFilter: ColorFilter.mode(isActive ? activeColor : inactiveColor, BlendMode.srcIn),
                          ),
                          4.heightBox,
                          Text(item.label ?? '', style: labelStyle, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
