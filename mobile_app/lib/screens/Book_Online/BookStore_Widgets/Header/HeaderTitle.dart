import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import 'ViewToggle.dart';

class HeaderTitle extends StatelessWidget {
  final int booksCount;
  final bool isGridView;
  final Function(bool) onViewToggle;

  const HeaderTitle({
    super.key,
    required this.booksCount,
    required this.isGridView,
    required this.onViewToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).discover,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$booksCount books',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        ViewToggle(
          isGridView: isGridView,
          onToggle: onViewToggle,
        ),
      ],
    );
  }
}