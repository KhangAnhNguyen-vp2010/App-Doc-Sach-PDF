import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import 'StatChip.dart';

class BookInfo extends StatelessWidget {
  final Book book;

  const BookInfo({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              StatChip(icon: Icons.visibility, count: book.viewCount, color: Colors.blue),
              const SizedBox(width: 8),
              StatChip(icon: Icons.favorite, count: book.likeCount, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}