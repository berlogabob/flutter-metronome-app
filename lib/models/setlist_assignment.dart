import 'package:json_annotation/json_annotation.dart';

part 'setlist_assignment.g.dart';

/// Setlist assignment for a band member.
///
/// Represents a member's role and settings for a specific setlist,
/// including optional role and key overrides.
///
/// Example usage:
/// ```dart
/// final assignment = SetlistAssignment(
///   oderId: 'member123',
///   roleOverride: 'lead_guitar',
///   keyOverride: 'G',
///   notes: 'Use capo on 2nd fret',
/// );
/// ```
@JsonSerializable()
class SetlistAssignment {
  /// Member's order ID or user ID for the assignment.
  @JsonKey(defaultValue: '')
  final String oderId;

  /// Optional role override for this setlist.
  final String? roleOverride;

  /// Optional key override for this setlist.
  final String? keyOverride;

  /// Optional notes or instructions for this assignment.
  final String? notes;

  /// Creates a new [SetlistAssignment] with the specified values.
  SetlistAssignment({
    required this.oderId,
    this.roleOverride,
    this.keyOverride,
    this.notes,
  });

  SetlistAssignment copyWith({
    String? oderId,
    String? roleOverride,
    String? keyOverride,
    String? notes,
    bool clearRoleOverride = false,
    bool clearKeyOverride = false,
    bool clearNotes = false,
  }) {
    return SetlistAssignment(
      oderId: oderId ?? this.oderId,
      roleOverride: clearRoleOverride
          ? null
          : (roleOverride ?? this.roleOverride),
      keyOverride: clearKeyOverride ? null : (keyOverride ?? this.keyOverride),
      notes: clearNotes ? null : (notes ?? this.notes),
    );
  }

  /// Converts this assignment to JSON format.
  ///
  /// Used for serializing to Firestore.
  Map<String, dynamic> toJson() => _$SetlistAssignmentToJson(this);

  /// Creates a [SetlistAssignment] from JSON data.
  ///
  /// Used for deserializing Firestore documents.
  factory SetlistAssignment.fromJson(Map<String, dynamic> json) =>
      _$SetlistAssignmentFromJson(json);
}
