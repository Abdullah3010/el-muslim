import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/extension/num_ext.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_library/quran_library.dart';

class WQuranLibraryBookmarksSheet extends StatelessWidget {
  const WQuranLibraryBookmarksSheet({super.key});

  static Future<BookmarkModel?> show(BuildContext context) {
    return showModalBottomSheet<BookmarkModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const WQuranLibraryBookmarksSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.sizeOf(context).height;
    final bookmarks = QuranRepository().getBookmarks();

    return Container(
      constraints: BoxConstraints(maxHeight: height * 0.8),
      decoration: BoxDecoration(
        color: theme.colorScheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(color: theme.colorScheme.lightGray, borderRadius: BorderRadius.circular(2.r)),
          ),
          Text('Bookmark'.translated, style: theme.textTheme.primary18W500),
          16.heightBox,
          Expanded(
            child:
                bookmarks.isEmpty
                    ? Center(child: Text('No bookmark'.translated, style: theme.textTheme.primary14W400))
                    : ListView.separated(
                      itemBuilder: (context, index) {
                        final bookmark = bookmarks[index];
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () => Navigator.of(context).pop(bookmark),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: BoxDecoration(color: Color(bookmark.colorCode), shape: BoxShape.circle),
                                  ),
                                  10.widthBox,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookmark.name,
                                          style: theme.textTheme.primary16W500,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        4.heightBox,
                                        Text(
                                          _buildSubtitle(bookmark),
                                          style: theme.textTheme.primary14W400,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  8.widthBox,
                                  Icon(Icons.arrow_forward_ios, size: 16.sp, color: theme.colorScheme.primaryColor),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => 10.heightBox,
                      itemCount: bookmarks.length,
                    ),
          ),
        ],
      ),
    );
  }

  String _buildSubtitle(BookmarkModel bookmark) {
    final parts = <String>[];
    if (bookmark.ayahNumber > 0) {
      parts.add('${'Ayah'.translated} ${bookmark.ayahNumber.toString().translateNumbers()}');
    }
    if (bookmark.page > 0) {
      parts.add('${'Page'.translated} ${bookmark.page.toString().translateNumbers()}');
    }
    return parts.join(' • ');
  }
}
