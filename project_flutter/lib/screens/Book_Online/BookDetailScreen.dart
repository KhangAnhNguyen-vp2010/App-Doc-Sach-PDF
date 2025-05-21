// screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../models/models.dart';
import 'BookReaderScreen.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                book.coverUrl,
                height: 200,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 16),
            Text(book.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Tác giả: ${book.author}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Lượt xem: ${book.viewCount}'),
            Text('Lượt thích: ${book.likeCount}'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.menu_book),
                label: const Text('Đọc sách'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookReaderScreen(pdfUrl: book.pdfUrl),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
