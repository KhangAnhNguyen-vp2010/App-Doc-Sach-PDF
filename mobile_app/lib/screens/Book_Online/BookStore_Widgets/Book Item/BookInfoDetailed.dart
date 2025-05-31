import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import 'StatChip.dart';

class BookInfoDetailed extends StatelessWidget {
  final Book book;

  const BookInfoDetailed({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          book.author,
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            StatChip(icon: Icons.visibility, count: book.viewCount, color: Colors.blue),
            const SizedBox(width: 12),
            StatChip(icon: Icons.favorite, count: book.likeCount, color: Colors.red),
            const Spacer(),
            Text(
              '${book.publicationYear}',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}