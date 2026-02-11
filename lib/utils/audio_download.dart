import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_funday/locator.dart';
import 'package:flutter_funday/service/api_service.dart';
import 'package:flutter_funday/utils/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioDownload {
  AudioDownload._();

  static Future<bool> isFileExists(String title) async {
    try {
      final directory = await getDownloadDirectory();
      final fileName = title;
      final filePath = '${directory.path}/$fileName.mp3';
      return File(filePath).existsSync();
    } on Object catch (e) {
      logger.e('檢查檔案錯誤: $e');
      return false;
    }
  }

  static Future<void> downloadFile(
    String title,
    String url,
    Function(int) onReceiveProgress,
    Function(File) onComplete,
    Function(Object) onError,
  ) async {
    try {
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        onError('沒有權限!');
        await openAppSettings();
        return;
      }

      final directory = await getDownloadDirectory();
      final fileName = title;
      final filePath = '${directory.path}/$fileName.mp3';

      if (File(filePath).existsSync()) {
        logger.d('檔案已存在!');
        return;
      }

      await locator<APIService>().dioDownload(
        url,
        File(filePath),
        onReceiveProgress,
        onComplete,
        onError,
      );
    } on Object catch (e) {
      logger.e('下載錯誤: $e');
    }
  }

  static Future<Directory> getDownloadDirectory() async {
    Directory? directory = await getExternalStorageDirectory();
    String newPath = '';
    List<String> paths = directory!.path.split('/');

    for (int i = 1; i < paths.length; i++) {
      String folder = paths[i];
      if (folder != 'Android') {
        newPath += '/$folder';
      } else {
        break;
      }
    }
    newPath = '$newPath/Download/MyAudioFiles';
    directory = Directory(newPath);

    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ 只需要 READ_MEDIA_AUDIO
        final status = await Permission.audio.request();
        return status.isGranted;
      } else if (androidInfo.version.sdkInt >= 30) {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true;
  }
}
