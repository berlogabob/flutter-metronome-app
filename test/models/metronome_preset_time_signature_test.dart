// Test file for MetronomePreset and TimeSignature models

import 'package:flutter_test/flutter_test.dart';
import 'package:metronome_app/models/metronome_preset.dart';
import 'package:metronome_app/models/time_signature.dart';

void main() {
  group('TimeSignature', () {
    test('constructor creates with valid values', () {
      const ts = TimeSignature(numerator: 4, denominator: 4);

      expect(ts.numerator, 4);
      expect(ts.denominator, 4);
      expect(ts.isValid, isTrue);
    });

    test('constructor creates with 3/4', () {
      const ts = TimeSignature(numerator: 3, denominator: 4);

      expect(ts.numerator, 3);
      expect(ts.denominator, 4);
      expect(ts.isValid, isTrue);
    });

    test('constructor creates with 6/8', () {
      const ts = TimeSignature(numerator: 6, denominator: 8);

      expect(ts.numerator, 6);
      expect(ts.denominator, 8);
      expect(ts.isValid, isTrue);
    });

    group('isValid', () {
      test('returns true for valid time signatures', () {
        expect(const TimeSignature(numerator: 2, denominator: 4).isValid, isTrue);
        expect(const TimeSignature(numerator: 3, denominator: 4).isValid, isTrue);
        expect(const TimeSignature(numerator: 4, denominator: 4).isValid, isTrue);
        expect(const TimeSignature(numerator: 5, denominator: 4).isValid, isTrue);
        expect(const TimeSignature(numerator: 6, denominator: 8).isValid, isTrue);
        expect(const TimeSignature(numerator: 7, denominator: 8).isValid, isTrue);
        expect(const TimeSignature(numerator: 9, denominator: 8).isValid, isTrue);
        expect(const TimeSignature(numerator: 12, denominator: 8).isValid, isTrue);
      });

      test('returns false for numerator < 2', () {
        expect(const TimeSignature(numerator: 1, denominator: 4).isValid, isFalse);
        expect(const TimeSignature(numerator: 0, denominator: 4).isValid, isFalse);
      });

      test('returns false for numerator > 12', () {
        expect(const TimeSignature(numerator: 13, denominator: 4).isValid, isFalse);
        expect(const TimeSignature(numerator: 16, denominator: 4).isValid, isFalse);
      });

      test('returns false for invalid denominator', () {
        expect(const TimeSignature(numerator: 4, denominator: 2).isValid, isFalse);
        expect(const TimeSignature(numerator: 4, denominator: 16).isValid, isFalse);
        expect(const TimeSignature(numerator: 4, denominator: 1).isValid, isFalse);
      });
    });

    group('displayName', () {
      test('returns formatted string for 4/4', () {
        const ts = TimeSignature(numerator: 4, denominator: 4);
        expect(ts.displayName, '4 / 4');
      });

      test('returns formatted string for 3/4', () {
        const ts = TimeSignature(numerator: 3, denominator: 4);
        expect(ts.displayName, '3 / 4');
      });

      test('returns formatted string for 6/8', () {
        const ts = TimeSignature(numerator: 6, denominator: 8);
        expect(ts.displayName, '6 / 8');
      });

      test('returns formatted string for 7/8', () {
        const ts = TimeSignature(numerator: 7, denominator: 8);
        expect(ts.displayName, '7 / 8');
      });
    });

    group('static presets', () {
      test('commonTime is 4/4', () {
        expect(TimeSignature.commonTime.numerator, 4);
        expect(TimeSignature.commonTime.denominator, 4);
      });

      test('cutTime is 2/2', () {
        expect(TimeSignature.cutTime.numerator, 2);
        expect(TimeSignature.cutTime.denominator, 2);
      });

      test('waltz is 3/4', () {
        expect(TimeSignature.waltz.numerator, 3);
        expect(TimeSignature.waltz.denominator, 4);
      });

      test('presets list contains 8 time signatures', () {
        expect(TimeSignature.presets.length, 8);
      });

      test('presets contains expected time signatures', () {
        expect(TimeSignature.presets[0], const TimeSignature(numerator: 2, denominator: 4));
        expect(TimeSignature.presets[1], const TimeSignature(numerator: 3, denominator: 4));
        expect(TimeSignature.presets[2], const TimeSignature(numerator: 4, denominator: 4));
        expect(TimeSignature.presets[3], const TimeSignature(numerator: 5, denominator: 4));
        expect(TimeSignature.presets[4], const TimeSignature(numerator: 6, denominator: 8));
        expect(TimeSignature.presets[5], const TimeSignature(numerator: 7, denominator: 8));
        expect(TimeSignature.presets[6], const TimeSignature(numerator: 9, denominator: 8));
        expect(TimeSignature.presets[7], const TimeSignature(numerator: 12, denominator: 8));
      });
    });

    group('fromString', () {
      test('parses valid 4/4', () {
        final ts = TimeSignature.fromString('4/4');
        expect(ts, isNotNull);
        expect(ts!.numerator, 4);
        expect(ts.denominator, 4);
      });

      test('parses valid 3/4', () {
        final ts = TimeSignature.fromString('3/4');
        expect(ts, isNotNull);
        expect(ts!.numerator, 3);
        expect(ts.denominator, 4);
      });

      test('parses valid 6/8', () {
        final ts = TimeSignature.fromString('6/8');
        expect(ts, isNotNull);
        expect(ts!.numerator, 6);
        expect(ts.denominator, 8);
      });

      test('parses with spaces', () {
        final ts = TimeSignature.fromString('4 / 4');
        expect(ts, isNotNull);
        expect(ts!.numerator, 4);
        expect(ts.denominator, 4);
      });

      test('returns null for invalid format', () {
        expect(TimeSignature.fromString('invalid'), isNull);
        expect(TimeSignature.fromString('4'), isNull);
        expect(TimeSignature.fromString('4/4/4'), isNull);
        expect(TimeSignature.fromString(''), isNull);
      });

      test('returns null for non-numeric values', () {
        expect(TimeSignature.fromString('a/b'), isNull);
        expect(TimeSignature.fromString('4/x'), isNull);
        expect(TimeSignature.fromString('x/4'), isNull);
      });
    });

    group('toString', () {
      test('returns displayName', () {
        const ts = TimeSignature(numerator: 4, denominator: 4);
        expect(ts.toString(), '4 / 4');
      });
    });

    group('equality', () {
      test('equal time signatures are equal', () {
        const ts1 = TimeSignature(numerator: 4, denominator: 4);
        const ts2 = TimeSignature(numerator: 4, denominator: 4);

        expect(ts1, equals(ts2));
        expect(ts1.hashCode, equals(ts2.hashCode));
      });

      test('different numerators are not equal', () {
        const ts1 = TimeSignature(numerator: 4, denominator: 4);
        const ts2 = TimeSignature(numerator: 3, denominator: 4);

        expect(ts1, isNot(equals(ts2)));
      });

      test('different denominators are not equal', () {
        const ts1 = TimeSignature(numerator: 4, denominator: 4);
        const ts2 = TimeSignature(numerator: 4, denominator: 8);

        expect(ts1, isNot(equals(ts2)));
      });

      test('identical references are equal', () {
        const ts = TimeSignature(numerator: 4, denominator: 4);
        expect(ts, equals(ts));
      });
    });

    group('JSON serialization', () {
      test('toJson converts to JSON', () {
        const ts = TimeSignature(numerator: 4, denominator: 4);
        final json = ts.toJson();

        expect(json['numerator'], 4);
        expect(json['denominator'], 4);
      });

      test('fromJson creates from JSON', () {
        final json = {'numerator': 3, 'denominator': 4};
        final ts = TimeSignature.fromJson(json);

        expect(ts.numerator, 3);
        expect(ts.denominator, 4);
      });

      test('round-trip preserves values', () {
        const original = TimeSignature(numerator: 6, denominator: 8);
        final json = original.toJson();
        final restored = TimeSignature.fromJson(json);

        expect(restored.numerator, original.numerator);
        expect(restored.denominator, original.denominator);
      });
    });
  });

  group('MetronomePreset', () {
    test('constructor creates with required fields', () {
      final preset = MetronomePreset(
        id: 'preset1',
        name: 'Test Preset',
        bpm: 120,
        timeSignature: const TimeSignature(numerator: 4, denominator: 4),
        waveType: 'sine',
        accentEnabled: true,
        createdAt: DateTime(2026, 1, 1),
      );

      expect(preset.id, 'preset1');
      expect(preset.name, 'Test Preset');
      expect(preset.bpm, 120);
      expect(preset.timeSignature.numerator, 4);
      expect(preset.timeSignature.denominator, 4);
      expect(preset.waveType, 'sine');
      expect(preset.accentEnabled, isTrue);
      expect(preset.createdAt, DateTime(2026, 1, 1));
    });

    group('displayName', () {
      test('returns formatted display name', () {
        final preset = MetronomePreset(
          id: 'preset1',
          name: 'Slow Practice',
          bpm: 60,
          timeSignature: const TimeSignature(numerator: 4, denominator: 4),
          waveType: 'sine',
          accentEnabled: true,
          createdAt: DateTime(2026),
        );

        expect(preset.displayName, 'Slow Practice (60 BPM 4 / 4)');
      });

      test('includes time signature in display name', () {
        final preset = MetronomePreset(
          id: 'preset2',
          name: 'Waltz',
          bpm: 90,
          timeSignature: const TimeSignature(numerator: 3, denominator: 4),
          waveType: 'sine',
          accentEnabled: true,
          createdAt: DateTime(2026),
        );

        expect(preset.displayName, 'Waltz (90 BPM 3 / 4)');
      });
    });

    group('copyWith', () {
      final original = MetronomePreset(
        id: 'preset1',
        name: 'Original',
        bpm: 100,
        timeSignature: const TimeSignature(numerator: 4, denominator: 4),
        waveType: 'sine',
        accentEnabled: true,
        createdAt: DateTime(2026, 1, 1),
      );

      test('creates copy with all fields unchanged when no params', () {
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.name, original.name);
        expect(copy.bpm, original.bpm);
        expect(copy.timeSignature, original.timeSignature);
        expect(copy.waveType, original.waveType);
        expect(copy.accentEnabled, original.accentEnabled);
        expect(copy.createdAt, original.createdAt);
      });

      test('creates copy with modified id', () {
        final copy = original.copyWith(id: 'preset2');
        expect(copy.id, 'preset2');
        expect(copy.name, original.name);
      });

      test('creates copy with modified name', () {
        final copy = original.copyWith(name: 'Updated');
        expect(copy.name, 'Updated');
        expect(copy.bpm, original.bpm);
      });

      test('creates copy with modified bpm', () {
        final copy = original.copyWith(bpm: 140);
        expect(copy.bpm, 140);
        expect(copy.name, original.name);
      });

      test('creates copy with modified timeSignature', () {
        final copy = original.copyWith(
          timeSignature: const TimeSignature(numerator: 3, denominator: 4),
        );
        expect(copy.timeSignature.numerator, 3);
        expect(copy.timeSignature.denominator, 4);
      });

      test('creates copy with modified waveType', () {
        final copy = original.copyWith(waveType: 'square');
        expect(copy.waveType, 'square');
        expect(copy.bpm, original.bpm);
      });

      test('creates copy with modified accentEnabled', () {
        final copy = original.copyWith(accentEnabled: false);
        expect(copy.accentEnabled, isFalse);
        expect(copy.waveType, original.waveType);
      });

      test('creates copy with modified createdAt', () {
        final newDate = DateTime(2026, 6, 15);
        final copy = original.copyWith(createdAt: newDate);
        expect(copy.createdAt, newDate);
        expect(copy.accentEnabled, original.accentEnabled);
      });

      test('creates copy with multiple modified fields', () {
        final copy = original.copyWith(
          bpm: 120,
          waveType: 'triangle',
          accentEnabled: false,
        );

        expect(copy.bpm, 120);
        expect(copy.waveType, 'triangle');
        expect(copy.accentEnabled, isFalse);
        expect(copy.id, original.id);
      });
    });

    group('JSON serialization', () {
      test('toJson converts to JSON with all fields', () {
        final preset = MetronomePreset(
          id: 'preset1',
          name: 'Test',
          bpm: 120,
          timeSignature: const TimeSignature(numerator: 4, denominator: 4),
          waveType: 'sine',
          accentEnabled: true,
          createdAt: DateTime(2026, 1, 1, 12, 0, 0),
        );

        final json = preset.toJson();

        expect(json['id'], 'preset1');
        expect(json['name'], 'Test');
        expect(json['bpm'], 120);
        expect(json['timeSignature'], isNotNull);
        expect(json['waveType'], 'sine');
        expect(json['accentEnabled'], true);
        expect(json['createdAt'], isNotNull);
      });

      test('fromJson creates from JSON with all fields', () {
        final json = {
          'id': 'preset2',
          'name': 'From JSON',
          'bpm': 90,
          'timeSignature': {'numerator': 3, 'denominator': 4},
          'waveType': 'square',
          'accentEnabled': false,
          'createdAt': '2026-01-01T00:00:00.000',
        };

        final preset = MetronomePreset.fromJson(json);

        expect(preset.id, 'preset2');
        expect(preset.name, 'From JSON');
        expect(preset.bpm, 90);
        expect(preset.timeSignature.numerator, 3);
        expect(preset.timeSignature.denominator, 4);
        expect(preset.waveType, 'square');
        expect(preset.accentEnabled, isFalse);
        expect(preset.createdAt, isNotNull);
      });

      test('fromJson handles DateTime string', () {
        final json = {
          'id': 'preset3',
          'name': 'Test',
          'bpm': 100,
          'timeSignature': {'numerator': 4, 'denominator': 4},
          'waveType': 'sine',
          'accentEnabled': true,
          'createdAt': '2026-06-15T10:30:00.000',
        };

        final preset = MetronomePreset.fromJson(json);
        expect(preset.createdAt.year, 2026);
        expect(preset.createdAt.month, 6);
        expect(preset.createdAt.day, 15);
      });

      test('fromJson handles DateTime object', () {
        final json = {
          'id': 'preset4',
          'name': 'Test',
          'bpm': 100,
          'timeSignature': {'numerator': 4, 'denominator': 4},
          'waveType': 'sine',
          'accentEnabled': true,
          'createdAt': DateTime(2026, 12, 25),
        };

        final preset = MetronomePreset.fromJson(json);
        expect(preset.createdAt.year, 2026);
        expect(preset.createdAt.month, 12);
        expect(preset.createdAt.day, 25);
      });

      test('fromJson uses defaults for missing fields', () {
        final json = <String, dynamic>{};

        final preset = MetronomePreset.fromJson(json);

        expect(preset.id, '');
        expect(preset.name, '');
        expect(preset.waveType, 'sine');
        expect(preset.accentEnabled, true);
      });

      test('round-trip preserves all values', () {
        final original = MetronomePreset(
          id: 'preset1',
          name: 'Round Trip',
          bpm: 110,
          timeSignature: const TimeSignature(numerator: 5, denominator: 4),
          waveType: 'sawtooth',
          accentEnabled: false,
          createdAt: DateTime(2026, 3, 20, 14, 30),
        );

        final json = original.toJson();
        final restored = MetronomePreset.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.bpm, original.bpm);
        expect(restored.timeSignature, original.timeSignature);
        expect(restored.waveType, original.waveType);
        expect(restored.accentEnabled, original.accentEnabled);
        // DateTime comparison may have slight differences due to serialization
        expect(restored.createdAt.millisecondsSinceEpoch,
            original.createdAt.millisecondsSinceEpoch);
      });
    });

    group('default presets', () {
      test('defaults list contains 3 presets', () {
        expect(MetronomePreset.defaults.length, 3);
      });

      test('first preset is Slow Practice', () {
        final preset = MetronomePreset.defaults[0];
        expect(preset.name, 'Slow Practice');
        expect(preset.bpm, 60);
        expect(preset.timeSignature.numerator, 4);
        expect(preset.timeSignature.denominator, 4);
        expect(preset.waveType, 'sine');
        expect(preset.accentEnabled, isTrue);
      });

      test('second preset is Medium Rock', () {
        final preset = MetronomePreset.defaults[1];
        expect(preset.name, 'Medium Rock');
        expect(preset.bpm, 120);
        expect(preset.timeSignature.numerator, 4);
        expect(preset.timeSignature.denominator, 4);
        expect(preset.waveType, 'square');
        expect(preset.accentEnabled, isTrue);
      });

      test('third preset is Waltz', () {
        final preset = MetronomePreset.defaults[2];
        expect(preset.name, 'Waltz');
        expect(preset.bpm, 90);
        expect(preset.timeSignature.numerator, 3);
        expect(preset.timeSignature.denominator, 4);
        expect(preset.waveType, 'sine');
        expect(preset.accentEnabled, isTrue);
      });

      test('all default presets have valid display names', () {
        for (final preset in MetronomePreset.defaults) {
          expect(preset.displayName, isNotEmpty);
          expect(preset.displayName, contains(preset.name));
          expect(preset.displayName, contains('BPM'));
        }
      });
    });
  });
}
