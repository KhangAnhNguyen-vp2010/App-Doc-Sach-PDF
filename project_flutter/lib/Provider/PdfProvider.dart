import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class PdfProvider extends ChangeNotifier {
  List<File> _pdfFiles = [];
  Map<String, bool> _bookmarkedFiles = {};
  Map<String, bool> _favoriteFiles = {};
  String _selectedSortOption = 'name_asc'; // Mặc định sắp xếp theo tên (A-Z)

  List<File> get pdfFiles => _pdfFiles;
  Map<String, bool> get bookmarkedFiles => _bookmarkedFiles;
  Map<String, bool> get favoriteFiles => _favoriteFiles;
  String get selectedSortOption => _selectedSortOption;

  // Load PDF files from storage
  Future<void> loadPdfFiles() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      Directory downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) {
        List<FileSystemEntity> files = downloadDir.listSync();
        List<File> pdfFiles = files.where((file) => file.path.endsWith('.pdf')).map((file) => File(file.path)).toList();
        pdfFiles.sort((a, b) => path.basename(a.path).compareTo(path.basename(b.path)));
        _pdfFiles = pdfFiles;
        notifyListeners();
      }
    }
  }

  void toggleBookmark(File file) {
    _bookmarkedFiles[file.path] = !(_bookmarkedFiles[file.path] ?? false);
    notifyListeners();
  }

  void toggleFavorite(File file) {
    _favoriteFiles[file.path] = !(_favoriteFiles[file.path] ?? false);
    notifyListeners();
  }

  void changeSortOption(String newSortOption) {
    _selectedSortOption = newSortOption;
    _sortFiles();
    notifyListeners();
  }

  void _sortFiles() {
    if (_selectedSortOption == 'name_asc') {
      _pdfFiles.sort((a, b) => path.basename(a.path).compareTo(path.basename(b.path)));
    } else if (_selectedSortOption == 'size') {
      _pdfFiles.sort((a, b) => a.lengthSync().compareTo(b.lengthSync()));
    } else if (_selectedSortOption == 'date') {
      _pdfFiles.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
    }
  }
}
