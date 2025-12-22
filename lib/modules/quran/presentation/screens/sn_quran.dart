import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/extension/text_theme_extension.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';
import 'package:al_muslim/modules/quran/managers/mg_quran.dart';
import 'package:al_muslim/modules/quran/presentation/widgets/w_quran_bookmark_sheet.dart';
import 'package:al_muslim/modules/quran/presentation/widgets/w_quran_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SnQuran extends StatefulWidget {
  const SnQuran({super.key, this.firstPage});

  final MQuranFirstPage? firstPage;

  @override
  State<SnQuran> createState() => _SnQuranState();
}

class _SnQuranState extends State<SnQuran> {
  late final MgQuran _mgQuran;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _mgQuran = Modular.get<MgQuran>();
    final initialPageNumber = widget.firstPage?.madani ?? 1;
    _mgQuran.initialize(initialPageNumber);
    _pageController = PageController(initialPage: _mgQuran.initialPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      appBar: AnimatedBuilder(
        animation: _mgQuran,
        builder: (context, _) {
          final surah = _mgQuran.currentSurah;
          final title = surah == null ? 'Quran'.translated : (context.isRTL ? surah.name.ar : surah.name.en);
          return WSharedAppBar(
            title: title,
            action: Text(
              '${'Page'.translated} ${_mgQuran.currentPageNumber.toString().translateNumbers()}',
              style: context.textTheme.primary14W500,
            ),
          );
        },
      ),
      padding: EdgeInsets.zero,
      body: AnimatedBuilder(
        animation: _mgQuran,
        builder: (context, _) {
          if (!_mgQuran.hasPages) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final pages = _mgQuran.pages;

          return Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _mgQuran.toggleControls,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    final inserted = _mgQuran.handlePageChanged(index);
                    if (inserted > 0) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!_pageController.hasClients) return;
                        _pageController.jumpToPage(index + inserted);
                      });
                    }
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final pageNumber = pages[index];
                    return InteractiveViewer(
                      minScale: 1,
                      maxScale: 3,
                      child: Image.asset(
                        MgQuran.assetForPage(pageNumber),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    );
                  },
                ),
              ),
              WQuranControls(
                isVisible: _mgQuran.controlsVisible,
                currentPage: _mgQuran.currentPageNumber,
                currentJuz: _mgQuran.currentJuz,
                currentHizb: _mgQuran.currentHizb,
                currentQuarter: _mgQuran.currentQuarter,
                bookmarkedPage: _mgQuran.bookmarkedPage,
                onBookmark: () => _openBookmarkSheet(saveCurrentPage: true),
                onGoToBookmark: () => _openBookmarkSheet(saveCurrentPage: false),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openBookmarkSheet({required bool saveCurrentPage}) async {
    final selected = await WQuranBookmarkSheet.show(
      context,
      bookmarks: _mgQuran.bookmarkSlots,
      title: saveCurrentPage ? 'Bookmark'.translated : 'Go to bookmark'.translated,
    );
    if (selected == null) return;
    if (saveCurrentPage) {
      await _mgQuran.saveBookmarkSlot(selected, _mgQuran.currentPageNumber);
      return;
    }
    final index = await _mgQuran.goToBookmarkSlot(selected);
    if (index == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_pageController.hasClients) return;
      _pageController.jumpToPage(index);
    });
  }
}
