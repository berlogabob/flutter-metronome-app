// Test file for MetronomeToneConfig model
// Tests for beat_type.dart, subdivision_type.dart, and metronome_tone_config.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:metronome_app/models/metronome_tone_config.dart';
import 'package:metronome_app/models/beat_mode.dart';
import 'package:metronome_app/models/subdivision_type.dart';

void main() {
  group('BeatMode enum', () {
    test('BeatMode has correct values', () {
      expect(BeatMode.values.length, 3);
      expect(BeatMode.values[0], BeatMode.normal);
      expect(BeatMode.values[1], BeatMode.accent);
      expect(BeatMode.values[2], BeatMode.silent);
    });
  });

  group('SubdivisionType enum', () {
    test('SubdivisionType has correct values', () {
      expect(SubdivisionType.values.length, 4);
      expect(SubdivisionType.values[0], SubdivisionType.quarter);
      expect(SubdivisionType.values[1], SubdivisionType.eighth);
      expect(SubdivisionType.values[2], SubdivisionType.triplet);
      expect(SubdivisionType.values[3], SubdivisionType.sixteenth);
    });

    group('SubdivisionType.multiplier', () {
      test('quarter returns 1', () {
        expect(SubdivisionType.quarter.multiplier, 1);
      });

      test('eighth returns 2', () {
        expect(SubdivisionType.eighth.multiplier, 2);
      });

      test('triplet returns 3', () {
        expect(SubdivisionType.triplet.multiplier, 3);
      });

      test('sixteenth returns 4', () {
        expect(SubdivisionType.sixteenth.multiplier, 4);
      });
    });

    group('SubdivisionType.label', () {
      test('quarter returns 1/4', () {
        expect(SubdivisionType.quarter.label, '1/4');
      });

      test('eighth returns 1/8', () {
        expect(SubdivisionType.eighth.label, '1/8');
      });

      test('triplet returns 1/8T', () {
        expect(SubdivisionType.triplet.label, '1/8T');
      });

      test('sixteenth returns 1/16', () {
        expect(SubdivisionType.sixteenth.label, '1/16');
      });
    });
  });

  group('BeatType enum', () {
    test('BeatType has correct values', () {
      expect(BeatType.values.length, 3);
      expect(BeatType.values[0], BeatType.main);
      expect(BeatType.values[1], BeatType.sub);
      expect(BeatType.values[2], BeatType.divider);
    });
  });

  group('AccentState enum', () {
    test('AccentState has correct values', () {
      expect(AccentState.values.length, 2);
      expect(AccentState.values[0], AccentState.regular);
      expect(AccentState.values[1], AccentState.accent);
    });
  });

  group('MetronomeToneConfig', () {
    test('default constructor creates with default values', () {
      const config = MetronomeToneConfig();

      expect(config.mainRegularFreq, 1600.0);
      expect(config.mainAccentFreq, 2060.0);
      expect(config.subRegularFreq, 800.0);
      expect(config.subAccentFreq, 1030.0);
      expect(config.dividerRegularFreq, 1100.0);
      expect(config.dividerAccentFreq, 1400.0);
      expect(config.waveType, 'sine');
      expect(config.volume, 0.75);
      expect(config.clickDuration, 0.04);
    });

    test('constructor with custom values', () {
      const config = MetronomeToneConfig(
        mainRegularFreq: 1500.0,
        mainAccentFreq: 2000.0,
        subRegularFreq: 700.0,
        subAccentFreq: 900.0,
        dividerRegularFreq: 1000.0,
        dividerAccentFreq: 1300.0,
        waveType: 'square',
        volume: 0.5,
        clickDuration: 0.05,
      );

      expect(config.mainRegularFreq, 1500.0);
      expect(config.mainAccentFreq, 2000.0);
      expect(config.subRegularFreq, 700.0);
      expect(config.subAccentFreq, 900.0);
      expect(config.dividerRegularFreq, 1000.0);
      expect(config.dividerAccentFreq, 1300.0);
      expect(config.waveType, 'square');
      expect(config.volume, 0.5);
      expect(config.clickDuration, 0.05);
    });

    group('getFrequency', () {
      const config = MetronomeToneConfig(
        mainRegularFreq: 1600.0,
        mainAccentFreq: 2060.0,
        subRegularFreq: 800.0,
        subAccentFreq: 1030.0,
        dividerRegularFreq: 1100.0,
        dividerAccentFreq: 1400.0,
      );

      test('returns main regular frequency', () {
        expect(
          config.getFrequency(BeatType.main, AccentState.regular),
          1600.0,
        );
      });

      test('returns main accent frequency', () {
        expect(
          config.getFrequency(BeatType.main, AccentState.accent),
          2060.0,
        );
      });

      test('returns sub regular frequency', () {
        expect(
          config.getFrequency(BeatType.sub, AccentState.regular),
          800.0,
        );
      });

      test('returns sub accent frequency', () {
        expect(
          config.getFrequency(BeatType.sub, AccentState.accent),
          1030.0,
        );
      });

      test('returns divider regular frequency', () {
        expect(
          config.getFrequency(BeatType.divider, AccentState.regular),
          1100.0,
        );
      });

      test('returns divider accent frequency', () {
        expect(
          config.getFrequency(BeatType.divider, AccentState.accent),
          1400.0,
        );
      });
    });

    group('copyWith', () {
      const original = MetronomeToneConfig();

      test('creates copy with all fields unchanged when no params', () {
        final copy = original.copyWith();

        expect(copy.mainRegularFreq, original.mainRegularFreq);
        expect(copy.mainAccentFreq, original.mainAccentFreq);
        expect(copy.subRegularFreq, original.subRegularFreq);
        expect(copy.subAccentFreq, original.subAccentFreq);
        expect(copy.dividerRegularFreq, original.dividerRegularFreq);
        expect(copy.dividerAccentFreq, original.dividerAccentFreq);
        expect(copy.waveType, original.waveType);
        expect(copy.volume, original.volume);
        expect(copy.clickDuration, original.clickDuration);
      });

      test('creates copy with modified mainRegularFreq', () {
        final copy = original.copyWith(mainRegularFreq: 1700.0);

        expect(copy.mainRegularFreq, 1700.0);
        expect(copy.mainAccentFreq, original.mainAccentFreq);
      });

      test('creates copy with modified waveType', () {
        final copy = original.copyWith(waveType: 'triangle');

        expect(copy.waveType, 'triangle');
        expect(copy.mainRegularFreq, original.mainRegularFreq);
      });

      test('creates copy with multiple modified fields', () {
        final copy = original.copyWith(
          volume: 0.9,
          clickDuration: 0.06,
          mainAccentFreq: 2100.0,
        );

        expect(copy.volume, 0.9);
        expect(copy.clickDuration, 0.06);
        expect(copy.mainAccentFreq, 2100.0);
        expect(copy.mainRegularFreq, original.mainRegularFreq);
      });
    });

    group('toJson', () {
      test('converts to JSON with all fields', () {
        const config = MetronomeToneConfig(
          mainRegularFreq: 1600.0,
          mainAccentFreq: 2060.0,
          subRegularFreq: 800.0,
          subAccentFreq: 1030.0,
          dividerRegularFreq: 1100.0,
          dividerAccentFreq: 1400.0,
          waveType: 'sine',
          volume: 0.75,
          clickDuration: 0.04,
        );

        final json = config.toJson();

        expect(json['mainRegularFreq'], 1600.0);
        expect(json['mainAccentFreq'], 2060.0);
        expect(json['subRegularFreq'], 800.0);
        expect(json['subAccentFreq'], 1030.0);
        expect(json['dividerRegularFreq'], 1100.0);
        expect(json['dividerAccentFreq'], 1400.0);
        expect(json['waveType'], 'sine');
        expect(json['volume'], 0.75);
        expect(json['clickDuration'], 0.04);
      });
    });

    group('fromJson', () {
      test('creates from JSON with all fields', () {
        final json = {
          'mainRegularFreq': 1500.0,
          'mainAccentFreq': 2000.0,
          'subRegularFreq': 700.0,
          'subAccentFreq': 900.0,
          'dividerRegularFreq': 1000.0,
          'dividerAccentFreq': 1300.0,
          'waveType': 'square',
          'volume': 0.5,
          'clickDuration': 0.05,
        };

        final config = MetronomeToneConfig.fromJson(json);

        expect(config.mainRegularFreq, 1500.0);
        expect(config.mainAccentFreq, 2000.0);
        expect(config.subRegularFreq, 700.0);
        expect(config.subAccentFreq, 900.0);
        expect(config.dividerRegularFreq, 1000.0);
        expect(config.dividerAccentFreq, 1300.0);
        expect(config.waveType, 'square');
        expect(config.volume, 0.5);
        expect(config.clickDuration, 0.05);
      });

      test('creates from JSON with missing fields uses defaults', () {
        final json = <String, dynamic>{};

        final config = MetronomeToneConfig.fromJson(json);

        expect(config.mainRegularFreq, 1600.0);
        expect(config.mainAccentFreq, 2060.0);
        expect(config.subRegularFreq, 800.0);
        expect(config.subAccentFreq, 1030.0);
        expect(config.dividerRegularFreq, 1100.0);
        expect(config.dividerAccentFreq, 1400.0);
        expect(config.waveType, 'sine');
        expect(config.volume, 0.75);
        expect(config.clickDuration, 0.04);
      });

      test('creates from JSON with partial fields', () {
        final json = {
          'mainRegularFreq': 1800.0,
          'waveType': 'sawtooth',
        };

        final config = MetronomeToneConfig.fromJson(json);

        expect(config.mainRegularFreq, 1800.0);
        expect(config.mainAccentFreq, 2060.0); // default
        expect(config.waveType, 'sawtooth');
        expect(config.volume, 0.75); // default
      });
    });

    group('presets', () {
      test('classic preset has correct values', () {
        final config = MetronomeToneConfig.classic;

        expect(config.mainRegularFreq, 1600.0);
        expect(config.mainAccentFreq, 2060.0);
        expect(config.subRegularFreq, 800.0);
        expect(config.subAccentFreq, 1030.0);
        expect(config.dividerRegularFreq, 1100.0);
        expect(config.dividerAccentFreq, 1400.0);
        expect(config.waveType, 'sine');
      });

      test('subtle preset has correct values', () {
        final config = MetronomeToneConfig.subtle;

        expect(config.mainRegularFreq, 1200.0);
        expect(config.mainAccentFreq, 1400.0);
        expect(config.subRegularFreq, 1000.0);
        expect(config.subAccentFreq, 1100.0);
        expect(config.dividerRegularFreq, 1100.0);
        expect(config.dividerAccentFreq, 1200.0);
      });

      test('extreme preset has correct values', () {
        final config = MetronomeToneConfig.extreme;

        expect(config.mainRegularFreq, 2000.0);
        expect(config.mainAccentFreq, 3000.0);
        expect(config.subRegularFreq, 500.0);
        expect(config.subAccentFreq, 750.0);
        expect(config.dividerRegularFreq, 1000.0);
        expect(config.dividerAccentFreq, 1500.0);
      });

      test('woodBlock preset has correct values', () {
        final config = MetronomeToneConfig.woodBlock;

        expect(config.mainRegularFreq, 1800.0);
        expect(config.mainAccentFreq, 2200.0);
        expect(config.subRegularFreq, 900.0);
        expect(config.subAccentFreq, 1200.0);
        expect(config.waveType, 'square');
      });

      test('electronic preset has correct values', () {
        final config = MetronomeToneConfig.electronic;

        expect(config.mainRegularFreq, 1600.0);
        expect(config.mainAccentFreq, 2060.0);
        expect(config.subRegularFreq, 800.0);
        expect(config.subAccentFreq, 1030.0);
        expect(config.waveType, 'sawtooth');
      });
    });

    group('JSON serialization round-trip', () {
      test('toJson and fromJson are inverse operations', () {
        const original = MetronomeToneConfig(
          mainRegularFreq: 1750.0,
          mainAccentFreq: 2150.0,
          subRegularFreq: 850.0,
          subAccentFreq: 1050.0,
          dividerRegularFreq: 1150.0,
          dividerAccentFreq: 1450.0,
          waveType: 'triangle',
          volume: 0.6,
          clickDuration: 0.045,
        );

        final json = original.toJson();
        final restored = MetronomeToneConfig.fromJson(json);

        expect(restored.mainRegularFreq, original.mainRegularFreq);
        expect(restored.mainAccentFreq, original.mainAccentFreq);
        expect(restored.subRegularFreq, original.subRegularFreq);
        expect(restored.subAccentFreq, original.subAccentFreq);
        expect(restored.dividerRegularFreq, original.dividerRegularFreq);
        expect(restored.dividerAccentFreq, original.dividerAccentFreq);
        expect(restored.waveType, original.waveType);
        expect(restored.volume, original.volume);
        expect(restored.clickDuration, original.clickDuration);
      });

      test('all presets survive round-trip', () {
        final presets = [
          MetronomeToneConfig.classic,
          MetronomeToneConfig.subtle,
          MetronomeToneConfig.extreme,
          MetronomeToneConfig.woodBlock,
          MetronomeToneConfig.electronic,
        ];

        for (final preset in presets) {
          final json = preset.toJson();
          final restored = MetronomeToneConfig.fromJson(json);

          expect(restored.mainRegularFreq, preset.mainRegularFreq);
          expect(restored.mainAccentFreq, preset.mainAccentFreq);
          expect(restored.waveType, preset.waveType);
          expect(restored.volume, preset.volume);
        }
      });
    });
  });
}
