import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../../Providers/ThemeProvider.dart';
import '../../PdfViewerPage.dart';
import 'Buttons/Back.dart';
import 'Buttons/Clear.dart';
import 'Views/Result.dart';

class PdfSearchDelegate extends SearchDelegate<File?> {
  final List<File> pdfFiles;

  PdfSearchDelegate(this.pdfFiles);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.black87 : theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: isDark ? Colors.white : theme.colorScheme.onSurface.withOpacity(0.6),
          fontSize: 16,
        ),
      ),
      textTheme: TextTheme(
        // Đây là text bạn nhập từ bàn phím
        titleLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  String get searchFieldLabel => "Search Files";

  @override
  Widget buildLeading(BuildContext context) {
    return SearchBackButton(onPressed: () => close(context, null));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      SearchClearButton(
        query: query,
        onClear: () => query = "",
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResultsView(
      pdfFiles: pdfFiles,
      query: query,
      onFileSelected: (file) => _handleFileSelection(context, file),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchResultsView(
      pdfFiles: pdfFiles,
      query: query,
      onFileSelected: (file) => _handleFileSelection(context, file),
    );
  }

  void _handleFileSelection(BuildContext context, File file) {
    close(context, file);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PdfViewerPage(file: file)),
    );
  }
}