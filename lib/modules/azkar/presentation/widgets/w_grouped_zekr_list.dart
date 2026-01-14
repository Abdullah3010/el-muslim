import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WGroupedZekrList extends StatelessWidget {
  const WGroupedZekrList({super.key, required this.groupedKeys, required this.onSelect});

  final List<String> groupedKeys;
  final void Function(String key) onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      itemBuilder: (context, index) {
        final key = groupedKeys[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14.r),
            onTap: () => onSelect(key),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: context.theme.colorScheme.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: context.theme.colorScheme.lightGray.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.colorScheme.lightGray.withValues(alpha: 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: Text(key, style: context.textTheme.primary18W500, overflow: TextOverflow.ellipsis)),
                  8.widthBox,
                  Icon(Icons.arrow_forward_ios, color: context.theme.colorScheme.primaryColor2, size: 16.sp),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => 12.heightBox,
      itemCount: groupedKeys.length,
    );
  }
}
