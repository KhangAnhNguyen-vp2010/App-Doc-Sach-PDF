// Widget hiển thị ảnh bìa sách
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Providers/BookProvider.dart';
import '../../../../Providers/ThemeProvider.dart';
import 'BookCoverImage.dart';
import 'BookTitleWidget.dart';

class BookCoverSection extends StatelessWidget {


  const BookCoverSection({super.key});

  @override
  Widget build(BuildContext context) {
    final book = context.watch<BookProvider>().book;
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.black87 : Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          BookCoverImage(coverUrl: book?.coverUrl ?? ""),
          const SizedBox(height: 16),
          BookTitleWidget(title: book?.title ?? ""),
        ],
      ),
    );
  }
}