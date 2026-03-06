import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

// Sentinel value to detect if a parameter was passed to copyWith
const Object _sentinel = _Sentinel();

class _Sentinel {
  const _Sentinel();
  @override
  String toString() => '_sentinel';
}

/// Application user model.
///
/// Represents a registered user with their profile information
/// and band associations.
///
/// Example usage:
/// ```dart
/// final user = AppUser(
///   uid: 'user123',
///   displayName: 'John Doe',
///   email: 'john@example.com',
///   bandIds: ['band1', 'band2'],
///   baseTags: ['guitarist', 'vocalist'],
///   createdAt: DateTime.now(),
/// );
/// ```
@JsonSerializable()
class AppUser {
  /// User's unique identifier from Firebase Auth.
  @JsonKey(defaultValue: '')
  final String uid;

  /// Display name for the user.
  final String? displayName;

  /// Email address.
  final String? email;

  /// Profile photo URL.
  final String? photoURL;

  /// List of band IDs the user belongs to.
  @JsonKey(defaultValue: [])
  final List<String> bandIds;

  /// Musical role tags: guitarist, vocalist, drummer, bassist, etc.
  @JsonKey(defaultValue: [])
  final List<String> baseTags;

  /// Account creation timestamp.
  @JsonKey(fromJson: _parseDateTime, toJson: _dateTimeToJson)
  final DateTime createdAt;

  /// Creates a new [AppUser] with the specified values.
  AppUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
    this.bandIds = const [],
    this.baseTags = const [],
    required this.createdAt,
  });

  AppUser copyWith({
    String? uid,
    Object? displayName = _sentinel,
    Object? email = _sentinel,
    Object? photoURL = _sentinel,
    List<String>? bandIds,
    List<String>? baseTags,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      displayName: displayName == _sentinel
          ? this.displayName
          : displayName as String?,
      email: email == _sentinel ? this.email : email as String?,
      photoURL: photoURL == _sentinel ? this.photoURL : photoURL as String?,
      bandIds: bandIds ?? this.bandIds,
      baseTags: baseTags ?? this.baseTags,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Converts this user to JSON format.
  ///
  /// Used for serializing to Firestore.
  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  /// Creates an [AppUser] from JSON data.
  ///
  /// Used for deserializing Firestore documents.
  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  return DateTime.parse(value as String);
}

String? _dateTimeToJson(DateTime? value) => value?.toIso8601String();
