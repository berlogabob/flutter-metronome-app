// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Section _$SectionFromJson(Map<String, dynamic> json) => Section(
  id: json['id'] as String? ?? '',
  name: json['name'] as String? ?? '',
  order: (json['order'] as num?)?.toInt() ?? 0,
  startBeat: (json['startBeat'] as num?)?.toInt() ?? 0,
  endBeat: (json['endBeat'] as num?)?.toInt() ?? 0,
  color: json['color'] as String? ?? '',
);

Map<String, dynamic> _$SectionToJson(Section instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'order': instance.order,
  'startBeat': instance.startBeat,
  'endBeat': instance.endBeat,
  'color': instance.color,
};
