import 'package:flutter/material.dart';

import '../../../../models/models.dart';

class CategoryFilters extends StatelessWidget {
  final List<Category> categories;
  final String selectedCategory;
  final Function(String) onChanged;

  const CategoryFilters({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.name;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              selected: isSelected,
              label: Text(category.name),
              onSelected: (selected) => onChanged(category.name),
              selectedColor: const Color(0xFF667eea).withOpacity(0.2),
              checkmarkColor: const Color(0xFF667eea),
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF667eea) : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF667eea) : Colors.transparent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}