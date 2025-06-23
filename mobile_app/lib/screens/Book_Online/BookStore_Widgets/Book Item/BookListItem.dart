import 'package:flutter/material.dart';
import '../../../../models/api_book.dart';
import 'BookCoverSmall.dart';
import 'BookInfoDetailed.dart';

class BookListItem extends StatelessWidget {
  // final Book book;
  final ApiBook book;
  final int index;
  final VoidCallback onTap;

  const BookListItem({
    super.key,
    required this.book,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200 + (index * 30)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                BookCoverSmall(book: book),
                const SizedBox(width: 16),
                Expanded(
                  child: BookInfoDetailed(book: book),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}