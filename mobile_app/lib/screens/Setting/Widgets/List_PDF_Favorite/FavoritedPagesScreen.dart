import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../../../Providers/ThemeProvider.dart';
import '../../../../generated/l10n.dart';
import 'Widgets/EmptyFavoritesWidget.dart';
import 'Widgets/FavoriteBooksListWidget.dart';

class FavoritedPagesScreen extends StatelessWidget {
  const FavoritedPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritedBox = Hive.box('favoriteBooks');

    return Scaffold(
      backgroundColor: Colors.pink[25] ?? Colors.pink.shade50,
      appBar: _buildAppBar(context),
      body: favoritedBox.isEmpty
          ? const EmptyFavoritesWidget()
          : FavoriteBooksListWidget(favoritedBox: favoritedBox),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return AppBar(
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Colors.black87,
      ),
      elevation: 0,
      backgroundColor: isDark ? Colors.black87 : Colors.white,
      foregroundColor: Colors.black87,
      title: Row(
        children: [
          Icon(Icons.favorite, color: Colors.red[600] ?? Colors.red.shade600, size: 28),
          const SizedBox(width: 8),
          Text(
            S.of(context).bookmarkList,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}




