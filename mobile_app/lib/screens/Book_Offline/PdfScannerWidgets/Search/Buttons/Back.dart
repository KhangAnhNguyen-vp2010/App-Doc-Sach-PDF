// Widget cho nút back
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../Providers/ThemeProvider.dart';
import '../../../../../generated/l10n.dart';

class SearchBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SearchBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        size: 20,
        color: isDark ? Colors.white : Color(0xFF2D3142),
      ),
      onPressed: onPressed,
      tooltip: S.of(context).back,
    );
  }
}