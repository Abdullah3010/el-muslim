import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';

class WAdhanReminderPickerBottomSheet extends StatefulWidget {
  const WAdhanReminderPickerBottomSheet({super.key, this.initialIndex = 0});

  final int initialIndex;

  static const List<String> options = [
    'Before 5 minutes',
    'Before 10 minutes',
    'Before 15 minutes',
    'Before 20 minutes',
    'After 25 minutes',
    'After 30 minutes',
    'After 35 minutes',
  ];

  static Future<int?> show(BuildContext context, {int initialIndex = 0}) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WAdhanReminderPickerBottomSheet(initialIndex: initialIndex),
    );
  }

  @override
  State<WAdhanReminderPickerBottomSheet> createState() => _WAdhanReminderPickerBottomSheetState();
}

class _WAdhanReminderPickerBottomSheetState extends State<WAdhanReminderPickerBottomSheet> {
  late int _selectedIndex;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, WAdhanReminderPickerBottomSheet.options.length - 1).toInt();
    _scrollController = FixedExtentScrollController(initialItem: _selectedIndex);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    Navigator.of(context).pop(_selectedIndex);
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.r), topRight: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _onCancel,
                  child: Text(
                    'Cancel'.translated,
                    style: context.textTheme.primary16W500.copyWith(color: context.theme.colorScheme.red),
                  ),
                ),
                TextButton(
                  onPressed: _onConfirm,
                  child: Text('Confirm'.translated, style: context.textTheme.primary16W500),
                ),
              ],
            ),
            12.verticalSpace,
            SizedBox(
              height: 240.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 48.h,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primaryLightOrange,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    physics: const FixedExtentScrollPhysics(),
                    itemExtent: 48.h,
                    perspective: 0.002,
                    onSelectedItemChanged: (value) => setState(() => _selectedIndex = value),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: WAdhanReminderPickerBottomSheet.options.length,
                      builder: (context, index) {
                        if (index < 0 || index >= WAdhanReminderPickerBottomSheet.options.length) return null;
                        final bool isSelected = index == _selectedIndex;
                        final String option = WAdhanReminderPickerBottomSheet.options[index];
                        final TextStyle baseStyle =
                            isSelected
                                ? context.textTheme.primary18W500
                                : context.textTheme.primary16W400.copyWith(
                                  color: context.theme.colorScheme.primaryColor.withValues(alpha: 0.7),
                                );

                        return Center(child: Text(option.translated.translateNumbers(), style: baseStyle));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
