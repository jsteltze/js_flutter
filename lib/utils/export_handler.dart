import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:js_flutter/android/permission_handler.dart';
import 'package:js_flutter/utils/logger.dart';
import 'package:js_flutter/utils/snackbar_utils.dart';

class ExportHandler {
  static Future<bool> exportToDownloads(
    BuildContext context,
    String filename,
    String fileContent, [
    Function? onSuccess,
  ]) async {
    await Permissions.requestStoragePermission();
    String? mediaUri = await FileSaver.instance.saveToDownloads(
      name: filename,
      bytes: utf8.encode(fileContent),
    );
    if (mediaUri == null) {
      FileLogger.error('Error while exporting $filename');
      if (context.mounted) {
        showSnackbar(
          context,
          '"$filename" could not be exported (permissions?)',
          true,
        );
      }
      return false;
    } else {
      FileLogger.log('Exporting $filename was successful');
      if (context.mounted) {
        showSnackbar(context, '"$filename" exported to Downloads');
      }
      onSuccess?.call();
      return true;
    }
  }
}
