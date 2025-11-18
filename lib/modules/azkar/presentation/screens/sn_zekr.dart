import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_app_button.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
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
        return WSharedScaffold(
          padding: EdgeInsets.zero,
          appBar: WSharedAppBar(title: manager.categories.firstWhere((cat) => cat.id == widget.categoryId).displayName),
          body: GestureDetector(
            onTap: () {
              final currentIndex = manager.currentZekrIndexNotifier;
              final currentZekr = manager.activeAzkarList[currentIndex];
              if (currentZekr.count != null && currentZekr.count!.isNotEmpty) {
                final int maxCount = int.parse(currentZekr.count!);
                if (manager.currentZekrCount < maxCount) {
                  manager.updateCurrentZekrCount(manager.currentZekrCount + 1);
                } else {
                  // navigate to next zekr
                  if (currentIndex + 1 < manager.activeAzkarList.length) {
                    manager.updateCurrentZekrIndex(currentIndex + 1);
                    manager.updateCurrentZekrCount(0);
                  }
                }
              }
            },
            child: Column(
              children: [
                16.heightBox,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(8.r),
                    minHeight: 14.h,
                    value:
                        manager.currentZekrIndexNotifier /
                        (manager.activeAzkarList.isNotEmpty ? manager.activeAzkarList.length : 1),
                  ),
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
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13.w),
                        child: Column(
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
                        ),
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
                              ? int.parse(manager.activeAzkarList[manager.currentZekrIndexNotifier].count!)
                              : 1),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text('${manager.currentZekrCount}', style: context.theme.textTheme.primary16W500),
                      ),
                    ),
                  ],
                ),
                15.heightBox,
                WAppButton(title: 'Next'.translated, onTap: () {}),
              ],
            ),
          ),
        );
      },
    );
  }
}
