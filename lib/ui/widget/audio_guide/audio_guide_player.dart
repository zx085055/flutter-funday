import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_funday/service/model/audio.dart';
import 'package:flutter_funday/ui/component/app_divider.dart';
import 'package:flutter_funday/ui/component/app_safe_scaffold.dart';
import 'package:flutter_funday/ui/component/player_widget.dart';
import 'package:flutter_funday/utils/audio_download.dart';
import 'package:flutter_funday/utils/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioGuidePlayerWidget extends StatefulWidget {
  const AudioGuidePlayerWidget({
    super.key,
    required this.audioData,
  });

  final AudioData audioData;

  @override
  State<AudioGuidePlayerWidget> createState() => _AudioGuidePlayerWidgetState();
}

class _AudioGuidePlayerWidgetState extends State<AudioGuidePlayerWidget> {
  late AudioPlayer player = AudioPlayer();
  late String fileName;

  @override
  void initState() {
    super.initState();
    fileName = widget.audioData.title;
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final directory = await AudioDownload.getDownloadDirectory();
      final filePath = '${directory.path}/$fileName.mp3';

      final hasPermission = await AudioDownload.requestPermissions();
      if (!hasPermission) {
        logger.d('沒有權限!');
        await openAppSettings();
        return;
      }

      await player.setSource(DeviceFileSource(filePath));
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSafeScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            fileName,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
          AppSpace.spaceVDividerH(
            height: 12,
          ),
          PlayerWidget(player: player),
        ],
      ),
    );
  }
}
