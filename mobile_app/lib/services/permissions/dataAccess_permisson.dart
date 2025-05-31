import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../generated/l10n.dart';

Future<List<File>> requestPermissionAndLoadFiles(
    BuildContext context,
    Future<List<File>> Function() loadPdfFiles,
    Future<void> Function() loadFilesWithDelay)
async {
  if (await Permission.storage.request().isGranted ||
      await Permission.manageExternalStorage.request().isGranted) {
    return await loadPdfFiles();
  } else {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(S.of(context).provideAccess),
          content: Text("${S.of(context).theAppNeedsStorageAccessPermissionToLoadPDFFilesPleaseGrantPermissionInSettings}."),
          actions: [
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () => Navigator.pop(ctx),
            ),
            TextButton(
              child: Text(S.of(context).settings),
              onPressed: () async{
                Navigator.pop(ctx);
                openManageAllFilesAccessSettings();
                loadFilesWithDelay();
              },
            ),
          ],
        );
      },
    );
    return [];
  }
}

void openManageAllFilesAccessSettings() async {
  final intent = AndroidIntent(
    action: "android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION",
    data: "package:com.example.project_flutter", // Thay bằng package của bạn
    flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
  );
  await intent.launch();
}