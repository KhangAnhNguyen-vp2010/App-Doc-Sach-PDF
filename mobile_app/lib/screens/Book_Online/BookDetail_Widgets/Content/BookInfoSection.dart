// Widget thông tin sách (tác giả)
import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/models.dart';
import 'InfoRow.dart';

class BookInfoSection extends StatelessWidget {
  final Book book;

  const BookInfoSection({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).bookInformation,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          InfoRow(
            icon: Icons.person_outline,
            label: S.of(context).author,
            value: book.author,
          ),
          const SizedBox(height: 10),
          InfoRow(
            icon: Icons.description,
            label: S.of(context).describe,
            value: book.description ?? 'Không có mô tả',
          ),
        ],
      ),
    );
  }
}