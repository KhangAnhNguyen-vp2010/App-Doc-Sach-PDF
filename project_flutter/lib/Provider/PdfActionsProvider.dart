import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class PdfActionsProvider extends ChangeNotifier {
  Future<void> renameFile(BuildContext context, File file, String newName) async {
    String newPath = path.join(file.parent.path, "$newName.pdf");
    if (await File(newPath).exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tên file đã tồn tại!")),
      );
    } else {
      await file.rename(newPath);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đổi tên thành công!")),
      );
    }
  }

  Future<void> deleteFile(BuildContext context, File file) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xóa File"),
        content: Text("Bạn có chắc muốn xóa '${path.basename(file.path)}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Hủy")),
          TextButton(
            onPressed: () {
              file.deleteSync();
              notifyListeners();
              Navigator.pop(context);
            },
            child: Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
