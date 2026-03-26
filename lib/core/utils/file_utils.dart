import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String?> downloadPdf(
      String url,
      String fileName,
      Function(double progress)? onProgress,
      ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$fileName";
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }

      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      return filePath;
    } catch (_) {
      return null;
    }
  }
}