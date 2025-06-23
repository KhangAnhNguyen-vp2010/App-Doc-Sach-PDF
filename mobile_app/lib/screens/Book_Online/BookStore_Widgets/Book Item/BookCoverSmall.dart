import 'package:flutter/material.dart';
import '../../../../models/api_book.dart';

class BookCoverSmall extends StatelessWidget {
  // final Book book;
  final ApiBook book;

  const BookCoverSmall({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        book.coverUrl,
        width: 60,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 60,
          height: 80,
          color: Colors.grey[200],
          child: Icon(Icons.book, color: Colors.grey[400]),
        ),
      ),
    );
  }
}