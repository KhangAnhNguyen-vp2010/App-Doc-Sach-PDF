// widgets/options_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Providers/ThemeProvider.dart';
import '../../../generated/l10n.dart';
import '../../../services/BookServices/downloadBook.dart';

class OptionsBottomSheet extends StatelessWidget {
  final String bookName;
  final String bookUrl;
  final bool isMarked;
  final bool isFavorite;
  final VoidCallback onToggleBookmark;
  final VoidCallback onToggleFavorite;
  final VoidCallback onGoToPage;
  final String typeName;

  const OptionsBottomSheet({
    super.key,
    required this.bookName,
    required this.bookUrl,
    required this.isMarked,
    required this.isFavorite,
    required this.onToggleBookmark,
    required this.onToggleFavorite,
    required this.onGoToPage,
    required this.typeName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black87 : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(context),
          const Divider(height: 1),
          _buildQuickActions(context),
          _buildMainOptions(context),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.red,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  typeName == "offline" ? bookUrl : S.of(context).onlineLibrary,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildQuickActionButton(
            icon: Icons.share_rounded,
            label: S.of(context).share,
            onTap: () {
              Navigator.pop(context);
              Share.share('Share: $bookName\n$bookUrl');
            },
            colorText: isDark ? Colors.white : Colors.grey,
          ),
          _buildQuickActionButton(
            icon: Icons.skip_next_rounded,
            label: S.of(context).goToPage,
            onTap: () {
              Navigator.pop(context);
              onGoToPage();
            },
            colorText: isDark ? Colors.white : Colors.grey,
          ),
          if(typeName=="online")
            _buildQuickActionButton(
              icon: Icons.download_rounded,
              label: S.of(context).downLoad,
              onTap: () {
                Navigator.pop(context);
                downloadBook(bookUrl, context);
              },
              colorText: isDark ? Colors.white : Colors.grey,
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color colorText,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 24, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: colorText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainOptions(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Column(
      children: [
        _buildOptionTile(
          icon: Icons.bookmark_rounded,
          title: isMarked ? S.of(context).unBookmark : S.of(context).bookmark,
          iconColor: isMarked ? Colors.amber[700] : null,
          onTap: () {
            Navigator.pop(context);
            onToggleBookmark();
          },
          colorText: isDark ? Colors.white : Colors.grey,
          defaultColor: isDark ? Colors.white : Colors.grey,
        ),
        _buildOptionTile(
          icon: Icons.favorite_rounded,
          title: isFavorite ? S.of(context).unlike : S.of(context).addToFavorites,
          iconColor: isFavorite ? Colors.red[400] : null,
          onTap: () {
            Navigator.pop(context);
            onToggleFavorite();
          },
          colorText: isDark ? Colors.white : Colors.grey,
          defaultColor: isDark ? Colors.white : Colors.grey,
        ),
      ],
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    required Color colorText,
    required Color defaultColor
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? defaultColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorText,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}