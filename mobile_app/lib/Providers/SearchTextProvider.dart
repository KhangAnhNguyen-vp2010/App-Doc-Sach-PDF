import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SearchTextProvider extends ChangeNotifier {
  final PdfViewerController pdfController;

  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  PdfTextSearchResult get searchResult => _searchResult;

  Timer? _debounce;

  SearchTextProvider({required this.pdfController});

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (query.isNotEmpty) {
        search(query);
      } else {
        clearSearch();
      }
    });
  }

  Future<void> search(String text) async {
    _searchResult = await pdfController.searchText(text);
    notifyListeners();
  }

  void clearSearch() {
    _searchResult.clear();
    notifyListeners();
  }

  void previousInstance() {
    _searchResult.previousInstance();
  }

  void nextInstance() {
    _searchResult.nextInstance();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
