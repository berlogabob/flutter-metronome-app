// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
  id: json['id'] as String? ?? '',
  url: json['url'] as String? ?? '',
  type: json['type'] as String? ?? 'other',
  title: json['title'] as String? ?? '',
);

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'type': instance.type,
  'title': instance.title,
};
