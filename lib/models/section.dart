import 'package:json_annotation/json_annotation.dart';

part 'section.g.dart';

/// Song section representing a structural part of a song.
///
/// Common sections include Verse, Chorus, Bridge, Intro, Outro, etc.
/// Used to organize songs into their musical components.
///
/// Example usage:
/// ```dart
/// final chorus = Section(
///   id: 'section1',
///   name: 'Chorus',
///   order: 1,
///   startBeat: 0,
///   endBeat: 16,
///   color: '#FF5722',
/// );
/// ```
@JsonSerializable()
class Section {
  /// Unique identifier for the section.
  @JsonKey(defaultValue: '')
  final String id;

  /// Section name (e.g., 'Verse', 'Chorus', 'Bridge').
  @JsonKey(defaultValue: '')
  final String name;

  /// Order of the section within the song (0-based).
  @JsonKey(defaultValue: 0)
  final int order;

  /// Starting beat index for this section (optional).
  @JsonKey(defaultValue: 0)
  final int? startBeat;

  /// Ending beat index for this section (optional).
  @JsonKey(defaultValue: 0)
  final int? endBeat;

  /// Optional color code for UI visualization.
  @JsonKey(defaultValue: '')
  final String? color;

  /// Creates a new [Section] with the specified values.
  const Section({
    required this.id,
    required this.name,
    required this.order,
    this.startBeat,
    this.endBeat,
    this.color,
  });

  Section copyWith({
    String? id,
    String? name,
    int? order,
    int? startBeat,
    int? endBeat,
    String? color,
  }) {
    return Section(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      startBeat: startBeat ?? this.startBeat,
      endBeat: endBeat ?? this.endBeat,
      color: color ?? this.color,
    );
  }

  /// Creates a [Section] from JSON data.
  ///
  /// Used for deserializing Firestore documents.
  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);

  /// Converts this section to JSON format.
  ///
  /// Used for serializing to Firestore.
  Map<String, dynamic> toJson() => _$SectionToJson(this);
}
