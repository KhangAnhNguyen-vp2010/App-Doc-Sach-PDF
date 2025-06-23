import 'package:flutter/material.dart';
import 'package:mobile_app/models/api_book.dart';
import 'package:provider/provider.dart'; // THÊM dòng này
import '../../../../Providers/BookProvider.dart';
import '../../../../generated/l10n.dart';
import 'StatItem.dart';

class BookStatsSection extends StatelessWidget {
  const BookStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final book = context.watch<BookProvider>().book;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Row(
        children: [
          Expanded(
            child: StatItem(
              icon: Icons.visibility_outlined,
              label: S.of(context).view,
              value: _formatNumber(book?.viewCount ?? 0),
              color: Colors.blue,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          Expanded(
            child: StatItem(
              icon: Icons.favorite_outline,
              label: S.of(context).likes,
              value: _formatNumber(book?.likeCount ?? 0),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
