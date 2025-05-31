import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final Function(String) onChanged;

  const SearchBar({
    super.key,
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: '${S.of(context).findBooksByTitleOrAuthor}...',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.7),
              size: 20,
            ),
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? GestureDetector(
            onTap: () {
              controller.clear();
              onChanged('');
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(
                Icons.clear,
                color: Colors.white.withOpacity(0.7),
                size: 18,
              ),
            ),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onChanged: onChanged,
      ),
    );
  }
}