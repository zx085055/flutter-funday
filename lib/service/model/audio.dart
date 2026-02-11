import 'package:flutter_funday/utils/json_serializable_helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audio.g.dart';

@JsonSerializable()
class Audio {
  Audio(
    this.total,
    this.data,
  );

  factory Audio.fromEmpty() => Audio.fromJson(<String, dynamic>{});

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);

  Map<String, dynamic> toJson() => _$AudioToJson(this);

  @JsonKey(name: 'total', defaultValue: 0)
  int total;

  @JsonKey(name: 'data', defaultValue: [])
  List<AudioData> data;
}

@JsonSerializable()
class AudioData {
  AudioData(
    this.id,
    this.title,
    this.url,
    this.modified, {
    this.isFileExists = false,
  });

  factory AudioData.fromEmpty() => AudioData.fromJson(<String, dynamic>{});

  factory AudioData.fromJson(Map<String, dynamic> json) => _$AudioDataFromJson(json);

  Map<String, dynamic> toJson() => _$AudioDataToJson(this);

  @JsonKey(name: 'id', defaultValue: 0)
  int id;

  @JsonKey(name: 'title', defaultValue: '')
  String title;

  @JsonKey(name: 'url', defaultValue: '')
  String url;

  @JsonKey(name: 'modified', fromJson: JsonHelper.timeFromTimestamp, toJson: JsonHelper.timeToTimestamp)
  DateTime modified;

  @JsonKey(includeFromJson: false,includeToJson: false)
  bool isFileExists;

  AudioData copyWith({required bool isExists}) {
    return AudioData(
      id,
      title,
      url,
      modified,
      isFileExists :isExists,
    );
  }
}
