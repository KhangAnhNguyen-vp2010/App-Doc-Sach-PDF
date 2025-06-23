// Widget các nút hành động
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/api_book.dart';
import '../../../../services/BookServices/downloadBook.dart';
import 'ReadBookButton.dart';
import 'SecondaryButton.dart';

class ActionButtonsSection extends StatelessWidget {
  final ApiBook book;

  const ActionButtonsSection({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ReadBookButton(book: book),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  icon: Icons.download,
                  label: S.of(context).downloadBook,
                  onPressed: () async {
                    downloadBook(book.pdfUrl, context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SecondaryButton(
                  icon: Icons.share_outlined,
                  label: S.of(context).share,
                  onPressed: () {
                    Share.share('Check out this book: ${book.title}\n${book.pdfUrl}');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}