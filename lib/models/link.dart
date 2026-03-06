import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

/// External resource link for a song.
///
/// Represents a reference to external content such as
/// YouTube videos, Spotify tracks, or Apple Music songs.
///
/// Example usage:
/// ```dart
/// final link = Link(
///   id: 'link123',
///   url: 'https://youtube.com/watch?v=...',
///   type: 'youtube',
///   title: 'Official Music Video',
/// );
/// ```
@JsonSerializable()
class Link {
  /// Unique identifier for the link.
  @JsonKey(defaultValue: '')
  final String id;

  /// Full URL to the external resource.
  @JsonKey(defaultValue: '')
  final String url;

  /// Type of link: 'youtube', 'spotify', 'apple_music', or 'other'.
  @JsonKey(defaultValue: 'other')
  final String type;

  /// Optional title or description for the link.
  @JsonKey(defaultValue: '')
  final String? title;

  /// Creates a new [Link] with the specified values.
  const Link({
    required this.id,
    required this.url,
    this.type = 'other',
    this.title,
  });

  Link copyWith({
    String? id,
    String? url,
    String? type,
    String? title,
  }) {
    return Link(
      id: id ?? this.id,
      url: url ?? this.url,
      type: type ?? this.type,
      title: title ?? this.title,
    );
  }

  /// Creates a [Link] from JSON data.
  ///
  /// Used for deserializing Firestore documents.
  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  /// Converts this link to JSON format.
  ///
  /// Used for serializing to Firestore.
  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
