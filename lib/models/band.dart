import 'dart:math';
import 'package:json_annotation/json_annotation.dart';

part 'band.g.dart';

// Sentinel value to detect if a parameter was passed to copyWith
const Object _sentinel = _Sentinel();

class _Sentinel {
  const _Sentinel();
  @override
  String toString() => '_sentinel';
}

/// Band member with role and permission information.
///
/// Represents a user's membership in a band, including their
/// permission level and musical roles.
///
/// Example usage:
/// ```dart
/// final member = BandMember(
///   uid: 'user123',
///   role: BandMember.roleEditor,
///   displayName: 'John Doe',
///   musicRoles: ['guitarist', 'vocalist'],
/// );
/// ```
@JsonSerializable()
class BandMember {
  /// User's unique identifier.
  @JsonKey(defaultValue: '')
  final String uid;

  /// Permission role: 'admin', 'editor', or 'viewer'.
  ///
  /// - admin: Full access including member management
  /// - editor: Can add/edit songs and setlists
  /// - viewer: Read-only access
  @JsonKey(defaultValue: 'viewer')
  final String role;

  /// Display name for the member.
  final String? displayName;

  /// Email address of the member.
  final String? email;

  /// Musical roles: guitarist, vocalist, drummer, bassist, etc.
  @JsonKey(defaultValue: [])
  final List<String> musicRoles;

  /// Creates a new [BandMember] with the specified values.
  BandMember({
    required this.uid,
    required this.role,
    this.displayName,
    this.email,
    this.musicRoles = const [],
  });

  Map<String, dynamic> toJson() => _$BandMemberToJson(this);

  factory BandMember.fromJson(Map<String, dynamic> json) =>
      _$BandMemberFromJson(json);

  BandMember copyWith({
    String? uid,
    String? role,
    String? displayName,
    String? email,
    List<String>? musicRoles,
  }) {
    return BandMember(
      uid: uid ?? this.uid,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      musicRoles: musicRoles ?? this.musicRoles,
    );
  }

  /// Admin role constant - full access to band resources.
  static const String roleAdmin = 'admin';

  /// Editor role constant - can add/edit songs and setlists.
  static const String roleEditor = 'editor';

  /// Viewer role constant - read-only access.
  static const String roleViewer = 'viewer';
}

/// Band model for collaborative music organization.
///
/// Represents a group of musicians sharing songs, setlists,
/// and rehearsal materials. Supports role-based access control
/// and invite-based membership.
///
/// Example usage:
/// ```dart
/// final band = Band(
///   id: 'band123',
///   name: 'The Rockers',
///   description: 'Weekend rock band',
///   createdBy: 'user456',
///   members: [adminMember, editorMember],
///   createdAt: DateTime.now(),
/// );
/// ```
@JsonSerializable()
class Band {
  /// Unique identifier for the band.
  @JsonKey(defaultValue: '')
  final String id;

  /// Band name.
  @JsonKey(defaultValue: '')
  final String name;

  /// Optional description of the band.
  final String? description;

  /// User ID who created the band.
  @JsonKey(defaultValue: '')
  final String createdBy;

  /// List of band members with their roles.
  @JsonKey(defaultValue: [], fromJson: _membersFromJson, toJson: _membersToJson)
  final List<BandMember> members;

  /// Derived list of all member UIDs for efficient security rules.
  @JsonKey(defaultValue: [])
  final List<String> memberUids;

  /// Derived list of admin UIDs for efficient security rules.
  @JsonKey(defaultValue: [])
  final List<String> adminUids;

  /// Derived list of editor UIDs for efficient security rules.
  @JsonKey(defaultValue: [])
  final List<String> editorUids;

  /// Tags for organization and filtering.
  @JsonKey(defaultValue: [])
  final List<String> tags;

  /// Unique 6-character invite code for joining the band.
  final String? inviteCode;

  /// Creation timestamp.
  @JsonKey(fromJson: _parseDateTime, toJson: _dateTimeToJson)
  final DateTime createdAt;

  /// Creates a new [Band] with the specified values.
  ///
  /// Automatically derives [memberUids], [adminUids], and [editorUids]
  /// from the members list if not explicitly provided.
  Band({
    required this.id,
    required this.name,
    this.description,
    required this.createdBy,
    this.members = const [],
    List<String>? memberUids,
    List<String>? adminUids,
    List<String>? editorUids,
    this.tags = const [],
    this.inviteCode,
    required this.createdAt,
  }) : memberUids = memberUids ?? members.map((m) => m.uid).toList(),
       adminUids =
           adminUids ??
           members
               .where((m) => m.role == BandMember.roleAdmin)
               .map((m) => m.uid)
               .toList(),
       editorUids =
           editorUids ??
           members
               .where((m) => m.role == BandMember.roleEditor)
               .where((m) => m.role != BandMember.roleAdmin)
               .map((m) => m.uid)
               .toList();

  Band copyWith({
    String? id,
    String? name,
    Object? description = _sentinel,
    String? createdBy,
    List<BandMember>? members,
    List<String>? memberUids,
    List<String>? adminUids,
    List<String>? editorUids,
    List<String>? tags,
    Object? inviteCode = _sentinel,
    DateTime? createdAt,
  }) {
    // Use provided members or existing members
    final newMembers = members ?? this.members;
    // Recalculate memberUids, adminUids, and editorUids if members changed and not explicitly provided
    final newMemberUids = memberUids ?? newMembers.map((m) => m.uid).toList();
    final newAdminUids =
        adminUids ??
        newMembers
            .where((m) => m.role == BandMember.roleAdmin)
            .map((m) => m.uid)
            .toList();
    final newEditorUids =
        editorUids ??
        newMembers
            .where((m) => m.role == BandMember.roleEditor)
            .where((m) => m.role != BandMember.roleAdmin)
            .map((m) => m.uid)
            .toList();

    return Band(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description == _sentinel
          ? this.description
          : description as String?,
      createdBy: createdBy ?? this.createdBy,
      members: newMembers,
      memberUids: newMemberUids,
      adminUids: newAdminUids,
      editorUids: newEditorUids,
      tags: tags ?? this.tags,
      inviteCode: inviteCode == _sentinel
          ? this.inviteCode
          : inviteCode as String?,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converts this band to JSON format.
  ///
  /// Used for serializing to Firestore.
  Map<String, dynamic> toJson() => _$BandToJson(this);

  /// Creates a [Band] from JSON data.
  ///
  /// Used for deserializing Firestore documents.
  factory Band.fromJson(Map<String, dynamic> json) => _$BandFromJson(json);

  /// Generates a unique 6-character invite code using cryptographically secure random.
  ///
  /// The code consists of uppercase letters and digits (36 characters total).
  /// Collision handling should be done at the service layer.
  ///
  /// Example:
  /// ```dart
  /// final code = Band.generateUniqueInviteCode();
  /// // Returns something like 'A7X9K2'
  /// ```
  static String generateUniqueInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += chars[random.nextInt(chars.length)];
    }
    return code;
  }
}

DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  return DateTime.parse(value as String);
}

String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();

List<BandMember> _membersFromJson(dynamic value) {
  if (value == null) return [];
  if (value is List<BandMember>) return value;
  return (value as List<dynamic>)
      .map((e) => BandMember.fromJson(e as Map<String, dynamic>))
      .toList();
}

List<Map<String, dynamic>> _membersToJson(List<BandMember> members) {
  return members.map((m) => m.toJson()).toList();
}
