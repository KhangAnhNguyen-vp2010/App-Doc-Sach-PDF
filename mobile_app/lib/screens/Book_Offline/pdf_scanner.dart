import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import '../../Providers/ThemeProvider.dart';
import 'PdfScannerWidgets/Search/PdfSearchDelegate.dart';
import '../../services/permissions/dataAccess_permisson.dart';
import 'PdfScannerWidgets/AppBar.dart';
import 'PdfScannerWidgets/ListItem.dart';
import 'PdfScannerWidgets/OptionBottom.dart';
import 'PdfScannerWidgets/Supporting/Dialog/DeleteDialog.dart';
import 'PdfScannerWidgets/Supporting/Dialog/RenameDialog.dart';
import 'PdfScannerWidgets/Supporting/EmptyState.dart';
import 'PdfScannerWidgets/Supporting/Loading.dart';
import 'PdfViewerPage.dart';

class PdfListScreen extends StatefulWidget {
  const PdfListScreen({super.key});

  @override
  _PdfListScreenState createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _selectedSortOption = 'name_asc';
  List<File> _pdfFiles = [];
  int _filesToShow = 10;
  bool _isLoading = true;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Hive.openBox('markedPages');
    await Hive.openBox('favoriteBooks');
    await _loadFilesWithDelay();
  }

  Future<void> _loadFilesWithDelay() async {
    _pdfFiles = await requestPermissionAndLoadFiles(
        context,
        _loadPdfFiles,
        _loadFilesWithDelay);
    setState(() => _isLoading = false);
    await Future.delayed(Duration(milliseconds: 1500));
  }

  Future<List<File>> _loadPdfFiles() async {
    Directory downloadDir = Directory('/storage/emulated/0/Download');
    if (await downloadDir.exists()) {
      List<FileSystemEntity> files = downloadDir.listSync();
      List<File> filteredFiles = files
          .where((file) => file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();
      _sortFiles(filteredFiles);
      return filteredFiles;
    }
    return [];
  }

  void _loadMoreFiles() {
    if (_isLoadingMore || _filesToShow >= _pdfFiles.length) return;
    setState(() => _isLoadingMore = true);

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _filesToShow += 20;
        if (_filesToShow > _pdfFiles.length) _filesToShow = _pdfFiles.length;
        _isLoadingMore = false;
      });
    });
  }

  void _onSortChanged(String sortOption) {
    setState(() {
      _selectedSortOption = sortOption;
      _sortFiles();
    });
  }

  void _openPdfFile(File file) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfViewerPage(file: file))
    );
  }

  void _showOptionsMenu(BuildContext context, File file) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfOptionsBottomSheet(
        file: file,
        onRename: () => _showRenameDialog(file),
        onOpen: () => _openPdfFile(file),
        onDelete: () => _showDeleteDialog(file),
      ),
    );
  }

  void _showRenameDialog(File file) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PdfRenameDialog(
        file: file,
        onRenamed: (newFile) {
          setState(() {
            final index = _pdfFiles.indexOf(file);
            if (index != -1) {
              _pdfFiles[index] = newFile;
            }
          });
        },
      ),
    );
  }

  void _showDeleteDialog(File file) {
    showDialog(
      context: context,
      builder: (context) => PdfDeleteDialog(
        file: file,
        onDeleted: () {
          setState(() => _pdfFiles.remove(file));
        },
      ),
    );
  }

  void _sortFiles([List<File>? filesToSort]) {
    final files = filesToSort ?? _pdfFiles;

    switch (_selectedSortOption) {
      case 'name_asc':
        files.sort((a, b) => path.basename(a.path).compareTo(path.basename(b.path)));
        break;
      case 'size':
        files.sort((a, b) => a.lengthSync().compareTo(b.lengthSync()));
        break;
      case 'date':
        files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Scaffold(
      appBar: PdfAppBar(
        selectedSortOption: _selectedSortOption,
        onSortChanged: _onSortChanged,
        onSearch: () => showSearch(
          context: context,
          delegate: PdfSearchDelegate(_pdfFiles),
        ),
      ),
      backgroundColor: isDark ? Colors.black87 : Colors.grey[50],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return PdfLoadingWidget();
    }

    if (_pdfFiles.isEmpty) {
      return PdfEmptyState(
        onReload: () async {
          setState(() {
            _isLoading = true;
          });
          await _loadFilesWithDelay();
        },
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoadingMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMoreFiles();
        }
        return false;
      },
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: (_filesToShow < _pdfFiles.length)
            ? _filesToShow + 1 // để hiển thị thêm 1 item loading
            : _pdfFiles.length,
        separatorBuilder: (context, index) => SizedBox(height: 8),
        itemBuilder: (context, index) {
          if (index == _filesToShow && _filesToShow < _pdfFiles.length) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.indigoAccent),
                ),
              ),
            );
          }

          if (index >= _pdfFiles.length) return SizedBox(); // Tránh crash

          return PdfListItem(
            file: _pdfFiles[index],
            onTap: () => _openPdfFile(_pdfFiles[index]),
            onMoreOptions: () => _showOptionsMenu(context, _pdfFiles[index]),
          );
        },
      ),
    );
  }
}