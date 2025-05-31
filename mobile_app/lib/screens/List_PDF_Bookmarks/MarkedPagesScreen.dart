import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../Providers/ThemeProvider.dart';
import '../../generated/l10n.dart';
import 'Widgets/EmptyMarkedPagesWidget.dart';
import 'Widgets/MarkedPagesListWidget.dart';

class MarkedPagesScreen extends StatelessWidget {
  const MarkedPagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final markedBox = Hive.box('markedPages');

    return Scaffold(
      backgroundColor: Colors.pink[25] ?? Colors.yellow.shade50,
      appBar: _buildAppBar(context),
      body: markedBox.isEmpty
          ? const EmptyMarkedPagesWidget()
          : MarkedPagesListWidget(markedBox: markedBox),
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
          Icon(Icons.bookmark_added, color: Colors.amber[700], size: 28),
          const SizedBox(width: 8),
          Text(
            S.of(context).bookmarkedPage,
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





