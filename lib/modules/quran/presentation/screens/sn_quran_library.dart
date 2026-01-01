import 'package:al_muslim/core/extension/build_context.dart';
import 'package:al_muslim/core/extension/string_extensions.dart';
import 'package:al_muslim/core/widgets/w_shared_app_bar.dart';
import 'package:al_muslim/core/widgets/w_shared_scaffold.dart';
import 'package:al_muslim/modules/index/data/models/m_quran_index.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:quran_library/quran_library.dart';
// ignore: implementation_imports
import 'package:quran_library/src/audio/audio.dart' as ql_audio;

class SnQuranLibrary extends StatefulWidget {
  const SnQuranLibrary({super.key, this.firstPage});

  final MQuranFirstPage? firstPage;

  @override
  State<SnQuranLibrary> createState() => _SnQuranLibraryState();
}

class _SnQuranLibraryState extends State<SnQuranLibrary> {
  bool _didJumpToPage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didJumpToPage) return;
    final pageNumber = widget.firstPage?.madani;
    if (pageNumber == null || pageNumber <= 0) return;
    _didJumpToPage = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      QuranLibrary().jumpToPage(pageNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final colorScheme = context.theme.colorScheme;
    final surfaceColor = colorScheme.surface;
    final textColor = colorScheme.onSurface;
    final primaryColor = colorScheme.primary;
    final secondaryColor = colorScheme.secondary;
    final mutedTextColor = textColor.withValues(alpha: 0.7);
    final dividerColor = colorScheme.outline.withValues(alpha: 0.3);
    final shadowColor = context.theme.shadowColor.withValues(alpha: 0.2);
    final selectionColor = primaryColor.withValues(alpha: 0.2);
    final selectedItemColor = primaryColor.withValues(alpha: 0.12);
    final titleStyle = context.textTheme.titleMedium?.copyWith(color: textColor);
    final bodyStyle = context.textTheme.bodyMedium?.copyWith(color: textColor);
    final noteStyle = context.textTheme.bodySmall?.copyWith(color: mutedTextColor);
    final defaultTopBarStyle = QuranTopBarStyle.defaults(isDark: isDark);
    final defaultSurahInfoStyle = SurahInfoStyle.defaults(isDark: isDark);

    return WSharedScaffold(
      appBar: WSharedAppBar(title: 'Quran'.translated),
      padding: EdgeInsets.zero,
      body: QuranLibraryScreen(
        parentContext: context,
        useDefaultAppBar: true,
        withPageView: true,
        isDark: isDark,
        languageCode: context.locale.languageCode,
        backgroundColor: Colors.transparent,
        textColor: textColor,
        ayahSelectedBackgroundColor: selectionColor,
        ayahSelectedFontColor: colorScheme.onPrimary,
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
          backgroundColor: surfaceColor,
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
          showMenuButton: defaultTopBarStyle.showMenuButton,
          showAudioButton: defaultTopBarStyle.showAudioButton,
          showFontsButton: defaultTopBarStyle.showFontsButton,
          showBackButton: defaultTopBarStyle.showBackButton,
        ),
      ),
    );
  }
}
