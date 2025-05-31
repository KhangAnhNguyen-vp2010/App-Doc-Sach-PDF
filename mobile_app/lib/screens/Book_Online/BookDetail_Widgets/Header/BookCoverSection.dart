// Widget hiển thị ảnh bìa sách
import 'package:flutter/material.dart';
import '../../../../models/models.dart';
import 'BookCoverImage.dart';
import 'BookTitleWidget.dart';

class BookCoverSection extends StatelessWidget {
  final Book book;

  const BookCoverSection({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          BookCoverImage(coverUrl: book.coverUrl),
          const SizedBox(height: 16),
          BookTitleWidget(title: book.title),
        ],
      ),
    );
  }
}