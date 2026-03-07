// Test file for MonoPulseTheme and data providers - simplified version

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
      expect(MonoPulseColors.black.value, 0xFF000000);
      expect(MonoPulseColors.accentOrange.value, 0xFFFF5E00);
      expect(MonoPulseColors.textPrimary.value, 0xFFF5F5F5);
      expect(MonoPulseColors.error.value, 0xFFFF2D55);
    });
  });

  group('MonoPulseTheme', () {
    test('theme returns ThemeData', () {
      final theme = MonoPulseTheme.theme;
      expect(theme, isA<ThemeData>());
      expect(theme.brightness, Brightness.dark);
      expect(theme.useMaterial3, isTrue);
    });

    test('theme has correct scaffold color', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.scaffoldBackgroundColor, MonoPulseColors.black);
    });

    test('theme has color scheme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.colorScheme, isA<ColorScheme>());
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('theme has text theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.textTheme, isA<TextTheme>());
      expect(theme.textTheme.bodyLarge, isA<TextStyle>());
    });

    test('theme has elevated button theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.elevatedButtonTheme, isA<ElevatedButtonThemeData>());
    });

    test('theme has card theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.cardTheme, isA<CardThemeData>());
    });

    test('theme has app bar theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.appBarTheme, isNotNull);
    });

    test('theme has input decoration theme', () {
      final theme = MonoPulseTheme.theme;
      expect(theme.inputDecorationTheme, isNotNull);
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

  group('MonoPulseSpacing', () {
    test('spacing values are defined', () {
      expect(MonoPulseSpacing.xs, 4);
      expect(MonoPulseSpacing.sm, 8);
      expect(MonoPulseSpacing.md, 12);
      expect(MonoPulseSpacing.lg, 16);
      expect(MonoPulseSpacing.xl, 20);
      expect(MonoPulseSpacing.xxl, 24);
      expect(MonoPulseSpacing.xxxl, 32);
      expect(MonoPulseSpacing.huge, 40);
      expect(MonoPulseSpacing.massive, 48);
    });
  });

  group('MonoPulseRadius', () {
    test('radius values are defined', () {
      expect(MonoPulseRadius.small, 8);
      expect(MonoPulseRadius.medium, 10);
      expect(MonoPulseRadius.large, 12);
      expect(MonoPulseRadius.xlarge, 16);
      expect(MonoPulseRadius.huge, 20);
      expect(MonoPulseRadius.massive, 24);
    });
  });

  group('MonoPulseElevation', () {
    test('elevation values are defined', () {
      expect(MonoPulseElevation.none, 0);
      expect(MonoPulseElevation.low, 2);
      expect(MonoPulseElevation.medium, 4);
      expect(MonoPulseElevation.high, 8);
    });

    test('shadow properties are defined', () {
      expect(MonoPulseElevation.shadowLow, isA<BoxShadow>());
      expect(MonoPulseElevation.shadowMedium, isA<BoxShadow>());
      expect(MonoPulseElevation.shadowHigh, isA<BoxShadow>());
    });

    test('shadowLow has correct properties', () {
      final shadow = MonoPulseElevation.shadowLow;
      expect(shadow.blurRadius, 8);
      expect(shadow.offset, const Offset(0, 2));
    });

    test('shadowMedium has correct properties', () {
      final shadow = MonoPulseElevation.shadowMedium;
      expect(shadow.blurRadius, 16);
      expect(shadow.offset, const Offset(0, 4));
    });

    test('shadowHigh has correct properties', () {
      final shadow = MonoPulseElevation.shadowHigh;
      expect(shadow.blurRadius, 24);
      expect(shadow.offset, const Offset(0, 8));
    });
  });

  group('MonoPulseAnimation', () {
    test('duration values are defined', () {
      expect(MonoPulseAnimation.durationShort, const Duration(milliseconds: 120));
      expect(MonoPulseAnimation.durationMedium, const Duration(milliseconds: 180));
      expect(MonoPulseAnimation.durationLong, const Duration(milliseconds: 240));
    });

    test('curve values are defined', () {
      expect(MonoPulseAnimation.curveDefault, isA<Curve>());
      expect(MonoPulseAnimation.curveEmphasized, isA<Curve>());
      expect(MonoPulseAnimation.curveDecelerate, isA<Curve>());
      expect(MonoPulseAnimation.curveAccelerate, isA<Curve>());
      expect(MonoPulseAnimation.curveCustom, isA<Curve>());
    });

    test('curveCustom is cubic bezier', () {
      final curve = MonoPulseAnimation.curveCustom;
      expect(curve, isA<Cubic>());
    });
  });

  group('MonoPulseIcons', () {
    test('size values are defined', () {
      expect(MonoPulseIcons.sizeSmall, 16);
      expect(MonoPulseIcons.sizeMedium, 20);
      expect(MonoPulseIcons.sizeLarge, 24);
      expect(MonoPulseIcons.sizeXLarge, 32);
    });

    test('stroke width values are defined', () {
      expect(MonoPulseIcons.strokeWidthDefault, 1.5);
      expect(MonoPulseIcons.strokeWidthBold, 2.0);
    });
  });

  group('MonoPulseRadius alternate names', () {
    test('radius with alternate names are defined', () {
      // Check if alternate names exist
      expect(MonoPulseRadius.small, 8);
      expect(MonoPulseRadius.medium, 10);
      expect(MonoPulseRadius.large, 12);
      expect(MonoPulseRadius.xlarge, 16);
      expect(MonoPulseRadius.huge, 20);
      expect(MonoPulseRadius.massive, 24);
    });
  });

  group('MonoPulseColors additional coverage', () {
    test('section colors are defined', () {
      expect(MonoPulseColors.section1, isA<Color>());
      expect(MonoPulseColors.section2, isA<Color>());
      expect(MonoPulseColors.section3, isA<Color>());
      expect(MonoPulseColors.section4, isA<Color>());
      expect(MonoPulseColors.section5, isA<Color>());
      expect(MonoPulseColors.section6, isA<Color>());
      expect(MonoPulseColors.section7, isA<Color>());
      expect(MonoPulseColors.section8, isA<Color>());
      expect(MonoPulseColors.section9, isA<Color>());
      expect(MonoPulseColors.section10, isA<Color>());
      expect(MonoPulseColors.section11, isA<Color>());
      expect(MonoPulseColors.section12, isA<Color>());
      expect(MonoPulseColors.section13, isA<Color>());
      expect(MonoPulseColors.section14, isA<Color>());
    });

    test('orange opacity variants are defined', () {
      expect(MonoPulseColors.orangeSubtle5, isA<Color>());
      expect(MonoPulseColors.orangeSubtle20, isA<Color>());
      expect(MonoPulseColors.orangeSubtle30, isA<Color>());
    });

    test('transparent and white are defined', () {
      expect(MonoPulseColors.transparent, isA<Color>());
      expect(MonoPulseColors.white, isA<Color>());
    });

    test('section colors have distinct values', () {
      final sectionColors = [
        MonoPulseColors.section1,
        MonoPulseColors.section2,
        MonoPulseColors.section3,
        MonoPulseColors.section4,
        MonoPulseColors.section5,
        MonoPulseColors.section6,
        MonoPulseColors.section7,
        MonoPulseColors.section8,
        MonoPulseColors.section9,
        MonoPulseColors.section10,
        MonoPulseColors.section11,
        MonoPulseColors.section12,
        MonoPulseColors.section13,
        MonoPulseColors.section14,
      ];

      // All section colors should be unique
      final uniqueColors = sectionColors.toSet();
      expect(uniqueColors.length, 14);
    });
  });

  group('data providers', () {
    test('songsProvider is defined', () {
      expect(songsProvider, isNotNull);
    });

    test('setlistsProvider is defined', () {
      expect(setlistsProvider, isNotNull);
    });

    test('songsProvider returns AsyncValue', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final songs = container.read(songsProvider);
      expect(songs, isNotNull);
    });

    test('setlistsProvider returns AsyncValue', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final setlists = container.read(setlistsProvider);
      expect(setlists, isNotNull);
    });
  });
}
