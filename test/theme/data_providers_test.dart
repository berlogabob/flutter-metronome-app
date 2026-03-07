// Test file for MonoPulseTheme and data providers

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metronome_app/theme/mono_pulse_theme.dart';
import 'package:metronome_app/providers/data/data_providers.dart';
import 'package:metronome_app/models/song.dart';
import 'package:metronome_app/models/setlist.dart';

void main() {
  group('MonoPulseColors', () {
    test('base colors are defined', () {
      expect(MonoPulseColors.black, isA<Color>());
      expect(MonoPulseColors.blackSurface, isA<Color>());
      expect(MonoPulseColors.blackElevated, isA<Color>());
    });

    test('surface colors are defined', () {
      expect(MonoPulseColors.surface, isA<Color>());
      expect(MonoPulseColors.surfaceRaised, isA<Color>());
      expect(MonoPulseColors.surfaceOverlay, isA<Color>());
    });

    test('border colors are defined', () {
      expect(MonoPulseColors.borderSubtle, isA<Color>());
      expect(MonoPulseColors.borderDefault, isA<Color>());
      expect(MonoPulseColors.borderStrong, isA<Color>());
    });

    test('text colors are defined', () {
      expect(MonoPulseColors.textPrimary, isA<Color>());
      expect(MonoPulseColors.textHighEmphasis, isA<Color>());
      expect(MonoPulseColors.textSecondary, isA<Color>());
      expect(MonoPulseColors.textTertiary, isA<Color>());
      expect(MonoPulseColors.textDisabled, isA<Color>());
    });

    test('accent colors are defined', () {
      expect(MonoPulseColors.accentOrange, isA<Color>());
      expect(MonoPulseColors.accentOrangeLight, isA<Color>());
      expect(MonoPulseColors.accentOrangeDark, isA<Color>());
      expect(MonoPulseColors.accentOrangeSubtle, isA<Color>());
    });

    test('beat mode colors are defined', () {
      expect(MonoPulseColors.beatModeNormal, isA<Color>());
      expect(MonoPulseColors.beatModeAccent, isA<Color>());
      expect(MonoPulseColors.beatModeSilent, isA<Color>());
      expect(MonoPulseColors.beatModeNormalBright, isA<Color>());
      expect(MonoPulseColors.beatModeAccentBright, isA<Color>());
      expect(MonoPulseColors.beatModeSilentBright, isA<Color>());
    });

    test('error colors are defined', () {
      expect(MonoPulseColors.error, isA<Color>());
      expect(MonoPulseColors.errorSubtle, isA<Color>());
      expect(MonoPulseColors.errorSubtle5, isA<Color>());
      expect(MonoPulseColors.errorSubtle20, isA<Color>());
    });

    test('success colors are defined', () {
      expect(MonoPulseColors.success, isA<Color>());
      expect(MonoPulseColors.successAlt, isA<Color>());
      expect(MonoPulseColors.successGreen, isA<Color>());
      expect(MonoPulseColors.successGreenSubtle, isA<Color>());
    });

    test('warning colors are defined', () {
      expect(MonoPulseColors.warning, isA<Color>());
      expect(MonoPulseColors.warningSubtle, isA<Color>());
    });

    test('info colors are defined', () {
      expect(MonoPulseColors.info, isA<Color>());
      expect(MonoPulseColors.infoSubtle, isA<Color>());
    });

    test('role colors are defined', () {
      expect(MonoPulseColors.roleAdmin, isA<Color>());
      expect(MonoPulseColors.roleEditor, isA<Color>());
      expect(MonoPulseColors.roleViewer, isA<Color>());
    });

    test('match grade colors are defined', () {
      expect(MonoPulseColors.matchExact, isA<Color>());
      expect(MonoPulseColors.matchHigh, isA<Color>());
      expect(MonoPulseColors.matchMedium, isA<Color>());
      expect(MonoPulseColors.matchLow, isA<Color>());
      expect(MonoPulseColors.matchNone, isA<Color>());
    });

    test('specific color values are correct', () {
      // Black should be #000000
      expect(MonoPulseColors.black.value, 0xFF000000);
      
      // Accent orange should be #FF5E00
      expect(MonoPulseColors.accentOrange.value, 0xFFFF5E00);
      
      // Text primary should be #F5F5F5
      expect(MonoPulseColors.textPrimary.value, 0xFFF5F5F5);
      
      // Error should be #FF2D55
      expect(MonoPulseColors.error.value, 0xFFFF2D55);
    });

    test('beat mode colors have distinct values', () {
      // Normal (orange) != Accent (cyan) != Silent (magenta)
      expect(MonoPulseColors.beatModeNormal, isNot(equals(MonoPulseColors.beatModeAccent)));
      expect(MonoPulseColors.beatModeNormal, isNot(equals(MonoPulseColors.beatModeSilent)));
      expect(MonoPulseColors.beatModeAccent, isNot(equals(MonoPulseColors.beatModeSilent)));
    });
  });

  group('MonoPulseTheme', () {
    test('theme returns ThemeData', () {
      final theme = MonoPulseTheme.theme;
      expect(theme, isA<ThemeData>());
      expect(theme.brightness, Brightness.dark);
    });

    test('theme has correct scaffold color', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.scaffoldBackgroundColor, MonoPulseColors.black);
    });

    test('theme has correct primary color', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.primaryColor, MonoPulseColors.accentOrange);
    });

    test('theme has correct text theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.textTheme.bodyLarge?.color, MonoPulseColors.textPrimary);
    });

    test('theme has correct input decoration theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.inputDecorationTheme.fillColor, MonoPulseColors.surface);
    });

    test('theme has correct elevated button theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          MonoPulseColors.accentOrange);
    });

    test('theme has correct card theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.cardTheme.color, MonoPulseColors.surface);
    });

    test('theme has correct divider color', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.dividerTheme.color, MonoPulseColors.borderDefault);
    });

    test('theme has correct icon theme', () => () {
      final theme = MonoPulseTheme.theme;
      expect(theme.iconTheme.color, MonoPulseColors.textPrimary);
    });

    test('theme has correct appBar theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.appBarTheme.backgroundColor, MonoPulseColors.black);
    });

    test('theme has correct snackBar theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.snackBarTheme.backgroundColor, MonoPulseColors.surfaceRaised);
    });

    test('theme has correct floating action button theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.floatingActionButtonTheme?.backgroundColor,
          MonoPulseColors.accentOrange);
    });

    test('theme has correct chip theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.chipTheme.backgroundColor, MonoPulseColors.surfaceRaised);
    });

    test('theme has correct dialog theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.dialogTheme.backgroundColor, MonoPulseColors.surfaceRaised);
    });

    test('theme has correct bottom sheet theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.bottomSheetTheme.backgroundColor, MonoPulseColors.surfaceRaised);
    });

    test('theme has correct progress indicator theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.progressIndicatorTheme.color, MonoPulseColors.accentOrange);
    });

    test('theme has correct slider theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.sliderTheme.thumbColor, MonoPulseColors.accentOrange);
    });

    test('theme has correct switch theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.switchTheme.thumbColor?.resolve({}), MonoPulseColors.accentOrange);
    });

    test('theme has correct checkbox theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.checkboxTheme.fillColor?.resolve({}), MonoPulseColors.accentOrange);
    });

    test('theme has correct radio theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.radioTheme.fillColor?.resolve({}), MonoPulseColors.accentOrange);
    });

    test('theme has correct toggle buttons theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.toggleButtonsTheme.fillColor, MonoPulseColors.accentOrangeSubtle);
    });

    test('theme has correct banner theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.bannerTheme.backgroundColor, MonoPulseColors.surfaceRaised);
    });

    test('theme has correct navigation bar theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.navigationBarTheme.backgroundColor, MonoPulseColors.black);
    });

    test('theme has correct navigation rail theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.navigationRailTheme.backgroundColor, MonoPulseColors.black);
    });

    test('theme has correct tab bar theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.tabBarTheme.labelColor, MonoPulseColors.accentOrange);
    });

    test('theme has correct list tile theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.listTileTheme.textColor, MonoPulseColors.textPrimary);
    });

    test('theme has correct popup menu theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.popupMenuTheme.color, MonoPulseColors.surfaceRaised);
    });

    test('theme has correct tooltip theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.tooltipTheme.decoration, isA<BoxDecoration>());
    });

    test('theme has correct badge theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.badgeTheme.backgroundColor, MonoPulseColors.accentOrange);
    });

    test('theme has correct search bar theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.searchBarTheme.backgroundColor, MonoPulseColors.surface);
    });

    test('theme has correct search view theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.searchViewTheme.backgroundColor, MonoPulseColors.surface);
    });

    test('theme has correct menu bar theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.menuBarTheme, isA<MenuBarThemeData>());
    });

    test('theme has correct menu theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.menuTheme.style?.backgroundColor, MonoPulseColors.surfaceRaised);
    });
  });

  group('MonoPulseTypography', () {
    test('displayLarge is defined', () {
      expect(MonoPulseTypography.displayLarge, isA<TextStyle>());
    });

    test('displayMedium is defined', () {
      expect(MonoPulseTypography.displayMedium, isA<TextStyle>());
    });

    test('headlineLarge is defined', () {
      expect(MonoPulseTypography.headlineLarge, isA<TextStyle>());
    });

    test('headlineMedium is defined', () {
      expect(MonoPulseTypography.headlineMedium, isA<TextStyle>());
    });

    test('headlineSmall is defined', () {
      expect(MonoPulseTypography.headlineSmall, isA<TextStyle>());
    });

    test('titleLarge is defined', () {
      expect(MonoPulseTypography.titleLarge, isA<TextStyle>());
    });

    test('bodyLarge is defined', () {
      expect(MonoPulseTypography.bodyLarge, isA<TextStyle>());
    });

    test('bodyMedium is defined', () {
      expect(MonoPulseTypography.bodyMedium, isA<TextStyle>());
    });

    test('bodySmall is defined', () {
      expect(MonoPulseTypography.bodySmall, isA<TextStyle>());
    });

    test('labelLarge is defined', () {
      expect(MonoPulseTypography.labelLarge, isA<TextStyle>());
    });

    test('labelMedium is defined', () {
      expect(MonoPulseTypography.labelMedium, isA<TextStyle>());
    });

    test('labelSmall is defined', () {
      expect(MonoPulseTypography.labelSmall, isA<TextStyle>());
    });

    test('fontFamily is defined', () {
      expect(MonoPulseTypography.fontFamily, isA<String>());
    });

    test('fontFamilyDisplay is defined', () {
      expect(MonoPulseTypography.fontFamilyDisplay, isA<String>());
    });

    test('font weights are defined', () {
      expect(MonoPulseTypography.regular, isA<FontWeight>());
      expect(MonoPulseTypography.medium, isA<FontWeight>());
      expect(MonoPulseTypography.semibold, isA<FontWeight>());
      expect(MonoPulseTypography.bold, isA<FontWeight>());
    });
  });

  group('data providers', () {
    test('songsProvider is a StreamProvider', () {
      expect(songsProvider, isA<StreamProvider<List<Song>>>());
    });

    test('setlistsProvider is a StreamProvider', () {
      expect(setlistsProvider, isA<StreamProvider<List<Setlist>>>());
    });

    test('songsProvider returns empty list by default', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final songs = await container.read(songsProvider.future);
      expect(songs, isEmpty);
    });

    test('setlistsProvider returns empty list by default', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final setlists = await container.read(setlistsProvider.future);
      expect(setlists, isEmpty);
    });

    test('songsProvider can be overridden with mock data', () async {
      final mockSongs = [
        Song(
          id: '1',
          title: 'Song 1',
          artist: 'Artist 1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Song(
          id: '2',
          title: 'Song 2',
          artist: 'Artist 2',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          songsProvider.overrideWith((ref) => Stream.value(mockSongs)),
        ],
      );
      addTearDown(container.dispose);

      final songs = await container.read(songsProvider.future);
      expect(songs.length, 2);
      expect(songs.first.title, 'Song 1');
    });

    test('setlistsProvider can be overridden with mock data', () async {
      final mockSetlists = [
        Setlist(
          id: '1',
          bandId: 'band1',
          name: 'Setlist 1',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          setlistsProvider.overrideWith((ref) => Stream.value(mockSetlists)),
        ],
      );
      addTearDown(container.dispose);

      final setlists = await container.read(setlistsProvider.future);
      expect(setlists.length, 1);
      expect(setlists.first.name, 'Setlist 1');
    });
  });
}
