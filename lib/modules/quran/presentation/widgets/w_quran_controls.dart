import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/widgets/w_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WQuranControls extends StatelessWidget {
  const WQuranControls({
    super.key,
    required this.isVisible,
    required this.currentPage,
    required this.currentJuz,
    required this.currentHizb,
    required this.currentQuarter,
    required this.onBookmark,
    required this.bookmarkedPage,
    this.onGoToBookmark,
  });

  final bool isVisible;
  final int currentPage;
  final int currentJuz;
  final int currentHizb;
  final int currentQuarter;
  final VoidCallback onBookmark;
  final int? bookmarkedPage;
  final VoidCallback? onGoToBookmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookmarkLabel =
        bookmarkedPage == null
            ? 'No bookmark'.translated
            : '${'Bookmark'.translated}: ${bookmarkedPage!.toString().translateNumbers()}';
    final infoLabel =
        '${'Juz'.translated} ${currentJuz.toString().translateNumbers()} | '
        '${'Hizb'.translated} ${currentHizb.toString().translateNumbers()} | '
        '${'Quarter'.translated} ${currentQuarter.toString().translateNumbers()}';

    return Align(
      alignment: Alignment.bottomCenter,
      child: IgnorePointer(
        ignoring: !isVisible,
        child: AnimatedSlide(
          offset: isVisible ? Offset.zero : const Offset(0, 1),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isVisible ? 1 : 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Material(
                color: theme.colorScheme.secondaryColor,
                borderRadius: BorderRadius.circular(16.r),
                elevation: 4.r,
                shadowColor: theme.colorScheme.black.withValues(alpha: 0.35),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${'Page'.translated} ${currentPage.toString().translateNumbers()}',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(infoLabel, style: theme.textTheme.bodyMedium),
                                const SizedBox(height: 2),
                                Text(bookmarkLabel, style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: onBookmark,
                            icon: const Icon(Icons.bookmark_add_outlined),
                            tooltip: 'Bookmark current page'.translated,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Center(child: WAppButton(title: 'Go to bookmark'.translated, onTap: onGoToBookmark)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
