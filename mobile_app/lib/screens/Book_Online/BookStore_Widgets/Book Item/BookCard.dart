import 'package:flutter/material.dart';
import '../../../../models/api_book.dart';
import 'BookCover.dart';
import 'BookInfo.dart';

class BookCard extends StatelessWidget {
  // final Book book;
  final ApiBook book;
  final int index;
  final VoidCallback onTap;

  const BookCard({
    super.key,
    required this.book,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutBack,
      child: Hero(
        tag: 'book_${book.id}',
        child: Material(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: BookCover(book: book),
                ),
                Expanded(
                  flex: 2,
                  child: BookInfo(book: book),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}