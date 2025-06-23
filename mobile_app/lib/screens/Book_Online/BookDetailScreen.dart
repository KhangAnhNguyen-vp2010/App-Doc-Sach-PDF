// screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/BookProvider.dart';
import '../../Providers/ThemeProvider.dart';
import '../../models/api_book.dart';
import 'BookDetail_Widgets/Button/ActionButtonsSection.dart';
import 'BookDetail_Widgets/Content/BookInfoSection.dart';
import 'BookDetail_Widgets/Content/BookStatsSection.dart';
import 'BookDetail_Widgets/Header/BookCoverSection.dart';

class BookDetailScreen extends StatelessWidget {
  // final Book book;
  final ApiBook book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return ChangeNotifierProvider(
      create: (_) => BookProvider()..setBook(book),
      child: Scaffold(
        backgroundColor: isDark ? Colors.black87 : Colors.grey[50],
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              BookCoverSection(),
              BookInfoSection(),
              BookStatsSection(),
              ActionButtonsSection(book: book),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return AppBar(
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Color(0xFF2D3142),
      ),
      title: Text(
        book.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: isDark ? Colors.white : Color(0xFF2D3142),
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: isDark ? Colors.black87 : Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    );
  }
}