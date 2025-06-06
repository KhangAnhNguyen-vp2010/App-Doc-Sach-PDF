// Services
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class BookmarkService {
  static Future<void> saveMarkedPage(
      String fileName,
      int page,
      String note,
      String link,
      ) async {
    final box = await Hive.openBox('markedPages');
    await box.put(fileName, {
      "page": page,
      "note": note,
      "link": link,
    });
  }

  static Future<Map<String, dynamic>?> getMarkedPage(String fileName) async {
    final box = await Hive.openBox('markedPages');
    return box.get(fileName)?.cast<String, dynamic>();
  }

  static Future<void> removeMarkedPage(String fileName) async {
    final box = await Hive.openBox('markedPages');
    await box.delete(fileName);
    debugPrint("Đã bỏ đánh dấu file $fileName");
  }
}