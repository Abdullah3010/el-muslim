import 'dart:math';

import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:flutter/material.dart';

class MgQuran extends ChangeNotifier {
  static const int totalPages = 604;
  static const int chunkSize = 10;
  static const int prefetchThreshold = 5;

  final List<int> _pages = [];
  int _minLoadedPage = totalPages;
  int _maxLoadedPage = 1;
  int _initialPage = 1;
  int? _bookmarkedPage;

  List<int> get pages => List.unmodifiable(_pages);
  int get initialPage => _initialPage;
  int? get bookmarkedPage => _bookmarkedPage;

  int get initialPageIndex {
    final index = _pages.indexOf(_initialPage);
    return index >= 0 ? index : 0;
  }

  bool get hasPages => _pages.isNotEmpty;
  bool get hasBookmark => _bookmarkedPage != null;
  bool get _canLoadForward => _maxLoadedPage < totalPages;
  bool get _canLoadBackward => _minLoadedPage > 1;

  void initialize(int initialPage) {
    final normalizedPage = initialPage.clamp(1, totalPages).toInt();
    _initialPage = normalizedPage;
    final startPage = max(1, normalizedPage - chunkSize);
    final endPage = min(totalPages, normalizedPage + chunkSize);
    _minLoadedPage = startPage;
    _maxLoadedPage = endPage;
    _pages
      ..clear()
      ..addAll(_generateRange(startPage, endPage));
    _loadPersistedBookmark();
    notifyListeners();
  }

  int maybePrefetchAround(int pageIndex) {
    int insertedAtStart = 0;
    var didUpdate = false;

    if (_canLoadForward && pageIndex >= _pages.length - prefetchThreshold) {
      final nextStart = _maxLoadedPage + 1;
      final nextEnd = min(totalPages, nextStart + chunkSize - 1);
      _pages.addAll(_generateRange(nextStart, nextEnd));
      _maxLoadedPage = nextEnd;
      didUpdate = true;
    }

    if (_canLoadBackward && pageIndex <= prefetchThreshold) {
      final previousEnd = _minLoadedPage - 1;
      final previousStart = max(1, previousEnd - chunkSize + 1);
      final newPages = _generateRange(previousStart, previousEnd);
      _pages.insertAll(0, newPages);
      _minLoadedPage = previousStart;
      insertedAtStart = newPages.length;
      didUpdate = true;
    }

    if (didUpdate) {
      notifyListeners();
    }

    return insertedAtStart;
  }

  int? ensurePageVisible(int pageNumber) {
    if (pageNumber < 1 || pageNumber > totalPages) return null;
    if (_pages.contains(pageNumber)) {
      return _pages.indexOf(pageNumber);
    }

    if (pageNumber < _minLoadedPage) {
      final newPages = _generateRange(pageNumber, _minLoadedPage - 1).toList();
      _pages.insertAll(0, newPages);
      _minLoadedPage = pageNumber;
    } else if (pageNumber > _maxLoadedPage) {
      final newPages = _generateRange(_maxLoadedPage + 1, pageNumber).toList();
      _pages.addAll(newPages);
      _maxLoadedPage = pageNumber;
    }

    notifyListeners();
    return _pages.indexOf(pageNumber);
  }

  int? pageNumberAt(int index) {
    if (index < 0 || index >= _pages.length) return null;
    return _pages[index];
  }

  Future<void> saveLastPage(int pageNumber) async {
    await DSAppConfig.setConfigValue(Constants.configKeys.quranLastPage, pageNumber.toString());
  }

  Future<void> bookmarkPage(int pageNumber) async {
    _bookmarkedPage = pageNumber;
    await DSAppConfig.setConfigValue(Constants.configKeys.quranBookmarkPage, pageNumber.toString());
    notifyListeners();
  }

  static String assetForPage(int pageNumber) => 'assets/quran_image/$pageNumber.png';

  void _loadPersistedBookmark() {
    final savedBookmark = DSAppConfig.getConfigValue(Constants.configKeys.quranBookmarkPage);
    _bookmarkedPage = int.tryParse(savedBookmark ?? '');
  }

  Iterable<int> _generateRange(int start, int end) sync* {
    if (end < start) return;
    for (var page = start; page <= end; page++) {
      yield page;
    }
  }
}
