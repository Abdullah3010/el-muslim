import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WQuranBookmarkSheet extends StatelessWidget {
  const WQuranBookmarkSheet({super.key, required this.bookmarks, required this.title});

  final List<int> bookmarks;
  final String title;

  static const List<Color> bookmarkColors = [
    Color(0xFFE25D5D),
    Color(0xFFF2B857),
    Color(0xFF6FCF97),
    Color(0xFF56CCF2),
    Color(0xFFB68DE0),
  ];

  static Future<int?> show(
    BuildContext context, {
    required List<int> bookmarks,
    required String title,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WQuranBookmarkSheet(bookmarks: bookmarks, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalized = List<int>.filled(bookmarkColors.length, 0);
    for (var i = 0; i < bookmarkColors.length; i++) {
      if (i < bookmarks.length && bookmarks[i] > 0) {
        normalized[i] = bookmarks[i];
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: List.generate(bookmarkColors.length, (index) {
                final page = normalized[index];
                final label =
                    page > 0
                        ? '${'Page'.translated} ${page.toString().translateNumbers()}'
                        : 'No bookmark'.translated;
                return _BookmarkTile(
                  color: bookmarkColors[index],
                  label: label,
                  onTap: () => Navigator.of(context).pop(index),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  const _BookmarkTile({required this.color, required this.label, required this.onTap});

  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        width: 140.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.35)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(height: 8.h),
            Text(label, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
