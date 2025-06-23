// book_reader_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../Providers/SearchTextProvider.dart';
import '../../generated/l10n.dart';
import '../../services/BookServices/BookMarkService.dart';
import '../../services/BookServices/FavoriteService.dart';
import '../Common_Widgets/Appbar/CustomAppBar.dart';
import '../Common_Widgets/Appbar/SearchControls.dart';
import '../Common_Widgets/Loading/LoadingOverlay.dart';
import '../Common_Widgets/OptionBottom/OptionsBottomSheet.dart';
import '../Common_Widgets/Popup/GoToPageDialog.dart';
import '../Common_Widgets/Popup/NoteDialog.dart';

class BookReaderScreen extends StatefulWidget {
  final String pdfUrl;
  final String bookName;
  final String bookId;

  const BookReaderScreen({
    super.key,
    required this.pdfUrl,
    required this.bookName,
    required this.bookId,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  late PdfViewerController _pdfController;
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  bool _isLoading = true;
  bool _isMarked = false;
  bool _isFavorite = false;

  late final String fileName;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    fileName = "${widget.bookId} - ${widget.bookName}";
    _initializeBookState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pdfController.dispose();
    super.dispose();
  }

  Future<void> _initializeBookState() async {
    await Future.wait([
      _checkMarkedPage(fileName),
      _checkFavoriteStatus(fileName),
    ]);
  }

  // Bookmark functionality
  Future<void> _checkMarkedPage(String fileName) async {
    try {
      final data = await BookmarkService.getMarkedPage(fileName);
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
        widget.pdfUrl,
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

  Future<void> _toggleFavorite(BuildContext context) async {
    try {
      if (_isFavorite) {
        await FavoriteService.removeFavorite(fileName);
        _showSnackBar('❌ ${S.of(context).unlike}');
      } else {
        await FavoriteService.addFavorite(fileName, widget.pdfUrl);
        _showSnackBar('❤️ ${S.of(context).liked}');
      }

      setState(() => _isFavorite = !_isFavorite);
    } catch (e) {
      _showSnackBar(S.of(context).anErrorOccurredPleaseTryAgain);
      debugPrint('Error toggling favorite: $e');
    }
  }

  // UI Actions
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
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
        bookName: widget.bookName,
        bookUrl: widget.pdfUrl,
        isMarked: _isMarked,
        isFavorite: _isFavorite,
        onToggleBookmark: _toggleMarkedPage,
        onToggleFavorite: ()=>{_toggleFavorite(context)},
        onGoToPage: _showGoToPageDialog,
        typeName: "online",
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
      onWillPop: () async => !_isLoading,
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
                titleName: S.of(context).readingABook,
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
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPdfViewer() {
    return SfPdfViewer.network(
      widget.pdfUrl,
      controller: _pdfController,
      onDocumentLoaded: (_) => setState(() => _isLoading = false),
      onDocumentLoadFailed: (details) {
        setState(() => _isLoading = false);
        _showSnackBar(
          '${S.of(context).errorLoadingPDF}: ${details.description}',
          backgroundColor: Colors.red,
        );
      },
    );
  }
}




