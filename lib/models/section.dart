import 'package:json_annotation/json_annotation.dart';

part 'section.g.dart';

/// Song section (Verse, Chorus, Bridge, etc.)
@JsonSerializable()
class Section {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String name; // 'Verse', 'Chorus', 'Bridge', etc.
  @JsonKey(defaultValue: 0)
  final int order;
  @JsonKey(defaultValue: 0)
  final int? startBeat;
  @JsonKey(defaultValue: 0)
  final int? endBeat;
  @JsonKey(defaultValue: '')
  final String? color;

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

  factory Section.fromJson(Map<String, dynamic> json) => _$SectionFromJson(json);
  Map<String, dynamic> toJson() => _$SectionToJson(this);
}
