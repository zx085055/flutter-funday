import 'package:flutter_funday/service/model/audio.dart';
import 'package:flutter_funday/ui/widget/base_model.dart';
import 'package:flutter_funday/utils/audio_download.dart';
import 'package:flutter_funday/utils/logger.dart';

class AudioGuideViewModel extends BaseModel {
  int _nextPage = 1;
  bool _hasMore = true;
  Audio _audio = Audio.fromEmpty();
  final List<AudioData> _audioList = <AudioData>[];

  int get nextPage => _nextPage;

  bool get hasMore => _hasMore;

  Audio get audio => _audio;

  List<AudioData> get audioList => _audioList;

  @override
  Future<void> initData() async {
    await getAudio();
  }

  @override
  Future<void> refresh() async {}

  Future<void> getAudio() async {
    setBusy(true);

    try {
      _audio = await apiService.client.audio(lang: 'zh-tw', page: _nextPage);

      if (_audio.data.isNotEmpty) {
        for (int i = 0; i < _audio.data.length; i++) {
          _audio.data[i] = _audio.data[i].copyWith(isExists: await AudioDownload.isFileExists(_audio.data[i].title));
        }
        _audioList.addAll(_audio.data);
        _nextPage++;
      }

      _hasMore = _audioList.length < _audio.total;
    } on Object catch (error) {
      logger.e('API Error! $error');
    }

    setBusy(false);
  }
}
