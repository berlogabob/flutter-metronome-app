import 'package:json_annotation/json_annotation.dart';

part 'link.g.dart';

/// Link to external resource (YouTube, Spotify, etc.)
@JsonSerializable()
class Link {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String url;
  @JsonKey(defaultValue: 'other')
  final String type; // 'youtube', 'spotify', 'apple_music', 'other'
  @JsonKey(defaultValue: '')
  final String? title;

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

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
