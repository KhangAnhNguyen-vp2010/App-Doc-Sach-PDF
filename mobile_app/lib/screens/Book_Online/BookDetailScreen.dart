// screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/models.dart';
import 'BookDetail_Widgets/Button/ActionButtonsSection.dart';
import 'BookDetail_Widgets/Content/BookInfoSection.dart';
import 'BookDetail_Widgets/Content/BookStatsSection.dart';
import 'BookDetail_Widgets/Header/BookCoverSection.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BookCoverSection(book: book),
            BookInfoSection(book: book),
            BookStatsSection(book: book),
            ActionButtonsSection(book: book),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        book.title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    );
  }
}




















