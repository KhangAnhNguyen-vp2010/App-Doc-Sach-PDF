// Nút đọc sách chính
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/models.dart';
import '../../BookReaderScreen.dart';

class ReadBookButton extends StatelessWidget {
  final Book book;

  const ReadBookButton({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.menu_book, size: 24),
        label: Text(
          S.of(context).readTheBookNow,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.blue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          final realm = Realm(Configuration.local([Book.schema, Category.schema]));

          // Tìm lại cuốn sách đang dùng (phòng khi cần latest data)
          final bookToUpdate = realm.find<Book>(book.id);

          if (bookToUpdate != null) {
            realm.write(() {
              bookToUpdate.viewCount += 1;
            });
          }

          // Tiếp tục chuyển đến trang đọc sách
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookReaderScreen(
                pdfUrl: book.pdfUrl,
                bookName: book.title,
                bookId: book.id,
              ),
            ),
          );
        },
      ),
    );
  }
}