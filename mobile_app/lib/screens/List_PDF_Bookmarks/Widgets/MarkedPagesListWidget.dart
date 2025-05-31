import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../generated/l10n.dart';
import '../../Book_Offline/PdfViewerPage.dart';
import '../../Book_Online/BookReaderScreen.dart';
import 'BookmarkItemCard.dart';

class MarkedPagesListWidget extends StatelessWidget {
  final Box markedBox;

  const MarkedPagesListWidget({
    super.key,
    required this.markedBox,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: markedBox.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final fileName = markedBox.keyAt(index) as String;
              final data = markedBox.get(fileName) as dynamic;

              return BookmarkItemCard(
                fileName: fileName,
                data: data,
                onTap: () => _navigateToBook(context, fileName, data),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Text(
            "${markedBox.length} ${S.of(context).pageHasBeenBookmarked}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToBook(BuildContext context, String fileName, dynamic data) {
    final String url = data['link'];
    if (url == "") {
      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) => PdfViewerPage(
              file: File("/storage/emulated/0/Download/$fileName")
          ),
        ),
      );
    } else {
      final dashIndex = fileName.indexOf('-');
      final bookId = fileName.substring(0, dashIndex).trim();
      final bookName = fileName.substring(dashIndex + 1).trim();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookReaderScreen(
            pdfUrl: url,
            bookName: bookName,
            bookId: bookId,
          ),
        ),
      );
    }
  }
}