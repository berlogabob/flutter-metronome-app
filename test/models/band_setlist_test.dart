// Test file for Band and Setlist models

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metronome_app/models/band.dart';
import 'package:metronome_app/models/setlist.dart';
import 'package:metronome_app/models/setlist_assignment.dart';

void main() {
  group('BandMember', () {
    test('constructor creates with required fields', () {
      final member = BandMember(
        uid: 'user123',
        role: BandMember.roleViewer,
      );

      expect(member.uid, 'user123');
      expect(member.role, BandMember.roleViewer);
      expect(member.displayName, isNull);
      expect(member.email, isNull);
      expect(member.musicRoles, isEmpty);
    });

    test('constructor creates with all fields', () {
      final member = BandMember(
        uid: 'user456',
        role: BandMember.roleEditor,
        displayName: 'John Doe',
        email: 'john@example.com',
        musicRoles: ['guitarist', 'vocalist'],
      );

      expect(member.uid, 'user456');
      expect(member.role, BandMember.roleEditor);
      expect(member.displayName, 'John Doe');
      expect(member.email, 'john@example.com');
      expect(member.musicRoles, ['guitarist', 'vocalist']);
    });

    test('constructor with admin role', () {
      final member = BandMember(
        uid: 'user789',
        role: BandMember.roleAdmin,
      );

      expect(member.role, BandMember.roleAdmin);
    });

    group('copyWith', () {
      final original = BandMember(
        uid: 'user123',
        role: BandMember.roleViewer,
        displayName: 'Original',
        email: 'original@example.com',
        musicRoles: ['guitarist'],
      );

      test('creates copy with all fields unchanged when no params', () {
        final copy = original.copyWith();

        expect(copy.uid, original.uid);
        expect(copy.role, original.role);
        expect(copy.displayName, original.displayName);
        expect(copy.email, original.email);
        expect(copy.musicRoles, original.musicRoles);
      });

      test('creates copy with modified uid', () {
        final copy = original.copyWith(uid: 'user456');
        expect(copy.uid, 'user456');
        expect(copy.role, original.role);
      });

      test('creates copy with modified role', () {
        final copy = original.copyWith(role: BandMember.roleEditor);
        expect(copy.role, BandMember.roleEditor);
        expect(copy.uid, original.uid);
      });

      test('creates copy with modified displayName', () {
        final copy = original.copyWith(displayName: 'Updated');
        expect(copy.displayName, 'Updated');
        expect(copy.email, original.email);
      });

      test('creates copy with modified email', () {
        final copy = original.copyWith(email: 'new@example.com');
        expect(copy.email, 'new@example.com');
        expect(copy.displayName, original.displayName);
      });

      test('creates copy with modified musicRoles', () {
        final copy = original.copyWith(musicRoles: ['drummer', 'vocalist']);
        expect(copy.musicRoles, ['drummer', 'vocalist']);
        expect(copy.uid, original.uid);
      });

      test('creates copy with multiple modified fields', () {
        final copy = original.copyWith(
          role: BandMember.roleAdmin,
          displayName: 'Admin User',
          musicRoles: ['guitarist', 'bassist'],
        );

        expect(copy.role, BandMember.roleAdmin);
        expect(copy.displayName, 'Admin User');
        expect(copy.musicRoles, ['guitarist', 'bassist']);
        expect(copy.uid, original.uid);
      });
    });

    group('JSON serialization', () {
      test('toJson converts to JSON with all fields', () {
        final member = BandMember(
          uid: 'user123',
          role: BandMember.roleEditor,
          displayName: 'Test User',
          email: 'test@example.com',
          musicRoles: ['guitarist'],
        );

        final json = member.toJson();

        expect(json['uid'], 'user123');
        expect(json['role'], BandMember.roleEditor);
        expect(json['displayName'], 'Test User');
        expect(json['email'], 'test@example.com');
        expect(json['musicRoles'], ['guitarist']);
      });

      test('toJson converts with null fields', () {
        final member = BandMember(
          uid: 'user456',
          role: BandMember.roleViewer,
        );

        final json = member.toJson();

        expect(json['uid'], 'user456');
        expect(json['role'], BandMember.roleViewer);
        expect(json['displayName'], isNull);
        expect(json['email'], isNull);
        expect(json['musicRoles'], []);
      });

      test('fromJson creates from JSON with all fields', () {
        final json = {
          'uid': 'user789',
          'role': BandMember.roleAdmin,
          'displayName': 'Admin User',
          'email': 'admin@example.com',
          'musicRoles': ['bassist', 'vocalist'],
        };

        final member = BandMember.fromJson(json);

        expect(member.uid, 'user789');
        expect(member.role, BandMember.roleAdmin);
        expect(member.displayName, 'Admin User');
        expect(member.email, 'admin@example.com');
        expect(member.musicRoles, ['bassist', 'vocalist']);
      });

      test('fromJson creates from JSON with missing fields', () {
        final json = {
          'uid': 'user999',
          'role': BandMember.roleViewer,
        };

        final member = BandMember.fromJson(json);

        expect(member.uid, 'user999');
        expect(member.role, BandMember.roleViewer);
        expect(member.displayName, isNull);
        expect(member.email, isNull);
        expect(member.musicRoles, []);
      });

      test('fromJson uses defaults for missing fields', () {
        final json = <String, dynamic>{};

        final member = BandMember.fromJson(json);

        expect(member.uid, '');
        expect(member.role, BandMember.roleViewer);
        expect(member.musicRoles, []);
      });

      test('round-trip preserves all values', () {
        final original = BandMember(
          uid: 'user123',
          role: BandMember.roleEditor,
          displayName: 'Round Trip',
          email: 'roundtrip@example.com',
          musicRoles: ['drummer'],
        );

        final json = original.toJson();
        final restored = BandMember.fromJson(json);

        expect(restored.uid, original.uid);
        expect(restored.role, original.role);
        expect(restored.displayName, original.displayName);
        expect(restored.email, original.email);
        expect(restored.musicRoles, original.musicRoles);
      });
    });

    group('role constants', () {
      test('roleAdmin is admin', () {
        expect(BandMember.roleAdmin, 'admin');
      });

      test('roleEditor is editor', () {
        expect(BandMember.roleEditor, 'editor');
      });

      test('roleViewer is viewer', () {
        expect(BandMember.roleViewer, 'viewer');
      });
    });
  });

  group('Band', () {
    test('constructor creates with required fields', () {
      final band = Band(
        id: 'band123',
        name: 'Test Band',
        createdBy: 'user123',
        inviteCode: 'ABC123',
        members: [],
        createdAt: DateTime(2026, 1, 1),
      );

      expect(band.id, 'band123');
      expect(band.name, 'Test Band');
      expect(band.inviteCode, 'ABC123');
      expect(band.members, isEmpty);
      expect(band.createdAt, DateTime(2026, 1, 1));
      expect(band.createdBy, 'user123');
    });

    test('constructor creates with all fields', () {
      final member = BandMember(
        uid: 'user123',
        role: BandMember.roleAdmin,
        displayName: 'Founder',
      );

      final band = Band(
        id: 'band456',
        name: 'Full Band',
        description: 'A test band with all fields',
        createdBy: 'user456',
        inviteCode: 'XYZ789',
        members: [member],
        createdAt: DateTime(2026, 1, 1),
      );

      expect(band.id, 'band456');
      expect(band.name, 'Full Band');
      expect(band.description, 'A test band with all fields');
      expect(band.inviteCode, 'XYZ789');
      expect(band.members.length, 1);
      expect(band.members.first.uid, 'user123');
    });

    group('copyWith', () {
      final original = Band(
        id: 'band123',
        name: 'Original Band',
        description: 'Original description',
        createdBy: 'user123',
        inviteCode: 'CODE1',
        members: [],
        createdAt: DateTime(2026, 1, 1),
      );

      test('creates copy with all fields unchanged when no params', () {
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.name, original.name);
        expect(copy.description, original.description);
        expect(copy.inviteCode, original.inviteCode);
        expect(copy.members, original.members);
      });

      test('creates copy with modified name', () {
        final copy = original.copyWith(name: 'Updated Band');
        expect(copy.name, 'Updated Band');
        expect(copy.id, original.id);
      });

      test('creates copy with modified description', () {
        final copy = original.copyWith(description: 'New description');
        expect(copy.description, 'New description');
      });

      test('creates copy with modified inviteCode', () {
        final copy = original.copyWith(inviteCode: 'NEWCODE');
        expect(copy.inviteCode, 'NEWCODE');
      });

      test('creates copy with modified members', () {
        final newMember = BandMember(
          uid: 'user456',
          role: BandMember.roleEditor,
        );
        final copy = original.copyWith(members: [newMember]);
        expect(copy.members.length, 1);
        expect(copy.members.first.uid, 'user456');
      });

      test('creates copy with multiple modified fields', () {
        final copy = original.copyWith(
          name: 'New Name',
          inviteCode: 'NEW123',
          description: 'New desc',
        );

        expect(copy.name, 'New Name');
        expect(copy.inviteCode, 'NEW123');
        expect(copy.description, 'New desc');
      });
    });

    group('JSON serialization', () {
      test('toJson converts to JSON with all fields', () {
        final member = BandMember(
          uid: 'user123',
          role: BandMember.roleAdmin,
        );
        final band = Band(
          id: 'band1',
          name: 'Test',
          description: 'Desc',
          createdBy: 'user123',
          inviteCode: 'CODE',
          members: [member],
          createdAt: DateTime(2026, 1, 1),
        );

        final json = band.toJson();

        expect(json['id'], 'band1');
        expect(json['name'], 'Test');
        expect(json['description'], 'Desc');
        expect(json['inviteCode'], 'CODE');
        expect(json['members'], isList);
      });

      test('fromJson creates from JSON with all fields', () {
        final json = {
          'id': 'band2',
          'name': 'From JSON',
          'description': 'JSON description',
          'inviteCode': 'JSON123',
          'members': [],
          'createdAt': '2026-01-01T00:00:00.000',
          'updatedAt': '2026-01-02T00:00:00.000',
        };

        final band = Band.fromJson(json);

        expect(band.id, 'band2');
        expect(band.name, 'From JSON');
        expect(band.description, 'JSON description');
        expect(band.inviteCode, 'JSON123');
        expect(band.members, isEmpty);
      });

      test('fromJson uses defaults for missing fields', () {
        final json = <String, dynamic>{};

        final band = Band.fromJson(json);

        expect(band.id, '');
        expect(band.name, ''); // @JsonKey(defaultValue: '')
        expect(band.inviteCode, isNull); // no default
        expect(band.members, []);
      });

      test('round-trip preserves values', () {
        final original = Band(
          id: 'band3',
          name: 'Round Trip',
          description: 'Test description',
          createdBy: 'user3',
          inviteCode: 'RT123',
          members: [],
          createdAt: DateTime(2026, 3, 15),
        );

        final json = original.toJson();
        final restored = Band.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.description, original.description);
        expect(restored.inviteCode, original.inviteCode);
      });
    });
  });

  group('Setlist', () {
    test('constructor creates with required fields', () {
      final setlist = Setlist(
        id: 'setlist123',
        bandId: 'band456',
        name: 'Test Setlist',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      expect(setlist.id, 'setlist123');
      expect(setlist.bandId, 'band456');
      expect(setlist.name, 'Test Setlist');
      expect(setlist.description, isNull);
      expect(setlist.eventDateTime, isNull);
      expect(setlist.eventLocation, isNull);
      expect(setlist.songIds, isEmpty);
      expect(setlist.totalDuration, isNull);
      expect(setlist.assignments, isEmpty);
    });

    test('constructor creates with all fields', () {
      final assignment = SetlistAssignment(
        oderId: 'user123',
        roleOverride: 'guitarist',
      );

      final setlist = Setlist(
        id: 'setlist456',
        bandId: 'band789',
        name: 'Full Setlist',
        description: 'Summer gig setlist',
        eventDateTime: DateTime(2026, 7, 15, 20, 0),
        eventLocation: 'Music Hall',
        songIds: ['song1', 'song2', 'song3'],
        totalDuration: 7200000, // 2 hours
        assignments: {'user123': assignment},
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 6, 1),
      );

      expect(setlist.id, 'setlist456');
      expect(setlist.bandId, 'band789');
      expect(setlist.name, 'Full Setlist');
      expect(setlist.description, 'Summer gig setlist');
      expect(setlist.eventDateTime, DateTime(2026, 7, 15, 20, 0));
      expect(setlist.eventLocation, 'Music Hall');
      expect(setlist.songIds, ['song1', 'song2', 'song3']);
      expect(setlist.totalDuration, 7200000);
      expect(setlist.assignments.containsKey('user123'), isTrue);
    });

    group('copyWith', () {
      final original = Setlist(
        id: 'setlist1',
        bandId: 'band1',
        name: 'Original',
        description: 'Original desc',
        eventDateTime: DateTime(2026, 7, 1),
        eventLocation: 'Venue 1',
        songIds: ['song1'],
        totalDuration: 3600000,
        assignments: {},
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );

      test('creates copy with all fields unchanged when no params', () {
        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.name, original.name);
        expect(copy.songIds, original.songIds);
      });

      test('creates copy with modified name', () {
        final copy = original.copyWith(name: 'Updated Setlist');
        expect(copy.name, 'Updated Setlist');
        expect(copy.bandId, original.bandId);
      });

      test('creates copy with modified description', () {
        final copy = original.copyWith(description: 'New description');
        expect(copy.description, 'New description');
      });

      test('creates copy with modified eventDateTime', () {
        final newDate = DateTime(2026, 12, 25);
        final copy = original.copyWith(eventDateTime: newDate);
        expect(copy.eventDateTime, newDate);
      });

      test('creates copy with modified eventLocation', () {
        final copy = original.copyWith(eventLocation: 'New Venue');
        expect(copy.eventLocation, 'New Venue');
      });

      test('creates copy with modified songIds', () {
        final copy = original.copyWith(songIds: ['song1', 'song2']);
        expect(copy.songIds.length, 2);
      });

      test('creates copy with modified totalDuration', () {
        final copy = original.copyWith(totalDuration: 5400000);
        expect(copy.totalDuration, 5400000);
      });

      test('creates copy with modified assignments', () {
        final assignment = SetlistAssignment(oderId: 'user999');
        final copy = original.copyWith(assignments: {'user999': assignment});
        expect(copy.assignments.containsKey('user999'), isTrue);
      });

      test('creates copy with multiple modified fields', () {
        final copy = original.copyWith(
          name: 'New Name',
          eventLocation: 'New Venue',
          songIds: ['song1', 'song2', 'song3'],
        );

        expect(copy.name, 'New Name');
        expect(copy.eventLocation, 'New Venue');
        expect(copy.songIds.length, 3);
      });
    });

    group('JSON serialization', () {
      test('toJson converts to JSON with all fields', () {
        final setlist = Setlist(
          id: 'setlist1',
          bandId: 'band1',
          name: 'Test',
          description: 'Desc',
          eventDateTime: DateTime(2026, 7, 15),
          eventLocation: 'Venue',
          songIds: ['song1'],
          totalDuration: 3600000,
          assignments: {},
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        final json = setlist.toJson();

        expect(json['id'], 'setlist1');
        expect(json['name'], 'Test');
        expect(json['songIds'], ['song1']);
      });

      test('fromJson creates from JSON with all fields', () {
        final json = {
          'id': 'setlist2',
          'bandId': 'band2',
          'name': 'From JSON',
          'description': 'JSON desc',
          'eventDateTime': Timestamp.fromDate(DateTime(2026, 8, 20)),
          'eventLocation': 'JSON Venue',
          'songIds': ['song1', 'song2'],
          'totalDuration': 5400000,
          'assignments': {},
          'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
          'updatedAt': Timestamp.fromDate(DateTime(2026, 1, 2)),
        };

        final setlist = Setlist.fromJson(json);

        expect(setlist.id, 'setlist2');
        expect(setlist.name, 'From JSON');
        expect(setlist.songIds, ['song1', 'song2']);
      });

      test('fromJson uses defaults for missing fields', () {
        final json = <String, dynamic>{};

        final setlist = Setlist.fromJson(json);

        expect(setlist.id, '');
        expect(setlist.bandId, '');
        expect(setlist.name, '');
        expect(setlist.songIds, []);
        expect(setlist.assignments, {});
      });

      test('round-trip preserves values', () {
        final original = Setlist(
          id: 'setlist3',
          bandId: 'band3',
          name: 'Round Trip',
          description: 'Test',
          songIds: ['song1', 'song2'],
          createdAt: DateTime(2026, 2, 1),
          updatedAt: DateTime(2026, 2, 2),
        );

        final json = original.toJson();
        final restored = Setlist.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.songIds, original.songIds);
      });
    });

    group('Setlist getters and helpers', () {
      test('formattedEventDate returns formatted date string', () {
        final setlist = Setlist(
          id: 'setlist1',
          bandId: 'band1',
          name: 'Test',
          eventDateTime: DateTime(2026, 7, 15),
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        expect(setlist.formattedEventDate, '15.07.2026');
      });

      test('formattedEventDate returns empty string when no date', () {
        final setlist = Setlist(
          id: 'setlist2',
          bandId: 'band1',
          name: 'Test',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        expect(setlist.formattedEventDate, '');
      });

      test('getParticipants returns band members as participants', () {
        final bandMembers = [
          BandMember(
            uid: 'user1',
            role: BandMember.roleAdmin,
            displayName: 'Admin User',
            email: 'admin@example.com',
            musicRoles: ['guitar'],
          ),
          BandMember(
            uid: 'user2',
            role: BandMember.roleEditor,
            displayName: 'Editor User',
            email: 'editor@example.com',
            musicRoles: ['vocals'],
          ),
        ];

        final setlist = Setlist(
          id: 'setlist3',
          bandId: 'band1',
          name: 'Test',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        final participants = setlist.getParticipants(bandMembers);

        expect(participants.length, 2);
        expect(participants[0]['uid'], 'user1');
        expect(participants[0]['name'], 'Admin User');
        expect(participants[0]['role'], 'admin');
        expect(participants[1]['uid'], 'user2');
        expect(participants[1]['name'], 'Editor User');
        expect(participants[1]['role'], 'editor');
      });

      test('getParticipants uses email when displayName is null', () {
        final bandMembers = [
          BandMember(
            uid: 'user1',
            role: BandMember.roleViewer,
            email: 'user@example.com',
          ),
        ];

        final setlist = Setlist(
          id: 'setlist4',
          bandId: 'band1',
          name: 'Test',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        final participants = setlist.getParticipants(bandMembers);

        expect(participants.length, 1);
        expect(participants[0]['name'], 'user@example.com');
      });

      test('getParticipants uses Unknown when both name and email are null', () {
        final bandMembers = [
          BandMember(
            uid: 'user1',
            role: BandMember.roleViewer,
          ),
        ];

        final setlist = Setlist(
          id: 'setlist5',
          bandId: 'band1',
          name: 'Test',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        final participants = setlist.getParticipants(bandMembers);

        expect(participants.length, 1);
        expect(participants[0]['name'], 'Unknown');
      });
    });

    group('Setlist copyWith sentinel values', () {
      test('copyWith can set description to null explicitly', () {
        final original = Setlist(
          id: 'setlist1',
          bandId: 'band1',
          name: 'Test',
          description: 'Original description',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        // Pass null explicitly to clear the field
        final copy = original.copyWith(description: null);
        expect(copy.description, isNull);
      });

      test('copyWith can set eventDateTime to null explicitly', () {
        final original = Setlist(
          id: 'setlist2',
          bandId: 'band1',
          name: 'Test',
          eventDateTime: DateTime(2026, 7, 15),
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        final copy = original.copyWith(eventDateTime: null);
        expect(copy.eventDateTime, isNull);
      });

      test('copyWith can set eventLocation to null explicitly', () {
        final original = Setlist(
          id: 'setlist3',
          bandId: 'band1',
          name: 'Test',
          eventLocation: 'Original Venue',
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        final copy = original.copyWith(eventLocation: null);
        expect(copy.eventLocation, isNull);
      });

      test('copyWith can set totalDuration to null explicitly', () {
        final original = Setlist(
          id: 'setlist4',
          bandId: 'band1',
          name: 'Test',
          totalDuration: 3600000,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        final copy = original.copyWith(totalDuration: null);
        expect(copy.totalDuration, isNull);
      });

      test('copyWith without params preserves sentinel-marked fields', () {
        final original = Setlist(
          id: 'setlist5',
          bandId: 'band1',
          name: 'Test',
          description: 'Description',
          eventDateTime: DateTime(2026, 7, 15),
          eventLocation: 'Venue',
          totalDuration: 3600000,
          createdAt: DateTime(2026, 1, 1),
          updatedAt: DateTime(2026, 1, 2),
        );

        final copy = original.copyWith();

        expect(copy.description, original.description);
        expect(copy.eventDateTime, original.eventDateTime);
        expect(copy.eventLocation, original.eventLocation);
        expect(copy.totalDuration, original.totalDuration);
      });
    });

    group('Band copyWith sentinel values', () {
      test('copyWith can set description to null explicitly', () {
        final original = Band(
          id: 'band1',
          name: 'Test Band',
          description: 'Original description',
          createdBy: 'user1',
          createdAt: DateTime(2026, 1, 1),
        );

        final copy = original.copyWith(description: null);
        expect(copy.description, isNull);
      });

      test('copyWith can set inviteCode to null explicitly', () {
        final original = Band(
          id: 'band2',
          name: 'Test Band',
          description: 'Description',
          createdBy: 'user1',
          inviteCode: 'ABC123',
          createdAt: DateTime(2026, 1, 1),
        );

        final copy = original.copyWith(inviteCode: null);
        expect(copy.inviteCode, isNull);
      });

      test('copyWith without params preserves sentinel-marked fields', () {
        final original = Band(
          id: 'band3',
          name: 'Test Band',
          description: 'Description',
          createdBy: 'user1',
          inviteCode: 'XYZ789',
          createdAt: DateTime(2026, 1, 1),
        );

        final copy = original.copyWith();

        expect(copy.description, original.description);
        expect(copy.inviteCode, original.inviteCode);
      });

      test('copyWith recalculates derived UIDs when members change', () {
        final adminMember = BandMember(
          uid: 'admin1',
          role: BandMember.roleAdmin,
        );
        final editorMember = BandMember(
          uid: 'editor1',
          role: BandMember.roleEditor,
        );
        final viewerMember = BandMember(
          uid: 'viewer1',
          role: BandMember.roleViewer,
        );

        final original = Band(
          id: 'band4',
          name: 'Test Band',
          createdBy: 'user1',
          members: [adminMember],
          createdAt: DateTime(2026, 1, 1),
        );

        // Add more members
        final copy = original.copyWith(
          members: [adminMember, editorMember, viewerMember],
        );

        expect(copy.memberUids.length, 3);
        expect(copy.adminUids, ['admin1']);
        expect(copy.editorUids, ['editor1']);
      });

      test('copyWith uses explicitly provided UIDs if given', () {
        final original = Band(
          id: 'band5',
          name: 'Test Band',
          createdBy: 'user1',
          members: [],
          createdAt: DateTime(2026, 1, 1),
        );

        final copy = original.copyWith(
          memberUids: ['custom1', 'custom2'],
          adminUids: ['admin1'],
          editorUids: ['editor1'],
        );

        expect(copy.memberUids, ['custom1', 'custom2']);
        expect(copy.adminUids, ['admin1']);
        expect(copy.editorUids, ['editor1']);
      });
    });

    group('Band static methods', () {
      test('generateUniqueInviteCode generates 6-character code', () {
        final code = Band.generateUniqueInviteCode();
        expect(code.length, 6);
      });

      test('generateUniqueInviteCode uses uppercase and digits', () {
        final code = Band.generateUniqueInviteCode();
        expect(
          code,
          matches(r'^[A-Z0-9]{6}$'),
        );
      });

      test('generateUniqueInviteCode generates different codes', () {
        final codes = Set<String>();
        for (int i = 0; i < 100; i++) {
          codes.add(Band.generateUniqueInviteCode());
        }
        // Should have high uniqueness (may have occasional collisions)
        expect(codes.length, greaterThan(90));
      });
    });
  });
}
