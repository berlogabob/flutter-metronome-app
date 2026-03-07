// Test file for Section, SetlistAssignment, and Link models

import 'package:flutter_test/flutter_test.dart';
import 'package:metronome_app/models/section.dart';
import 'package:metronome_app/models/setlist_assignment.dart';
import 'package:metronome_app/models/link.dart';

void main() {
  group('Section', () {
    test('constructor creates with required fields', () {
      const section = Section(
        id: 'section1',
        name: 'Chorus',
        order: 1,
      );

      expect(section.id, 'section1');
      expect(section.name, 'Chorus');
      expect(section.order, 1);
      expect(section.startBeat, isNull);
      expect(section.endBeat, isNull);
      expect(section.color, isNull);
    });

    test('constructor creates with all fields', () {
      const section = Section(
        id: 'section2',
        name: 'Verse',
        order: 0,
        startBeat: 0,
        endBeat: 16,
        color: '#FF5722',
      );

      expect(section.id, 'section2');
      expect(section.name, 'Verse');
      expect(section.order, 0);
      expect(section.startBeat, 0);
      expect(section.endBeat, 16);
      expect(section.color, '#FF5722');
    });

    group('copyWith', () {
      const original = Section(
        id: 'section1',
        name: 'Chorus',
        order: 1,
        startBeat: 0,
        endBeat: 16,
        color: '#FF5722',
      );

      test('creates copy with all fields unchanged when no params', () {
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.name, original.name);
        expect(copy.order, original.order);
        expect(copy.startBeat, original.startBeat);
        expect(copy.endBeat, original.endBeat);
        expect(copy.color, original.color);
      });

      test('creates copy with modified name', () {
        final copy = original.copyWith(name: 'Bridge');

        expect(copy.name, 'Bridge');
        expect(copy.id, original.id);
        expect(copy.order, original.order);
      });

      test('creates copy with modified order', () {
        final copy = original.copyWith(order: 2);

        expect(copy.order, 2);
        expect(copy.name, original.name);
      });

      test('creates copy with modified startBeat', () {
        final copy = original.copyWith(startBeat: 8);

        expect(copy.startBeat, 8);
        expect(copy.endBeat, original.endBeat);
      });

      test('creates copy with modified endBeat', () {
        final copy = original.copyWith(endBeat: 24);

        expect(copy.endBeat, 24);
        expect(copy.startBeat, original.startBeat);
      });

      test('creates copy with modified color', () {
        final copy = original.copyWith(color: '#2196F3');

        expect(copy.color, '#2196F3');
        expect(copy.name, original.name);
      });

      test('creates copy with multiple modified fields', () {
        final copy = original.copyWith(
          name: 'Outro',
          order: 5,
          color: '#4CAF50',
        );

        expect(copy.name, 'Outro');
        expect(copy.order, 5);
        expect(copy.color, '#4CAF50');
        expect(copy.id, original.id);
      });
    });

    group('JSON serialization', () {
      test('toJson converts to JSON with all fields', () {
        const section = Section(
          id: 'section1',
          name: 'Chorus',
          order: 1,
          startBeat: 0,
          endBeat: 16,
          color: '#FF5722',
        );

        final json = section.toJson();

        expect(json['id'], 'section1');
        expect(json['name'], 'Chorus');
        expect(json['order'], 1);
        expect(json['startBeat'], 0);
        expect(json['endBeat'], 16);
        expect(json['color'], '#FF5722');
      });

      test('fromJson creates from JSON with all fields', () {
        final json = {
          'id': 'section2',
          'name': 'Verse',
          'order': 0,
          'startBeat': 0,
          'endBeat': 16,
          'color': '#2196F3',
        };

        final section = Section.fromJson(json);

        expect(section.id, 'section2');
        expect(section.name, 'Verse');
        expect(section.order, 0);
        expect(section.startBeat, 0);
        expect(section.endBeat, 16);
        expect(section.color, '#2196F3');
      });

      test('fromJson creates from JSON with missing fields uses defaults', () {
        final json = <String, dynamic>{};

        final section = Section.fromJson(json);

        expect(section.id, '');
        expect(section.name, '');
        expect(section.order, 0);
        expect(section.startBeat, 0);
        expect(section.endBeat, 0);
        expect(section.color, '');
      });

      test('fromJson creates from JSON with partial fields', () {
        final json = {
          'id': 'section3',
          'name': 'Bridge',
        };

        final section = Section.fromJson(json);

        expect(section.id, 'section3');
        expect(section.name, 'Bridge');
        expect(section.order, 0); // default
        expect(section.startBeat, 0); // default
        expect(section.endBeat, 0); // default
        expect(section.color, ''); // default
      });

      test('round-trip serialization preserves all values', () {
        const original = Section(
          id: 'section1',
          name: 'Chorus',
          order: 2,
          startBeat: 16,
          endBeat: 32,
          color: '#9C27B0',
        );

        final json = original.toJson();
        final restored = Section.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.order, original.order);
        expect(restored.startBeat, original.startBeat);
        expect(restored.endBeat, original.endBeat);
        expect(restored.color, original.color);
      });
    });
  });

  group('SetlistAssignment', () {
    test('constructor creates with required field', () {
      final assignment = SetlistAssignment(
        oderId: 'member123',
      );

      expect(assignment.oderId, 'member123');
      expect(assignment.roleOverride, isNull);
      expect(assignment.keyOverride, isNull);
      expect(assignment.notes, isNull);
    });

    test('constructor creates with all fields', () {
      final assignment = SetlistAssignment(
        oderId: 'member456',
        roleOverride: 'lead_guitar',
        keyOverride: 'G',
        notes: 'Use capo on 2nd fret',
      );

      expect(assignment.oderId, 'member456');
      expect(assignment.roleOverride, 'lead_guitar');
      expect(assignment.keyOverride, 'G');
      expect(assignment.notes, 'Use capo on 2nd fret');
    });

    group('copyWith', () {
      final original = SetlistAssignment(
        oderId: 'member123',
        roleOverride: 'rhythm_guitar',
        keyOverride: 'C',
        notes: 'Standard tuning',
      );

      test('creates copy with all fields unchanged when no params', () {
        final copy = original.copyWith();

        expect(copy.oderId, original.oderId);
        expect(copy.roleOverride, original.roleOverride);
        expect(copy.keyOverride, original.keyOverride);
        expect(copy.notes, original.notes);
      });

      test('creates copy with modified oderId', () {
        final copy = original.copyWith(oderId: 'member789');

        expect(copy.oderId, 'member789');
        expect(copy.roleOverride, original.roleOverride);
      });

      test('creates copy with modified roleOverride', () {
        final copy = original.copyWith(roleOverride: 'bass');

        expect(copy.roleOverride, 'bass');
        expect(copy.oderId, original.oderId);
      });

      test('creates copy with modified keyOverride', () {
        final copy = original.copyWith(keyOverride: 'D');

        expect(copy.keyOverride, 'D');
        expect(copy.roleOverride, original.roleOverride);
      });

      test('creates copy with modified notes', () {
        final copy = original.copyWith(notes: 'Drop D tuning');

        expect(copy.notes, 'Drop D tuning');
        expect(copy.keyOverride, original.keyOverride);
      });

      test('creates copy with clearRoleOverride sets to null', () {
        final copy = original.copyWith(clearRoleOverride: true);

        expect(copy.roleOverride, isNull);
        expect(copy.oderId, original.oderId);
      });

      test('creates copy with clearKeyOverride sets to null', () {
        final copy = original.copyWith(clearKeyOverride: true);

        expect(copy.keyOverride, isNull);
        expect(copy.roleOverride, original.roleOverride);
      });

      test('creates copy with clearNotes sets to null', () {
        final copy = original.copyWith(clearNotes: true);

        expect(copy.notes, isNull);
        expect(copy.keyOverride, original.keyOverride);
      });

      test('creates copy with multiple clear flags', () {
        final copy = original.copyWith(
          clearRoleOverride: true,
          clearKeyOverride: true,
        );

        expect(copy.roleOverride, isNull);
        expect(copy.keyOverride, isNull);
        expect(copy.notes, original.notes);
      });

      test('creates copy with value override takes precedence over clear', () {
        final copy = original.copyWith(
          roleOverride: 'drums',
          clearRoleOverride: true,
        );

        // clear flag should take precedence
        expect(copy.roleOverride, isNull);
      });
    });

    group('JSON serialization', () {
      test('toJson converts to JSON with all fields', () {
        final assignment = SetlistAssignment(
          oderId: 'member123',
          roleOverride: 'lead_guitar',
          keyOverride: 'G',
          notes: 'Use capo',
        );

        final json = assignment.toJson();

        expect(json['oderId'], 'member123');
        expect(json['roleOverride'], 'lead_guitar');
        expect(json['keyOverride'], 'G');
        expect(json['notes'], 'Use capo');
      });

      test('toJson converts with null fields', () {
        final assignment = SetlistAssignment(
          oderId: 'member456',
        );

        final json = assignment.toJson();

        expect(json['oderId'], 'member456');
        expect(json['roleOverride'], isNull);
        expect(json['keyOverride'], isNull);
        expect(json['notes'], isNull);
      });

      test('fromJson creates from JSON with all fields', () {
        final json = {
          'oderId': 'member789',
          'roleOverride': 'bass',
          'keyOverride': 'E',
          'notes': 'Standard tuning',
        };

        final assignment = SetlistAssignment.fromJson(json);

        expect(assignment.oderId, 'member789');
        expect(assignment.roleOverride, 'bass');
        expect(assignment.keyOverride, 'E');
        expect(assignment.notes, 'Standard tuning');
      });

      test('fromJson creates from JSON with missing fields', () {
        final json = {
          'oderId': 'member999',
        };

        final assignment = SetlistAssignment.fromJson(json);

        expect(assignment.oderId, 'member999');
        expect(assignment.roleOverride, isNull);
        expect(assignment.keyOverride, isNull);
        expect(assignment.notes, isNull);
      });

      test('fromJson creates from JSON with default for oderId', () {
        final json = <String, dynamic>{};

        final assignment = SetlistAssignment.fromJson(json);

        expect(assignment.oderId, '');
      });

      test('round-trip serialization preserves all values', () {
        final original = SetlistAssignment(
          oderId: 'member123',
          roleOverride: 'vocals',
          keyOverride: 'F',
          notes: 'Harmony part',
        );

        final json = original.toJson();
        final restored = SetlistAssignment.fromJson(json);

        expect(restored.oderId, original.oderId);
        expect(restored.roleOverride, original.roleOverride);
        expect(restored.keyOverride, original.keyOverride);
        expect(restored.notes, original.notes);
      });
    });
  });

  group('Link', () {
    test('constructor creates with required fields', () {
      const link = Link(
        id: 'link1',
        url: 'https://example.com',
      );

      expect(link.id, 'link1');
      expect(link.url, 'https://example.com');
      expect(link.type, 'other');
      expect(link.title, isNull);
    });

    test('constructor creates with all fields', () {
      const link = Link(
        id: 'link2',
        url: 'https://youtube.com/watch?v=abc123',
        type: 'youtube',
        title: 'Official Music Video',
      );

      expect(link.id, 'link2');
      expect(link.url, 'https://youtube.com/watch?v=abc123');
      expect(link.type, 'youtube');
      expect(link.title, 'Official Music Video');
    });

    test('constructor with different link types', () {
      const youtube = Link(id: '1', url: 'https://youtube.com', type: 'youtube');
      const spotify = Link(id: '2', url: 'https://spotify.com', type: 'spotify');
      const apple = Link(id: '3', url: 'https://music.apple.com', type: 'apple_music');
      const other = Link(id: '4', url: 'https://other.com', type: 'other');

      expect(youtube.type, 'youtube');
      expect(spotify.type, 'spotify');
      expect(apple.type, 'apple_music');
      expect(other.type, 'other');
    });

    group('copyWith', () {
      const original = Link(
        id: 'link1',
        url: 'https://youtube.com/original',
        type: 'youtube',
        title: 'Original Title',
      );

      test('creates copy with all fields unchanged when no params', () {
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.url, original.url);
        expect(copy.type, original.type);
        expect(copy.title, original.title);
      });

      test('creates copy with modified id', () {
        final copy = original.copyWith(id: 'link2');

        expect(copy.id, 'link2');
        expect(copy.url, original.url);
      });

      test('creates copy with modified url', () {
        final copy = original.copyWith(url: 'https://youtube.com/new');

        expect(copy.url, 'https://youtube.com/new');
        expect(copy.id, original.id);
      });

      test('creates copy with modified type', () {
        final copy = original.copyWith(type: 'spotify');

        expect(copy.type, 'spotify');
        expect(copy.url, original.url);
      });

      test('creates copy with modified title', () {
        final copy = original.copyWith(title: 'New Title');

        expect(copy.title, 'New Title');
        expect(copy.type, original.type);
      });

      test('creates copy with multiple modified fields', () {
        final copy = original.copyWith(
          url: 'https://spotify.com/track',
          type: 'spotify',
          title: 'Spotify Track',
        );

        expect(copy.url, 'https://spotify.com/track');
        expect(copy.type, 'spotify');
        expect(copy.title, 'Spotify Track');
        expect(copy.id, original.id);
      });
    });

    group('JSON serialization', () {
      test('toJson converts to JSON with all fields', () {
        const link = Link(
          id: 'link1',
          url: 'https://youtube.com/watch?v=abc',
          type: 'youtube',
          title: 'Music Video',
        );

        final json = link.toJson();

        expect(json['id'], 'link1');
        expect(json['url'], 'https://youtube.com/watch?v=abc');
        expect(json['type'], 'youtube');
        expect(json['title'], 'Music Video');
      });

      test('toJson converts with null title', () {
        const link = Link(
          id: 'link2',
          url: 'https://example.com',
        );

        final json = link.toJson();

        expect(json['id'], 'link2');
        expect(json['url'], 'https://example.com');
        expect(json['type'], 'other');
        expect(json['title'], isNull);
      });

      test('fromJson creates from JSON with all fields', () {
        final json = {
          'id': 'link3',
          'url': 'https://spotify.com/track/xyz',
          'type': 'spotify',
          'title': 'Spotify Track',
        };

        final link = Link.fromJson(json);

        expect(link.id, 'link3');
        expect(link.url, 'https://spotify.com/track/xyz');
        expect(link.type, 'spotify');
        expect(link.title, 'Spotify Track');
      });

      test('fromJson creates from JSON with missing fields', () {
        final json = {
          'id': 'link4',
          'url': 'https://example.com',
        };

        final link = Link.fromJson(json);

        expect(link.id, 'link4');
        expect(link.url, 'https://example.com');
        expect(link.type, 'other'); // default
        expect(link.title, ''); // defaultValue from JsonKey
      });

      test('fromJson creates from JSON with default values', () {
        final json = <String, dynamic>{};

        final link = Link.fromJson(json);

        expect(link.id, '');
        expect(link.url, '');
        expect(link.type, 'other');
        expect(link.title, ''); // defaultValue from JsonKey
      });

      test('round-trip serialization preserves all values', () {
        const original = Link(
          id: 'link1',
          url: 'https://youtube.com/watch?v=test',
          type: 'youtube',
          title: 'Test Video',
        );

        final json = original.toJson();
        final restored = Link.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.url, original.url);
        expect(restored.type, original.type);
        expect(restored.title, original.title);
      });
    });
  });
}
