// Widget các nút hành động
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/models.dart';
import '../../../../services/downloadBook.dart';
import 'ReadBookButton.dart';
import 'SecondaryButton.dart';

class ActionButtonsSection extends StatelessWidget {
  final Book book;

  const ActionButtonsSection({required this.book});

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