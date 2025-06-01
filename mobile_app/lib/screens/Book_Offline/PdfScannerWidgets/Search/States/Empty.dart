// Widget hiển thị trạng thái trống (chưa tìm kiếm)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Providers/ThemeProvider.dart';
import '../../../../../generated/l10n.dart';

class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      color: isDark ? Colors.black87 : Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: isDark ? Colors.white : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).searchForFiles,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}