import 'package:flutter/material.dart';
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
    if (books.isEmpty) {
      return const EmptyState();
    }

    return Container(
      color: Colors.grey[50],
      child: isGridView
          ? BooksGrid(books: books, onBookTap: onBookTap)
          : BooksList(books: books, onBookTap: onBookTap),
    );
  }
}