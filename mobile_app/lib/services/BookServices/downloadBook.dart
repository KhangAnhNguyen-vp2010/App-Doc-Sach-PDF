import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> downloadBook (String pdfUrl, BuildContext context) async {
  final Uri url = Uri.parse(pdfUrl);
  bool success = await launchUrl(url, mode: LaunchMode.externalApplication);
  if (!success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link sách đã bị gỡ. Không thể tải sách')),
    );
  }
}