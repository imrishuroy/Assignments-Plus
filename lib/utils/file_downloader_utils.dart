import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;
import 'package:universal_html/html.dart' as html;

class FileDownloaderUtils {
  static void downloadOnWeb(
    List<int> bytes, {
    required String downloadName,
  }) {
    try {
      // Encode our file in base64
      final _base64 = base64Encode(bytes);
      // Create the link with the file
      final anchor = html.AnchorElement(
          href: 'data:application/octet-stream;base64,$_base64')
        ..target = 'blank';
      // add the name
      anchor.download = downloadName;
      // trigger download
      html.document.body?.append(anchor);
      anchor.click();
      anchor.remove();
      return;
    } catch (e) {
      print('Error in downloadOnWeb: ${e.toString()}');
      rethrow;
    }
  }

  static Future<void> downloadFile({
    required Uint8List uint8listFile,
    required String fileName,
  }) async {
    File? file;

    try {
      if (kIsWeb) {
        // download for web

        downloadOnWeb(uint8listFile, downloadName: fileName);
      } else {
        // Platform.isIOS comes from dart:io
        if (Platform.isIOS) {
          final dir = await getApplicationDocumentsDirectory();
          file = File('${dir.path}/$fileName');
        } else if (Platform.isAndroid) {
          var status = await Permission.storage.status;

          if (status != PermissionStatus.granted) {
            status = await Permission.storage.request();
          }
          if (status.isGranted) {
            const downloadsFolderPath = '/storage/emulated/0/Download/';
            Directory dir = Directory(downloadsFolderPath);
            file = File('${dir.path}$fileName');
          }
        }
        if (file != null) {
          ByteData byteData = ByteData.view(uint8listFile.buffer);
          await file.writeAsBytes(byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        }
      }
    } on FileSystemException catch (error) {
      print('Error in downloading file: ${error.toString()}');
    } catch (error) {
      print('Error in downloading file: ${error.toString()}');
    }
  }
}
