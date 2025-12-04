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
                bookmarkedPage: _mgQuran.bookmarkedPage,
                onBookmark: _mgQuran.bookmarkCurrentPage,
                onGoToBookmark: _mgQuran.hasBookmark ? () async => _jumpToBookmark() : null,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _jumpToBookmark() async {
    final index = await _mgQuran.goToBookmark();
    if (index == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_pageController.hasClients) return;
      _pageController.jumpToPage(index);
    });
  }
}
