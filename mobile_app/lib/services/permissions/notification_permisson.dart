import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission(BuildContext context) async {
  final status = await Permission.notification.status;

  if (status.isDenied) {
    // Nếu lần đầu từ chối, thử hiện lại quyền
    final result = await Permission.notification.request();

    if (result.isPermanentlyDenied) {
      // Nếu người dùng từ chối vĩnh viễn → mở cài đặt
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Thông báo bị chặn"),
          content: const Text("Bạn đã từ chối quyền gửi thông báo. Hãy bật lại trong phần cài đặt ứng dụng."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Đóng"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text("Mở cài đặt"),
            ),
          ],
        ),
      );
    }
  } else if (status.isPermanentlyDenied) {
    // Trường hợp vào lại dialog khi đã bị từ chối vĩnh viễn
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thông báo bị chặn"),
        content: const Text("Bạn đã từ chối quyền gửi thông báo. Hãy bật lại trong phần cài đặt ứng dụng."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Đóng"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text("Mở cài đặt"),
          ),
        ],
      ),
    );
  }
}