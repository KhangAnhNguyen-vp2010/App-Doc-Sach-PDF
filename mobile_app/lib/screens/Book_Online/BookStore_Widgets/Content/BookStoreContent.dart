import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Providers/ThemeProvider.dart';
import '../../../../models/models.dart';
import 'BooksGrid.dart';
import 'BooksList.dart';
import 'EmptyState.dart';

class BookStoreContent extends StatelessWidget {
  final List<Book> books;
  final bool isGridView;
  final Function(Book) onBookTap;

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