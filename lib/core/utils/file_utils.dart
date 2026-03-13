import 'dart:io';
import 'package:dio/dio.dart';

class FileUtils {
  static Future<String?> downloadPdf(
      String url,
      String fileName,
      Function(double progress)? onProgress,
      ) async {
    try {
      final directory = Directory('/storage/emulated/0/Download/JDIH');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = "${directory.path}/$fileName";
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }

      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            double progress = received / total;
            onProgress(progress);
          }
        },
      );

      return filePath;
    } catch (e) {
      return null;
    }
  }
}