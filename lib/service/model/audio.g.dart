// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Audio _$AudioFromJson(Map<String, dynamic> json) => Audio(
  (json['total'] as num?)?.toInt() ?? 0,
  (json['data'] as List<dynamic>?)
          ?.map((e) => AudioData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$AudioToJson(Audio instance) => <String, dynamic>{
  'total': instance.total,
  'data': instance.data,
};

AudioData _$AudioDataFromJson(Map<String, dynamic> json) => AudioData(
  (json['id'] as num?)?.toInt() ?? 0,
  json['title'] as String? ?? '',
  json['url'] as String? ?? '',
  JsonHelper.timeFromTimestamp(json['modified'] as String),
);

Map<String, dynamic> _$AudioDataToJson(AudioData instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'url': instance.url,
  'modified': JsonHelper.timeToTimestamp(instance.modified),
};
