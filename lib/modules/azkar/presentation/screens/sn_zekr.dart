import 'package:al_muslim/core/assets/assets.gen.dart';
import 'package:al_muslim/core/constants/constants.dart';
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
import 'package:al_muslim/modules/azkar/data/models/m_zekr.dart';
import 'package:al_muslim/modules/azkar/managers/mg_azkar.dart';
import 'package:al_muslim/modules/azkar/presentation/utils/azkar_count_formatter.dart';
import 'package:al_muslim/modules/azkar/presentation/widgets/w_grouped_zekr_list.dart';
import 'package:al_muslim/modules/azkar/presentation/widgets/w_other_azkar_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SnZekr extends StatefulWidget {
  const SnZekr({super.key, required this.categoryId});

  final int categoryId;

  @override
  State<SnZekr> createState() => _SnZekrState();
}

class _SnZekrState extends State<SnZekr> {
  final TextEditingController _searchController = TextEditingController();

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
        final bool isOtherAzkarCategory = widget.categoryId == 7;
        final showGroupedList = manager.isGroupedCategory && manager.selectedGroupedKey == null;
        final hasActiveAzkar = manager.activeAzkarList.isNotEmpty;
        final appBarTitle = manager.selectedGroupedKey ?? category.displayName;
        final bodyContent =
            showGroupedList
                ? WGroupedZekrList(groupedKeys: manager.groupedAzkarKeys, onSelect: manager.selectGroupedAzkar)
                : hasActiveAzkar
                ? _buildZekrReader(context, manager, category.displayName)
                : const Center(child: CircularProgressIndicator.adaptive());
        return WillPopScope(
          onWillPop: () async {
            if (manager.isGroupedCategory && manager.selectedGroupedKey != null) {
              manager.clearGroupedSelection();
              return false;
            }
            return true;
          },
          child: WSharedScaffold(
            padding: EdgeInsets.zero,
            withSafeArea: false,
            appBar: WSharedAppBar(
              title: appBarTitle,
              onBackTap: () {
                if (manager.isGroupedCategory && manager.selectedGroupedKey != null) {
                  manager.clearGroupedSelection();
                } else {
                  Modular.to.pop();
                }
              },
              action:
                  manager.isGroupedCategory && manager.selectedGroupedKey != null
                      ? IconButton(
                        onPressed: () => manager.clearGroupedSelection(),
                        icon: const Icon(Icons.view_list),
                        color: context.theme.colorScheme.primaryColor2,
                      )
                      : null,
            ),
            body:
                isOtherAzkarCategory
                    ? Column(
                      children: [
                        manager.isGroupedCategory && manager.selectedGroupedKey != null
                            ? const SizedBox.shrink()
                            : WOtherAzkarSearchField(
                              controller: _searchController,
                              onChanged: manager.updateOtherAzkarSearch,
                            ),
                        Expanded(child: bodyContent),
                      ],
                    )
                    : bodyContent,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildZekrReader(BuildContext context, MgAzkar manager, String categoryName) {
    final isLastZekr = manager.currentZekrIndexNotifier >= manager.activeAzkarList.length - 1;
    final currentZekr = manager.activeAzkarList[manager.currentZekrIndexNotifier];
    final int maxCount = currentZekr.count ?? 0;
    final bool isCurrentComplete = maxCount > 0 && manager.currentZekrCount >= maxCount;
    final double progressValue =
        isLastZekr && isCurrentComplete ? 1 : manager.currentZekrIndexNotifier / manager.activeAzkarList.length;
    final int effectiveMaxCount = maxCount <= 0 ? 1 : maxCount;

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
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: context.theme.colorScheme.secondaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        zekr.zekr ?? '',
                        style: context.theme.textTheme.primary18W500.copyWith(height: 2.1),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    23.heightBox,
                    Text(
                      zekr.fadelZeker?.join('\n') ?? '',
                      style: context.theme.textTheme.primary16W500,
                      textAlign: TextAlign.start,
                    ),
                  ],
                );
              },
            ),
          ),
          30.heightBox,
          Container(
            width: context.width,
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.r),
                      onTap: () => _shareCurrentZekr(manager, categoryName),
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Assets.icons.share.svg(
                          width: 22.w,
                          height: 22.w,
                          colorFilter: ColorFilter.mode(context.theme.colorScheme.primaryColor2, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
                CircularProgressIndicator(
                  constraints: BoxConstraints(minWidth: 61.w, minHeight: 61.w),
                  strokeWidth: 7.w,
                  value: manager.currentZekrCount / effectiveMaxCount,
                  color: context.theme.colorScheme.primaryColor,
                ),
                Positioned.fill(
                  child: Center(
                    child: Text('${manager.currentZekrCount}', style: context.theme.textTheme.primary16W500),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formatZekrCountText(maxCount),
                    style: context.theme.textTheme.primary16W500,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
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

  void _shareCurrentZekr(MgAzkar manager, String categoryName) {
    if (manager.activeAzkarList.isEmpty) return;
    final currentZekr = manager.activeAzkarList[manager.currentZekrIndexNotifier];
    final message = _buildShareMessage(zekr: currentZekr, categoryName: categoryName);
    Share.share(message, subject: categoryName);
  }

  String _buildShareMessage({required MZekr zekr, required String categoryName}) {
    final isArabic = LocalizeAndTranslate.getLanguageCode() == 'ar';
    final categoryLabel = isArabic ? 'التصنيف' : 'Category';
    final zekrLabel = isArabic ? 'الذكر' : 'Zekr';
    final fadelLabel = isArabic ? 'فضل الذكر' : 'Fadel Zekr';
    final countLabel = isArabic ? 'العدد' : 'Count';
    final linksLabel = isArabic ? 'روابط التطبيق' : 'App links';
    final fadelText = (zekr.fadelZeker ?? []).map((line) => line.trim()).where((line) => line.isNotEmpty).join('\n');
    final countText = formatZekrCountText(zekr.count ?? 0);

    List<String> parts = [
      '$categoryLabel: $categoryName',
      '$zekrLabel: ${zekr.zekr ?? '-'}',
      '$fadelLabel: ${fadelText.isEmpty ? '-' : fadelText}',
      '$countLabel: $countText',
      '$linksLabel:\n${Constants.androidAppLink}\n${Constants.iosAppLink}',
    ];
    parts.removeWhere((element) => element.contains('-'));

    return parts.join('\n\n');
  }
}
