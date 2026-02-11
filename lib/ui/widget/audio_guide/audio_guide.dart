import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_funday/service/model/audio.dart';
import 'package:flutter_funday/ui/component/app_divider.dart';
import 'package:flutter_funday/ui/component/app_list_view.dart';
import 'package:flutter_funday/ui/component/app_safe_scaffold.dart';
import 'package:flutter_funday/ui/widget/audio_guide/audio_guide_player.dart';
import 'package:flutter_funday/ui/widget/base_widget.dart';
import 'package:flutter_funday/ui/widget/view_model/audio_guide_view_model.dart';
import 'package:flutter_funday/utils/audio_download.dart';
import 'package:flutter_funday/utils/extension.dart';
import 'package:flutter_funday/utils/logger.dart';
import 'package:intl/intl.dart';

class AudioGuideWidget extends StatefulWidget {
  const AudioGuideWidget({
    super.key,
  });

  @override
  State<AudioGuideWidget> createState() => _AudioGuideWidgetState();
}

class _AudioGuideWidgetState extends State<AudioGuideWidget> {
  final _audioGuideScrollController = ScrollController();

  void _setScrollListener(AudioGuideViewModel model) {
    _audioGuideScrollController.addListener(() {
      if (_audioGuideScrollController.atBottom && !model.busy && model.hasMore) {
        model.getAudio();
      }
    });
  }

  @override
  void dispose() {
    _audioGuideScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSafeScaffold(
      child: BaseWidget<AudioGuideViewModel>(
        onModelReady: (model) {
          _setScrollListener(model);

          SchedulerBinding.instance.addPostFrameCallback((_) async {
            await model.initData();
          });
        },
        build: (context, model, child) {
          return AppListView(
            controller: _audioGuideScrollController,
            isRemoveTopPadding: true,
            itemCount: model.audioList.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(
                index,
                model,
              );
            },
            separatorBuilder: (BuildContext context, int index) => AppSpace.spaceVDividerH(
              height: 2,
              dividerHeight: 2,
              dividerColor: Colors.grey,
            ),
          );
        },
      ),
    );
  }

  Widget _buildListItem(int index, AudioGuideViewModel model) {
    AudioData data = model.audioList[index];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 70,
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              data.title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              SizedBox(
                height: 24,
                width: 80,
                child: StatefulBuilder(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey, width: 1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () async {
                        if (data.isFileExists) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioGuidePlayerWidget(
                                audioData: data,
                              ),
                            ),
                          );
                        } else {
                          bool? downloadStatus = await showDownloadDialog(data) ?? false;

                          if (downloadStatus) {
                            state(() {
                              model.audioList[index].isFileExists = downloadStatus;
                            });
                          }
                        }
                      },
                      child: Text(
                        data.isFileExists ? '播放' : '下載',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                DateFormat('MM/dd HH:mm').format(data.modified),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool?> showDownloadDialog(AudioData data) async {
    int percent = 0;
    bool downloading = false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            if (!downloading) {
              unawaited(
                AudioDownload.downloadFile(
                  data.title,
                  data.url,
                  (p) {
                    state(() {
                      percent = p.clamp(0, 100).toInt();
                    });
                  },
                  (file) {
                    logger.d('download success!');
                    Navigator.of(context).pop(true);
                  },
                  (e) {
                    logger.d('download fail! Error: $e');
                    Navigator.of(context).pop(false);
                  },
                ),
              );
              downloading = true;
            }
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 284,
                      height: 15,
                      child: Stack(
                        alignment: AlignmentDirectional.centerStart,
                        children: [
                          Container(
                            height: 13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[300],
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: (percent.toDouble() / 100.0),
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 13,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
