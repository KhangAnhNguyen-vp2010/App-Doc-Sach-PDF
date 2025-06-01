// Widget hiển thị danh sách kết quả
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Providers/ThemeProvider.dart';
import 'Items.dart';

class SearchResultsList extends StatelessWidget {
  final List<File> files;
  final Function(File) onFileSelected;

  const SearchResultsList({
    super.key,
    required this.files,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      color: isDark ? Colors.black87 : Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: files.length,
        itemBuilder: (context, index) {
          return PdfFileListItem(
            file: files[index],
            onTap: () => onFileSelected(files[index]),
          );
        },
      ),
    );
  }
}