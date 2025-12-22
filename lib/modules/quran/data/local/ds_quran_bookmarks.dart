import 'package:al_muslim/modules/quran/data/local/box_quran_bookmarks.dart';

class DSQuranBookmarks {
  DSQuranBookmarks(this._box);

  static const int slots = 5;
  static const String _bookmarksKey = 'bookmark_slots';

  final BoxQuranBookmarks _box;

  Map<String, dynamic>? _raw() {
    final value = _box.box.get(_bookmarksKey);
    if (value is Map) {
      return Map<String, dynamic>.from(value.cast<String, dynamic>());
    }
    return null;
  }

  List<int> getBookmarks() {
    final raw = _raw();
    final stored = raw?['pages'];
    final normalized = List<int>.filled(slots, 0);
    if (stored is List) {
      for (var i = 0; i < slots; i++) {
        final value = i < stored.length ? stored[i] : null;
        final parsed = value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
        normalized[i] = parsed;
      }
    }
    return normalized;
  }

  Future<void> saveBookmarks(List<int> pages) async {
    final normalized = List<int>.filled(slots, 0);
    for (var i = 0; i < slots; i++) {
      if (i < pages.length && pages[i] > 0) {
        normalized[i] = pages[i];
      }
    }
    await _box.box.put(_bookmarksKey, {'pages': normalized});
  }

  Future<void> clear() async {
    await _box.box.delete(_bookmarksKey);
  }
}
