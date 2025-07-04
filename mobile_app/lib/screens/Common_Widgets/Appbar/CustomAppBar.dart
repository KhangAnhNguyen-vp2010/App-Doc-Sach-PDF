// widgets/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../Providers/ThemeProvider.dart';
import '../../../generated/l10n.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleName;
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onToggleSearch;
  final VoidCallback onClearSearch;
  final VoidCallback onShowOptions;
  final Function(String) onSearchChanged;
  final Function(String) onSearchSubmitted;
  final bool isLoading;

  const CustomAppBar({
    super.key,
    required this.titleName,
    required this.isSearching,
    required this.searchController,
    required this.onToggleSearch,
    required this.onClearSearch,
    required this.onShowOptions,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return AppBar(
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : Color(0xFF2D3142),
      ),
      automaticallyImplyLeading: isLoading,
      backgroundColor: isDark ? Colors.black87 : Colors.white,
      elevation: 1,
      title: isSearching ? _buildSearchField(context) : _buildTitle(context),
      actions: _buildActions(context),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: '${S.of(context).searchInDocuments}...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          hintStyle: TextStyle(color: Colors.grey),
        ),
        style: const TextStyle(fontSize: 16),
        autofocus: true,
        onChanged: onSearchChanged,
        onSubmitted: onSearchSubmitted,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Text(
      titleName,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      if (isSearching) _buildClearButton(context),
      _buildSearchToggleButton(context),
      if (!isSearching) _buildOptionsButton(context),
      const SizedBox(width: 8),
    ];
  }

  Widget _buildClearButton(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return IconButton(
      icon: Icon(Icons.clear, color: isDark ? Colors.white : Colors.black54),
      onPressed: onClearSearch,
      tooltip: 'Xóa tìm kiếm',
    );
  }

  Widget _buildSearchToggleButton(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return IconButton(
      icon: Icon(
          isSearching ? Icons.arrow_back_ios_new_rounded : Icons.search_rounded,
          color: isDark ? Colors.white : Colors.black54
      ),
      onPressed: onToggleSearch,
      tooltip: isSearching ? 'Đóng tìm kiếm' : 'Tìm kiếm',
    );
  }

  Widget _buildOptionsButton(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return IconButton(
      icon: Icon(Icons.more_vert_rounded, color: isDark ? Colors.white : Colors.black87),
      onPressed: onShowOptions,
      tooltip: 'Tùy chọn',
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}