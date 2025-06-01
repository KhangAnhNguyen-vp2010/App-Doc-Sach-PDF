// Widget cho nút clear
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Providers/ThemeProvider.dart';
import '../../../../../generated/l10n.dart';

class SearchClearButton extends StatelessWidget {
  final String query;
  final VoidCallback onClear;

  const SearchClearButton({super.key,
    required this.query,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    if (query.isEmpty) return const SizedBox.shrink();

    return IconButton(
      icon: Icon(
        Icons.clear,
        size: 20,
        color: isDark ? Colors.white : Color(0xFF2D3142),
      ),
      onPressed: onClear,
      tooltip: S.of(context).clear,
    );
  }
}