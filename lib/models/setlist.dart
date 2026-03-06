import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'setlist_assignment.dart';
import 'band.dart';

part 'setlist.g.dart';

// Sentinel value to detect if a parameter was passed to copyWith
const Object _sentinel = _Sentinel();

class _Sentinel {
  const _Sentinel();
  @override
  String toString() => '_sentinel';
}

/// Setlist model for organizing songs for events and performances.
///
/// Represents a collection of songs arranged for a specific event,
/// with optional date, location, and member assignments.
///
/// Example usage:
/// ```dart
/// final setlist = Setlist(
///   id: 'setlist123',
///   bandId: 'band456',
///   name: 'Summer Gig 2026',
///   eventDateTime: DateTime(2026, 7, 15, 20, 0),
///   eventLocation: 'The Music Hall',
///   songIds: ['song1', 'song2', 'song3'],
///   createdAt: DateTime.now(),
///   updatedAt: DateTime.now(),
/// );
/// ```
@JsonSerializable()
class Setlist {
  /// Unique identifier for the setlist.
  @JsonKey(defaultValue: '')
  final String id;

  /// ID of the band this setlist belongs to.
  @JsonKey(defaultValue: '')
  final String bandId;

  /// Human-readable name for the setlist.
  @JsonKey(defaultValue: '')
  final String name;

  /// Optional description or notes about the event.
  final String? description;

  /// Date and time of the event.
  @JsonKey(fromJson: _parseTimestamp, toJson: _dateTimeToJson)
  final DateTime? eventDateTime;

  /// Location/venue of the event.
  final String? eventLocation;

  /// Ordered list of song IDs in the setlist.
  @JsonKey(defaultValue: [])
  final List<String> songIds;

  /// Total duration of all songs in milliseconds.
  final int? totalDuration;

  /// Member assignments with role overrides and notes.
  /// Key is member UID, value is assignment details.
  @JsonKey(
    defaultValue: {},
    fromJson: _assignmentsFromJson,
    toJson: _assignmentsToJson,
  )
  final Map<String, SetlistAssignment> assignments;

  /// Creation timestamp.
  @JsonKey(fromJson: _parseDateTime, toJson: _dateTimeToJson)
  final DateTime createdAt;

  /// Last update timestamp.
  @JsonKey(fromJson: _parseDateTime, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  /// Creates a new [Setlist] with the specified values.
  Setlist({
    required this.id,
    required this.bandId,
    required this.name,
    this.description,
    this.eventDateTime,
    this.eventLocation,
    this.songIds = const [],
    this.totalDuration,
    this.assignments = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  Setlist copyWith({
    String? id,
    String? bandId,
    String? name,
    Object? description = _sentinel,
    Object? eventDateTime = _sentinel,
    Object? eventLocation = _sentinel,
    List<String>? songIds,
    Object? totalDuration = _sentinel,
    Map<String, SetlistAssignment>? assignments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Setlist(
      id: id ?? this.id,
      bandId: bandId ?? this.bandId,
      name: name ?? this.name,
      description: description == _sentinel
          ? this.description
          : description as String?,
      eventDateTime: eventDateTime == _sentinel
          ? this.eventDateTime
          : eventDateTime as DateTime?,
      eventLocation: eventLocation == _sentinel
          ? this.eventLocation
          : eventLocation as String?,
      songIds: songIds ?? this.songIds,
      totalDuration: totalDuration == _sentinel
          ? this.totalDuration
          : totalDuration as int?,
      assignments: assignments ?? this.assignments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Converts this setlist to JSON format.
  ///
  /// Used for serializing to Firestore.
  Map<String, dynamic> toJson() => _$SetlistToJson(this);

  /// Creates a [Setlist] from JSON data.
  ///
  /// Used for deserializing Firestore documents.
  factory Setlist.fromJson(Map<String, dynamic> json) =>
      _$SetlistFromJson(json);

  /// Formatted event date string for UI display.
  ///
  /// Returns date in DD.MM.YYYY format, or empty string if no date set.
  String get formattedEventDate {
    if (eventDateTime == null) return '';
    return '${eventDateTime!.day.toString().padLeft(2, '0')}.${eventDateTime!.month.toString().padLeft(2, '0')}.${eventDateTime!.year}';
  }

  /// Gets list of participants for this setlist based on band members and assignments.
  ///
  /// Returns a list of participant info maps containing:
  /// - 'uid': Member's user ID
  /// - 'name': Display name or email
  /// - 'role': Member's role in the band
  List<Map<String, String>> getParticipants(List<BandMember> bandMembers) {
    final participants = <Map<String, String>>[];

    for (final member in bandMembers) {
      final participant = <String, String>{
        'uid': member.uid,
        'name': member.displayName ?? member.email ?? 'Unknown',
        'role': member.role,
      };
      participants.add(participant);
    }

    return participants;
  }
}

DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  try {
    if (value.runtimeType.toString() == 'Timestamp') {
      return (value as dynamic).toDate() as DateTime;
    }
  } catch (_) {}
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {}
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return DateTime.now();
}

DateTime? _parseTimestamp(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  try {
    if (value.runtimeType.toString() == 'Timestamp') {
      return (value as dynamic).toDate() as DateTime;
    }
  } catch (_) {}
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  return null;
}

String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();

Map<String, SetlistAssignment> _assignmentsFromJson(dynamic value) {
  if (value == null) return {};
  if (value is Map) {
    final result = <String, SetlistAssignment>{};
    for (final entry in value.entries) {
      final key = entry.key.toString();
      if (entry.value is Map) {
        result[key] = SetlistAssignment.fromJson(
          Map<String, dynamic>.from(entry.value),
        );
      } else {
        result[key] = SetlistAssignment(oderId: key);
      }
    }
    return result;
  }
  return {};
}

Map<String, dynamic> _assignmentsToJson(Map<String, SetlistAssignment> value) {
  return value.map((key, val) => MapEntry(key, val.toJson()));
}
