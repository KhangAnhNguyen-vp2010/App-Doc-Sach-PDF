// widgets/loading_overlay.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/ThemeProvider.dart';
import '../../../generated/l10n.dart';

class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({
    super.key,
    this.message = 'Đang tải tài liệu...',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      color: isDark ? Colors.black87 : Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            Text(
              "${S.of(context).loadingDocuments}...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${S.of(context).pleaseWaitAMoment}...',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}