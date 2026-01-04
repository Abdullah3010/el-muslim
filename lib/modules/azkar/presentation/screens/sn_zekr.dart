import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_app_button.dart';
import 'package:al_muslim/core/widgets/w_gradient_progress_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/azkar/data/models/m_azkar_categories.dart';
import 'package:al_muslim/modules/azkar/managers/mg_azkar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SnZekr extends StatefulWidget {
  const SnZekr({super.key, required this.categoryId});

  final int categoryId;

  @override
  State<SnZekr> createState() => _SnZekrState();
}

class _SnZekrState extends State<SnZekr> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.get<MgAzkar>().loadAzkarByCategory(widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MgAzkar>(
      builder: (context, manager, _) {
        final category = manager.categories.firstWhere(
          (cat) => cat.id == widget.categoryId,
          orElse: () => MAzkarCategories(),
        );
        final showGroupedList = manager.isGroupedCategory && manager.selectedGroupedKey == null;
        final hasActiveAzkar = manager.activeAzkarList.isNotEmpty;
        final appBarTitle = manager.selectedGroupedKey ?? category.displayName;
        return WSharedScaffold(
          padding: EdgeInsets.zero,
          withSafeArea: false,
          appBar: WSharedAppBar(
            title: appBarTitle,
            action:
                manager.isGroupedCategory && manager.selectedGroupedKey != null
                    ? IconButton(
                      onPressed: () => manager.clearGroupedSelection(),
                      icon: const Icon(Icons.view_list),
                      color: context.theme.colorScheme.primaryColor,
                    )
                    : null,
          ),
          body:
              showGroupedList
                  ? _GroupedZekrList(groupedKeys: manager.groupedAzkarKeys, onSelect: manager.selectGroupedAzkar)
                  : hasActiveAzkar
                  ? _buildZekrReader(context, manager)
                  : const Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    );
  }

  Widget _buildZekrReader(BuildContext context, MgAzkar manager) {
    final isLastZekr = manager.currentZekrIndexNotifier >= manager.activeAzkarList.length - 1;
    final currentZekr = manager.activeAzkarList[manager.currentZekrIndexNotifier];
    final int maxCount = currentZekr.count ?? 0;
    final bool isCurrentComplete = maxCount > 0 && manager.currentZekrCount >= maxCount;
    final double progressValue =
        isLastZekr && isCurrentComplete ? 1 : manager.currentZekrIndexNotifier / manager.activeAzkarList.length;

    return GestureDetector(
      onTap: () {
        final currentIndex = manager.currentZekrIndexNotifier;
        final currentZekr = manager.activeAzkarList[currentIndex];
        if (currentZekr.count != null) {
          final int maxCount = currentZekr.count ?? 0;
          if (manager.currentZekrCount < maxCount) {
            manager.updateCurrentZekrCount(manager.currentZekrCount + 1);
            Future.delayed(const Duration(milliseconds: 150), () {
              if (manager.currentZekrCount >= maxCount) {
                final nextIndex = currentIndex + 1;
                if (nextIndex < manager.activeAzkarList.length) {
                  manager.updateCurrentZekrIndex(nextIndex);
                  manager.updateCurrentZekrCount(0);
                  manager.pageController.animateToPage(
                    nextIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
            });
          }
        }
      },

      child: Column(
        children: [
          16.heightBox,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: WGradientProgressBar(height: 10.h, value: progressValue),
          ),
          22.heightBox,
          Expanded(
            child: PageView.builder(
              itemCount: manager.activeAzkarList.length,
              onPageChanged: (index) {
                manager.updateCurrentZekrIndex(index);
                manager.updateCurrentZekrCount(0);
              },
              controller: manager.pageController,
              itemBuilder: (context, index) {
                final zekr = manager.activeAzkarList[index];
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        zekr.zekr ?? '',
                        style: context.theme.textTheme.white20W500,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    23.heightBox,
                    Text(
                      zekr.description?.displayDescription ?? '',
                      style: context.theme.textTheme.primary16W500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
          30.heightBox,
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                constraints: BoxConstraints(minWidth: 61.w, minHeight: 61.w),
                strokeWidth: 7.w,
                value:
                    manager.currentZekrCount /
                    (manager.activeAzkarList[manager.currentZekrIndexNotifier].count != null
                        ? manager.activeAzkarList[manager.currentZekrIndexNotifier].count ?? 0
                        : 1),
                color: context.theme.colorScheme.primaryColor,
              ),
              Positioned.fill(
                child: Center(child: Text('${manager.currentZekrCount}', style: context.theme.textTheme.primary16W500)),
              ),
            ],
          ),
          15.heightBox,
          Container(
            width: context.width,
            padding: EdgeInsets.only(bottom: 35.h, top: 15.h),
            decoration: BoxDecoration(color: context.theme.colorScheme.secondaryColor),
            child: Center(
              child: WAppButton(
                width: 300.w,
                title: (isLastZekr ? 'Finish' : 'Next').translated,
                radius: 50.r,
                withShadow: false,
                onTap: () {
                  if (manager.activeAzkarList.isEmpty) return;
                  if (isLastZekr) {
                    Modular.to.pop();
                    return;
                  }
                  final nextIndex = manager.currentZekrIndexNotifier + 1;
                  if (nextIndex < manager.activeAzkarList.length) {
                    manager.updateCurrentZekrCount(0);
                    manager.updateCurrentZekrIndex(nextIndex);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupedZekrList extends StatelessWidget {
  const _GroupedZekrList({required this.groupedKeys, required this.onSelect});

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
                  Icon(Icons.arrow_forward_ios, color: context.theme.colorScheme.primaryColor, size: 16.sp),
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
