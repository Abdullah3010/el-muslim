import 'dart:async';
import 'dart:math';

import 'package:al_muslim/core/config/box_app_config/ds_app_config.dart';
import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/routes/routes_names.dart';
import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';
import 'package:al_muslim/modules/index/managers/mg_index.dart';
import 'package:al_muslim/modules/quran/data/local/box_quran_bookmarks.dart';
import 'package:al_muslim/modules/quran/data/local/ds_quran_bookmarks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MgQuran extends ChangeNotifier {
  MgQuran({BoxQuranBookmarks? bookmarksBox, DSQuranBookmarks? bookmarksStore})
    : _bookmarksBox = bookmarksBox ?? BoxQuranBookmarks() {
    _bookmarksStore = bookmarksStore ?? DSQuranBookmarks(_bookmarksBox);
  }

  static const int totalPages = 604;
  static const int chunkSize = 10;
  static const int prefetchThreshold = 5;
  static const List<int> _juzStartPages = [
    1,
    22,
    42,
    62,
    82,
    102,
    122,
    142,
    162,
    182,
    202,
    222,
    242,
    262,
    282,
    302,
    322,
    342,
    362,
    382,
    402,
    422,
    442,
    462,
    482,
    502,
    522,
    542,
    562,
    582,
  ];

  final List<int> _pages = [];
  final List<MQuranIndex> _surahs = [];
  int _minLoadedPage = totalPages;
  int _maxLoadedPage = 1;
  int _initialPage = 1;
  int _currentPageNumber = 1;
  int _currentJuz = 1;
  int _currentHizb = 1;
  int _currentQuarter = 1;
  bool _controlsVisible = false;
  bool _isLoadingSurahs = false;
  bool _isListeningForSurahs = false;
  int? _bookmarkedPage;
  List<int> _bookmarkSlots = List<int>.filled(DSQuranBookmarks.slots, 0);
  final BoxQuranBookmarks _bookmarksBox;
  late final DSQuranBookmarks _bookmarksStore;
  bool _bookmarksBoxReady = false;
  MQuranIndex? _currentSurah;

  List<int> get pages => List.unmodifiable(_pages);
  int get initialPage => _initialPage;
  int get currentPageNumber => _currentPageNumber;
  int get currentJuz => _currentJuz;
  int get currentHizb => _currentHizb;
  int get currentQuarter => _currentQuarter;
  bool get controlsVisible => _controlsVisible;
  int? get bookmarkedPage => _bookmarkedPage;
  MQuranIndex? get currentSurah => _currentSurah;
  List<int> get bookmarkSlots => List.unmodifiable(_bookmarkSlots);

  int get initialPageIndex {
    final index = _pages.indexOf(_initialPage);
    return index >= 0 ? index : 0;
  }

  bool get hasPages => _pages.isNotEmpty;
  bool get hasBookmarks => _bookmarkSlots.any((page) => page > 0);
  bool get hasBookmark => hasBookmarks;
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
    unawaited(_loadPersistedBookmarks());
    _setCurrentPage(normalizedPage);
    unawaited(_ensureSurahIndexLoaded());
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

  int handlePageChanged(int index) {
    final pageNumber = pageNumberAt(index);
    if (pageNumber != null) {
      _setCurrentPage(pageNumber);
      unawaited(saveLastPage(pageNumber));
      notifyListeners();
    }

    return maybePrefetchAround(index);
  }

  void toggleControls() {
    _controlsVisible = !_controlsVisible;
    notifyListeners();
  }

  Future<void> bookmarkCurrentPage() => saveBookmarkSlot(0, _currentPageNumber);

  Future<int?> goToBookmark() => goToBookmarkSlot(0);

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

  int? bookmarkAtSlot(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= _bookmarkSlots.length) return null;
    final page = _bookmarkSlots[slotIndex];
    return page > 0 ? page : null;
  }

  Future<void> saveBookmarkSlot(int slotIndex, int pageNumber) async {
    if (slotIndex < 0 || slotIndex >= _bookmarkSlots.length) return;
    await _ensureBookmarksStoreReady();
    _bookmarkSlots[slotIndex] = pageNumber.clamp(1, totalPages);
    _bookmarkedPage = _bookmarkSlots[slotIndex];
    await _bookmarksStore.saveBookmarks(_bookmarkSlots);
    notifyListeners();
  }

  Future<int?> goToBookmarkSlot(int slotIndex) async {
    final page = bookmarkAtSlot(slotIndex);
    if (page == null) return null;
    final index = ensurePageVisible(page);
    if (index != null) {
      _setCurrentPage(page);
      _bookmarkedPage = page;
      await saveLastPage(page);
      notifyListeners();
    }
    return index;
  }

  Future<void> bookmarkPage(int pageNumber) async {
    await saveBookmarkSlot(0, pageNumber);
  }

  Future<void> _ensureBookmarksStoreReady() async {
    if (_bookmarksBoxReady) return;
    await _bookmarksBox.init();
    _bookmarksBoxReady = true;
  }

  int? _firstSavedBookmark() {
    for (final page in _bookmarkSlots) {
      if (page > 0) return page;
    }
    return null;
  }

  static String assetForPage(int pageNumber) => 'assets/quran_image/$pageNumber.png';

  Future<void> _loadPersistedBookmarks() async {
    await _ensureBookmarksStoreReady();
    _bookmarkSlots = _bookmarksStore.getBookmarks();

    final savedBookmark = DSAppConfig.getConfigValue(Constants.configKeys.quranBookmarkPage);
    final legacyPage = int.tryParse(savedBookmark ?? '');
    if (legacyPage != null && legacyPage > 0 && !_bookmarkSlots.any((page) => page > 0)) {
      _bookmarkSlots[0] = legacyPage;
      await _bookmarksStore.saveBookmarks(_bookmarkSlots);
    }

    _bookmarkedPage = _firstSavedBookmark();
    notifyListeners();
  }

  Iterable<int> _generateRange(int start, int end) sync* {
    if (end < start) return;
    for (var page = start; page <= end; page++) {
      yield page;
    }
  }

  void openQuranFromBookmark() {
    unawaited(_openFromSavedBookmark());
  }

  Future<void> _openFromSavedBookmark() async {
    await _loadPersistedBookmarks();
    final bookmark = _firstSavedBookmark() ?? _currentPageNumber;
    ensurePageVisible(bookmark);
    _setCurrentPage(bookmark);
    notifyListeners();

    final firstPage = MQuranFirstPage(madani: bookmark, indopak: bookmark);
    Modular.to.pushNamed(RoutesNames.quran.quranMain, arguments: firstPage);
  }

  Future<void> _ensureSurahIndexLoaded() async {
    if (_isLoadingSurahs || _surahs.isNotEmpty) return;
    _isLoadingSurahs = true;
    try {
      final mgIndex = Modular.get<MgIndex>();
      if (!mgIndex.hasData) {
        await mgIndex.loadIndex();
      }
      if (mgIndex.hasData) {
        _surahs
          ..clear()
          ..addAll(mgIndex.surahs);
        _updateCurrentSurah();
        notifyListeners();
      } else {
        _listenForSurahIndex(mgIndex);
      }
    } finally {
      _isLoadingSurahs = false;
    }
  }

  void _listenForSurahIndex(MgIndex mgIndex) {
    if (_isListeningForSurahs) return;
    _isListeningForSurahs = true;
    void listener() {
      if (!mgIndex.hasData) return;
      mgIndex.removeListener(listener);
      _isListeningForSurahs = false;
      _surahs
        ..clear()
        ..addAll(mgIndex.surahs);
      _updateCurrentSurah();
      notifyListeners();
    }

    mgIndex.addListener(listener);
  }

  void _updateCurrentSurah({int? pageNumber}) {
    if (_surahs.isEmpty) {
      unawaited(_ensureSurahIndexLoaded());
      return;
    }

    final page = pageNumber ?? _currentPageNumber;
    MQuranIndex? next;
    for (final surah in _surahs) {
      if (surah.firstPage.madani <= page) {
        next = surah;
      } else {
        break;
      }
    }
    _currentSurah = next ?? _surahs.first;
  }

  int _juzForPage(int pageNumber) {
    for (var i = 0; i < _juzStartPages.length; i++) {
      final start = _juzStartPages[i];
      final nextStart = i + 1 < _juzStartPages.length ? _juzStartPages[i + 1] : totalPages + 1;
      if (pageNumber >= start && pageNumber < nextStart) {
        return i + 1;
      }
    }
    return 1;
  }

  void _setCurrentPage(int pageNumber) {
    _currentPageNumber = pageNumber;
    _currentJuz = _juzForPage(pageNumber);
    _setHizbAndQuarter(pageNumber);
    _updateCurrentSurah(pageNumber: pageNumber);
  }

  void _setHizbAndQuarter(int pageNumber) {
    final juzIndex = _currentJuz - 1;
    final juzStart = _juzStartPages[juzIndex];
    final juzEnd = (juzIndex + 1 < _juzStartPages.length) ? _juzStartPages[juzIndex + 1] - 1 : totalPages;
    final juzLength = max(1, juzEnd - juzStart + 1);
    final offset = pageNumber - juzStart;
    final quarterIndex = (offset * 8) ~/ juzLength;
    final boundedQuarterIndex = max(0, min(7, quarterIndex));
    _currentHizb = (juzIndex * 2) + (boundedQuarterIndex ~/ 4) + 1;
    _currentQuarter = (boundedQuarterIndex % 4) + 1;
  }
}
