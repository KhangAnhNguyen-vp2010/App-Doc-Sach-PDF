// Widget tiêu đề sách
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Providers/ThemeProvider.dart';

class BookTitleWidget extends StatelessWidget {
  final String title;

  const BookTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
        height: 1.3,
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}