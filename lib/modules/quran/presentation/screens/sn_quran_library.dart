import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/color_extension.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:quran_library/quran_library.dart';
// ignore: implementation_imports
import 'package:quran_library/src/audio/audio.dart' as ql_audio;

class SnQuranLibrary extends StatefulWidget {
  const SnQuranLibrary({super.key, this.firstPage, this.surahNumber, this.bookmark});

  final MQuranFirstPage? firstPage;
  final int? surahNumber;
  final BookmarkModel? bookmark;

  @override
  State<SnQuranLibrary> createState() => _SnQuranLibraryState();
}

class _SnQuranLibraryState extends State<SnQuranLibrary> {
  String? _lastJumpKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jumpToTarget();
  }

  @override
  void didUpdateWidget(covariant SnQuranLibrary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bookmark?.id != widget.bookmark?.id ||
        oldWidget.surahNumber != widget.surahNumber ||
        oldWidget.firstPage?.madani != widget.firstPage?.madani) {
      _jumpToTarget(force: true);
    }
  }

  void _jumpToTarget({bool force = false}) {
    final bookmark = widget.bookmark;
    final surahNumber = widget.surahNumber;
    final pageNumber = widget.firstPage?.madani;
    final targetKey =
        bookmark != null
            ? 'bookmark:${bookmark.id}'
            : surahNumber != null
            ? 'surah:$surahNumber'
            : (pageNumber != null ? 'page:$pageNumber' : null);
    if (targetKey == null) return;
    if (!force && _lastJumpKey == targetKey) return;
    _lastJumpKey = targetKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (bookmark != null) {
        QuranLibrary().jumpToBookmark(bookmark);
        return;
      }
      if (surahNumber != null && surahNumber > 0) {
        QuranLibrary().jumpToSurah(surahNumber);
        return;
      }
      if (pageNumber != null && pageNumber > 0) {
        QuranLibrary().jumpToPage(pageNumber);
      }
    });
  }

  @override
  void dispose() {
    _resetScreenUtil();
    super.dispose();
  }

  void _resetScreenUtil() {
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    if (view == null) return;
    ScreenUtil.enableScale(enableText: () => false, enableWH: () => false);
    ScreenUtil.configure(
      data: MediaQueryData.fromView(view),
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final colorScheme = context.theme.colorScheme;
    final primaryColor = colorScheme.darkPrimary;
    final secondaryColor = colorScheme.primaryLightOrange;
    final surfaceColor = colorScheme.white;
    final textColor = colorScheme.black;
    final mutedTextColor = textColor.withValues(alpha: 0.7);
    final dividerColor = primaryColor.withValues(alpha: 0.2);
    final shadowColor = primaryColor.withValues(alpha: 0.2);
    final selectionColor = secondaryColor.withValues(alpha: 0.6);
    final selectedItemColor = secondaryColor.withValues(alpha: 0.6);
    final titleStyle = context.textTheme.titleMedium?.copyWith(color: textColor);
    final bodyStyle = context.textTheme.bodyMedium?.copyWith(color: textColor);
    final noteStyle = context.textTheme.bodySmall?.copyWith(color: mutedTextColor);
    final defaultTopBarStyle = QuranTopBarStyle.defaults(isDark: isDark);
    final defaultSurahInfoStyle = SurahInfoStyle.defaults(isDark: isDark);

    return WSharedScaffold(
      // appBar: WSharedAppBar(title: 'Quran'.translated),
      padding: EdgeInsets.zero,
      body: QuranLibraryScreen(
        parentContext: context,
        useDefaultAppBar: true,
        withPageView: true,
        isDark: isDark,
        languageCode: context.locale.languageCode,
        backgroundColor: Colors.white,
        textColor: textColor,
        ayahSelectedBackgroundColor: selectionColor,
        ayahSelectedFontColor: textColor,
        ayahIconColor: primaryColor,
        bookmarksColor: primaryColor,
        singleAyahTextColors: [textColor, primaryColor, secondaryColor],
        basmalaStyle: BasmalaStyle(basmalaColor: textColor),
        surahNameStyle: SurahNameStyle(surahNameColor: textColor, surahNameSize: 24),
        surahInfoStyle: SurahInfoStyle(
          ayahCount: defaultSurahInfoStyle.ayahCount,
          secondTabText: defaultSurahInfoStyle.secondTabText,
          firstTabText: defaultSurahInfoStyle.firstTabText,
          backgroundColor: surfaceColor,
          closeIconColor: textColor,
          surahNameColor: textColor,
          surahNumberColor: textColor,
          primaryColor: selectedItemColor,
          titleColor: textColor,
          indicatorColor: selectionColor,
          textColor: textColor,
        ),
        downloadFontsDialogStyle: DownloadFontsDialogStyle(
          backgroundColor: surfaceColor,
          dividerColor: dividerColor,
          downloadButtonBackgroundColor: primaryColor,
          iconColor: primaryColor,
          linearProgressBackgroundColor: dividerColor,
          linearProgressColor: primaryColor,
          notesColor: mutedTextColor,
          titleColor: textColor,
          titleStyle: titleStyle,
          fontNameStyle: bodyStyle,
          downloadingStyle: bodyStyle,
          notesStyle: noteStyle,
        ),
        ayahStyle: ql_audio.AyahAudioStyle(
          textColor: textColor,
          playIconColor: primaryColor,
          readerNameInItemColor: mutedTextColor,
          seekBarThumbColor: primaryColor,
          seekBarActiveTrackColor: primaryColor,
          seekBarInactiveTrackColor: dividerColor,
          backgroundColor: surfaceColor,
          dialogBackgroundColor: surfaceColor,
        ),
        surahStyle: ql_audio.SurahAudioStyle(
          textColor: textColor,
          playIconColor: primaryColor,
          readerNameInItemColor: mutedTextColor,
          seekBarThumbColor: primaryColor,
          seekBarActiveTrackColor: primaryColor,
          seekBarInactiveTrackColor: dividerColor,
          backgroundColor: surfaceColor,
          dialogBackgroundColor: surfaceColor,
          selectedItemColor: selectedItemColor,
          secondaryIconColor: mutedTextColor,
          secondaryTextColor: mutedTextColor,
          primaryColor: primaryColor,
          iconColor: primaryColor,
          audioSliderBackgroundColor: surfaceColor,
          surahNameColor: textColor,
        ),
        topBarStyle: QuranTopBarStyle(
          backIconPath: defaultTopBarStyle.backIconPath,
          menuIconPath: defaultTopBarStyle.menuIconPath,
          audioIconPath: defaultTopBarStyle.audioIconPath,
          optionsIconPath: defaultTopBarStyle.optionsIconPath,
          backgroundColor: colorScheme.white,
          textColor: textColor,
          accentColor: primaryColor,
          shadowColor: shadowColor,
          handleColor: dividerColor,
          elevation: defaultTopBarStyle.elevation,
          borderRadius: defaultTopBarStyle.borderRadius,
          padding: defaultTopBarStyle.padding,
          height: defaultTopBarStyle.height,
          iconSize: defaultTopBarStyle.iconSize,
          iconColor: primaryColor,
          fontsDialogTitle: defaultTopBarStyle.fontsDialogTitle,
          fontsDialogNotes: defaultTopBarStyle.fontsDialogNotes,
          fontsDialogDownloadingText: defaultTopBarStyle.fontsDialogDownloadingText,
          tabIndexLabel: defaultTopBarStyle.tabIndexLabel,
          tabSearchLabel: defaultTopBarStyle.tabSearchLabel,
          tabBookmarksLabel: defaultTopBarStyle.tabBookmarksLabel,
          tabSurahsLabel: defaultTopBarStyle.tabSurahsLabel,
          tabJozzLabel: defaultTopBarStyle.tabJozzLabel,
          showMenuButton: true,
          showAudioButton: false,
          showFontsButton: false,
          showBackButton: true,
        ),
      ),
    );
  }
}
