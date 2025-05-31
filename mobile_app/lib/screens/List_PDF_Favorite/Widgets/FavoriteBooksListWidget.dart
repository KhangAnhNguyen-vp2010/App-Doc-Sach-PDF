import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';

import '../../../generated/l10n.dart';
import '../../Book_Offline/PdfViewerPage.dart';
import '../../Book_Online/BookReaderScreen.dart';
import 'FavoriteBookCard.dart';

class FavoriteBooksListWidget extends StatelessWidget {
  final Box favoritedBox;

  const FavoriteBooksListWidget({
    super.key,
    required this.favoritedBox,
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
            itemCount: favoritedBox.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final fileName = favoritedBox.keyAt(index) as String;
              final data = favoritedBox.get(fileName);

              // Skip nếu data null hoặc fileName null
              if (fileName.isEmpty || data == null) {
                return const SizedBox.shrink();
              }

              return FavoriteBookCard(
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
          Icon(Icons.library_books, color: Colors.pink[600] ?? Colors.pink.shade600, size: 20),
          const SizedBox(width: 8),
          Text(
            "${favoritedBox.length} ${S.of(context).favoriteBooks}",
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
    // Null safety checks
    if (data == null) return;

    final String url = data is Map ? data['link'] : null;

    if (url == "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerPage(
              file: File(fileName)
          ),
        ),
      );
    } else {
      final dashIndex = fileName.indexOf('-');
      if (dashIndex == -1) {
        // Nếu không có dấu '-', sử dụng toàn bộ fileName
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookReaderScreen(
              pdfUrl: url,
              bookName: fileName,
              bookId: fileName,
            ),
          ),
        );
      } else {
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
}