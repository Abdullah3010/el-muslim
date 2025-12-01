import 'dart:async';

import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';
import 'package:al_muslim/modules/quran/managers/mg_quran.dart';
import 'package:al_muslim/modules/quran/presentation/widgets/w_quran_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SnQuran extends StatefulWidget {
  const SnQuran({super.key, this.firstPage});

  final MQuranFirstPage? firstPage;

  @override
  State<SnQuran> createState() => _SnQuranState();
}

class _SnQuranState extends State<SnQuran> {
  late final MgQuran _mgQuran;
  late final PageController _pageController;
  late int _currentPageNumber;
  bool _controlsVisible = false;

  @override
  void initState() {
    super.initState();
    _mgQuran = Modular.get<MgQuran>();
    final initialPageNumber = widget.firstPage?.madani ?? 1;
    _mgQuran.initialize(initialPageNumber);
    _pageController = PageController(initialPage: _mgQuran.initialPageIndex);
    _currentPageNumber = initialPageNumber;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WSharedScaffold(
      appBar: WSharedAppBar(title: 'Quran'.translated),
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
                onTap: _toggleControls,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: _handlePageChanged,
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
                isVisible: _controlsVisible,
                currentPage: _currentPageNumber,
                bookmarkedPage: _mgQuran.bookmarkedPage,
                onBookmark: _saveBookmark,
                onGoToBookmark: _mgQuran.hasBookmark ? _goToBookmark : null,
              ),
            ],
          );
        },
      ),
    );
  }

  void _handlePageChanged(int index) {
    final pageNumber = _mgQuran.pageNumberAt(index);
    if (pageNumber != null) {
      setState(() => _currentPageNumber = pageNumber);
      unawaited(_mgQuran.saveLastPage(pageNumber));
    }

    final inserted = _mgQuran.maybePrefetchAround(index);
    if (inserted > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_pageController.hasClients) return;
        _pageController.jumpToPage(index + inserted);
      });
    }
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
  }

  Future<void> _saveBookmark() async {
    await _mgQuran.bookmarkPage(_currentPageNumber);
  }

  Future<void> _goToBookmark() async {
    final bookmark = _mgQuran.bookmarkedPage;
    if (bookmark == null) return;
    final index = _mgQuran.ensurePageVisible(bookmark);
    if (index == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_pageController.hasClients) return;
      _pageController.jumpToPage(index);
      setState(() => _currentPageNumber = bookmark);
    });
    await _mgQuran.saveLastPage(bookmark);
  }
}
