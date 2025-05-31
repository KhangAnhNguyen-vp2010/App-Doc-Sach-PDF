import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;
import '../../Providers/SearchTextProvider.dart';
import '../../generated/l10n.dart';
import '../../services/BookMarkService.dart';
import '../../services/FavoriteService.dart';
import '../Common_Widgets/Appbar/CustomAppBar.dart';
import '../Common_Widgets/Appbar/SearchControls.dart';
import '../Common_Widgets/Loading/LoadingOverlay.dart';
import '../Common_Widgets/OptionBottom/OptionsBottomSheet.dart';
import '../Common_Widgets/Popup/GoToPageDialog.dart';
import '../Common_Widgets/Popup/NoteDialog.dart';

class PdfViewerPage extends StatefulWidget {
  final File file;

  const PdfViewerPage({super.key, required this.file});

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfViewerController _pdfController;
  late PdfTextSearchResult _searchResult;
  final TextEditingController _searchController = TextEditingController();
  late final String fileName;
  bool _isMarked = false; // Thêm biến theo dõi trạng thái đánh dấu
  bool _isFavorite = false;
  bool _isSearching = false;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _searchResult = PdfTextSearchResult();
    fileName = path.basename(widget.file.path);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _initializeBookState();

        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // Dừng search trước khi dispose
    _searchResult.clear();

    // Clear controller trước
    _searchController.dispose();

    // Dispose PDF controller sau cùng
    _pdfController.dispose();

    super.dispose();
  }


  Future<void> _initializeBookState() async {
    await Future.wait([
      _checkMarkedPage(fileName),
      _checkFavoriteStatus(fileName),
    ]);
  }

  Future<void> _checkMarkedPage(String fileName) async {
    try {
      final data = await BookmarkService.getMarkedPage(fileName);
      if (!mounted) return;
      final markedPage = data?['page'];
      final note = data?['note'];

      if (markedPage != null) {
        setState(() => _isMarked = true);
        _pdfController.jumpToPage(markedPage);
      }

      if (note != null) {
        debugPrint('Note: $note');
      }
    } catch (e) {
      debugPrint('Error checking marked page: $e');
    }
  }

  Future<void> _toggleMarkedPage() async {
    if (_isMarked) {
      await BookmarkService.removeMarkedPage(fileName);
      _showSnackBar('❌ ${S.of(context).unBookmarked}');
      setState(() => _isMarked = false);
    } else {
      await _showNoteDialogAndMark();
    }
  }

  Future<void> _showNoteDialogAndMark() async {
    final note = await showDialog<String>(
      context: context,
      builder: (context) => NoteDialog(),
    );

    if (note != null && note.trim().isNotEmpty) {
      await BookmarkService.saveMarkedPage(
        fileName,
        _pdfController.pageNumber,
        note.trim(),
        "",
      );
      _showSnackBar('✅ ${S.of(context).bookmarked} ${_pdfController.pageNumber} ${S.of(context).withNotes}!');
      setState(() => _isMarked = true);
    }
  }

  // Favorite functionality
  Future<void> _checkFavoriteStatus(String fileName) async {
    final isFavorite = await FavoriteService.isFavorite(fileName);
    setState(() => _isFavorite = isFavorite);
  }

  Future<void> _toggleFavorite() async {
    try {
      if (_isFavorite) {
        await FavoriteService.removeFavorite(fileName);
        _showSnackBar('❌ ${S.of(context).unliked}');
      } else {
        await FavoriteService.addFavorite(fileName, "");
        _showSnackBar('❤️ ${S.of(context).likes}');
      }

      setState(() => _isFavorite = !_isFavorite);
    } catch (e) {
      _showSnackBar('Có lỗi xảy ra, vui lòng thử lại');
      debugPrint('Error toggling favorite: $e');
    }
  }

  // UI Actions
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchTextProvider>().clearSearch();
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OptionsBottomSheet(
        bookName: fileName,
        bookUrl: widget.file.path,
        isMarked: _isMarked,
        isFavorite: _isFavorite,
        onToggleBookmark: _toggleMarkedPage,
        onToggleFavorite: _toggleFavorite,
        onGoToPage: _showGoToPageDialog,
        typeName: "offline",
      ),
    );
  }

  void _showGoToPageDialog() {
    showDialog(
      context: context,
      builder: (context) => GoToPageDialog(
        totalPages: _pdfController.pageCount,
        onGoToPage: (page) => _pdfController.jumpToPage(page),
      ),
    );
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: backgroundColor ?? Colors.blueAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async => !_isLoading, // Chỉ cho back khi không loading
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => SearchTextProvider(pdfController: _pdfController),
            ),
          ],
          child: Consumer<SearchTextProvider>(
              builder: (context, searchProvider, child) {
                return Scaffold(
                    appBar: CustomAppBar(
                      titleName: fileName,
                      isSearching: _isSearching,
                      searchController: _searchController,
                      onToggleSearch: _toggleSearch,
                      onClearSearch: _clearSearch,
                      onShowOptions: _showOptionsBottomSheet,
                      onSearchChanged: searchProvider.onSearchChanged,
                      onSearchSubmitted: (value) {
                        if (value.isNotEmpty) {
                          searchProvider.search(value);
                        }
                      },
                      isLoading: !_isLoading,
                    ),
                    body: Stack(
                      children: [
                        _buildPdfViewer(),
                        if (_isSearching)
                          SearchControls(
                            onPrevious: searchProvider.previousInstance,
                            onNext: searchProvider.nextInstance,
                          ),
                        if (_isLoading) const LoadingOverlay(),
                      ],
                    )
                );
              }
          ),
        )
    );
  }

  Widget _buildPdfViewer() {
    return SfPdfViewer.file(
      widget.file,
      controller: _pdfController,
      enableDoubleTapZooming: true,
      pageLayoutMode: PdfPageLayoutMode.continuous,
      canShowScrollHead: true,
      canShowScrollStatus: true,
    );
  }
}


