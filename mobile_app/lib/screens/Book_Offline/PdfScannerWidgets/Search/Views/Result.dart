// Widget chính hiển thị kết quả tìm kiếm
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as path;

import '../Lists/Results.dart';
import '../States/Empty.dart';
import '../States/NoResult.dart';

class SearchResultsView extends StatelessWidget {
  final List<File> pdfFiles;
  final String query;
  final Function(File) onFileSelected;

  const SearchResultsView({super.key,
    required this.pdfFiles,
    required this.query,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return SearchEmptyState();
    }

    final filteredFiles = _filterFiles();

    if (filteredFiles.isEmpty) {
      return SearchNoResultsState(query: query);
    }

    return SearchResultsList(
      files: filteredFiles,
      onFileSelected: onFileSelected,
    );
  }

  List<File> _filterFiles() {
    return pdfFiles
        .where((file) => path
        .basename(file.path)
        .toLowerCase()
        .contains(query.toLowerCase()))
        .toList();
  }
}