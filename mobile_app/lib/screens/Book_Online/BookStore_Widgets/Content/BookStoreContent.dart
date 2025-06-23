import 'package:flutter/material.dart';
import 'package:mobile_app/models/api_book.dart';
import 'package:provider/provider.dart';
import '../../../../Providers/ThemeProvider.dart';
import 'BooksGrid.dart';
import 'BooksList.dart';
import 'EmptyState.dart';

class BookStoreContent extends StatelessWidget {
  // final List<Book> books;
  final List<ApiBook> books;
  final bool isGridView;
  // final Function(Book) onBookTap;
  final Function(ApiBook) onBookTap;

  const BookStoreContent({
    super.key,
    required this.books,
    required this.isGridView,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    if (books.isEmpty) {
      return const EmptyState();
    }

    return Container(
      color: isDark ? Colors.black87 : Colors.grey[50],
      child: isGridView
          ? BooksGrid(books: books, onBookTap: onBookTap)
          : BooksList(books: books, onBookTap: onBookTap),
    );
  }
}