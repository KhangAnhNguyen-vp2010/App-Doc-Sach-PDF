// Nút đọc sách chính
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Providers/BookProvider.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/api_book.dart';
import '../../BookReaderScreen.dart';

class ReadBookButton extends StatelessWidget {
  final ApiBook book;

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
          context.read<BookProvider>().incrementLikeCountAndRefresh();
          context.read<BookProvider>().incrementViewCountAndRefresh();
          // Tiếp tục chuyển sang trang đọc sách
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider<BookProvider>.value(
                value: context.read<BookProvider>(),
                child: BookReaderScreen(
                  pdfUrl: book.pdfUrl,
                  bookName: book.title,
                  bookId: book.id,
                ),
              )
            ),
          );
        },
      ),
    );
  }
}