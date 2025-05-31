import 'package:flutter/cupertino.dart';
import 'HeaderTitle.dart';
import 'SearchBar.dart';

class BookStoreHeader extends StatelessWidget {
  final int booksCount;
  final bool isGridView;
  final Function(bool) onViewToggle;
  final TextEditingController searchController;
  final String searchQuery;
  final Function(String) onSearchChanged;

  const BookStoreHeader({
    super.key,
    required this.booksCount,
    required this.isGridView,
    required this.onViewToggle,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderTitle(
              booksCount: booksCount,
              isGridView: isGridView,
              onViewToggle: onViewToggle,
            ),
            const SizedBox(height: 16),
            SearchBar(
              controller: searchController,
              searchQuery: searchQuery,
              onChanged: onSearchChanged,
            ),
          ],
        ),
      ),
    );
  }
}