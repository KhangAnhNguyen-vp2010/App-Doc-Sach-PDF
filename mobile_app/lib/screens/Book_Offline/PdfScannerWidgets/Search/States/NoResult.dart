// Widget hiển thị trạng thái không có kết quả
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Providers/ThemeProvider.dart';
import '../../../../../generated/l10n.dart';

class SearchNoResultsState extends StatelessWidget {
  final String query;

  const SearchNoResultsState({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      color: isDark ? Colors.black87 : Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDark ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).noFilesFound,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: isDark ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).tryDifferentKeywords,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}