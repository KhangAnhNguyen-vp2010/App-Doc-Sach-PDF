import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Providers/ThemeProvider.dart';
import '../../../../models/models.dart';
import 'CategoryFilters.dart';
import 'SortDropdown.dart';

class BookStoreFilters extends StatelessWidget {
  final List<Category> categories;
  final String selectedCategory;
  final String selectedSort;
  final Map<String, String> sortOptions;
  final Function(String) onCategoryChanged;
  final Function(String) onSortChanged;

  const BookStoreFilters({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.selectedSort,
    required this.sortOptions,
    required this.onCategoryChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      color: isDark ? Colors.black87 : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          CategoryFilters(
            categories: categories,
            selectedCategory: selectedCategory,
            onChanged: onCategoryChanged,
          ),
          const SizedBox(height: 12),
          SortDropdown(
            selectedSort: selectedSort,
            sortOptions: sortOptions,
            onChanged: onSortChanged,
          ),
        ],
      ),
    );
  }
}