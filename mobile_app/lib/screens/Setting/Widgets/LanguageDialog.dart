import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/LanguageProvider.dart';
import '../../../Providers/ThemeProvider.dart';
import '../../../generated/l10n.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LanguageProvider>().locale;
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? Colors.black87 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🌐 ${S.of(context).selectLanguage}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87
              ),
            ),
            const SizedBox(height: 20),
            _buildLanguageOption(
              context,
              flag: '🇬🇧',
              label: S.of(context).english,
              isSelected: locale.languageCode == 'en',
              onTap: () {
                context.read<LanguageProvider>().changeLanguage('en');
              },
            ),
            const SizedBox(height: 12),
            _buildLanguageOption(
              context,
              flag: '🇻🇳',
              label: S.of(context).vietnamese,
              isSelected: locale.languageCode == 'vi',
              onTap: () {
                context.read<LanguageProvider>().changeLanguage('vi');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, {
    required String flag,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.check_circle : Icons.check_circle_outline,
              color: isSelected ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
