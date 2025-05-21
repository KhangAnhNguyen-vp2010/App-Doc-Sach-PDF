import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../Provider/SearchTextProvider.dart';

class BookReaderScreen extends StatefulWidget {
  final String pdfUrl;

  const BookReaderScreen({super.key, required this.pdfUrl});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  late PdfViewerController _pdfController;
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  bool _isLoading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
  }


  @override
  void dispose() {
    _searchController.dispose();
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchTextProvider(pdfController: _pdfController),
        ),

      ],
      child: Consumer<SearchTextProvider>(
        builder: (context, searchProvider, child) {
          // Dùng cả 2 provider ở đây
          return Scaffold(
            appBar: AppBar(
              title: _isSearching
                  ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm...',
                  border: InputBorder.none,
                ),
                autofocus: true,
                onChanged: searchProvider.onSearchChanged,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    searchProvider.search(value);
                  }
                },
              )
                  : const Text(
                "Đang đọc sách",
                style: TextStyle(color: Colors.black, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              actions: [
                if (_isSearching)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black),
                    onPressed: () {
                      _searchController.clear();
                      searchProvider.clearSearch();
                      setState(() {});
                    },
                  ),
                IconButton(
                  icon: Icon(_isSearching
                      ? Icons.arrow_back_ios_new_rounded
                      : Icons.search,
                      color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        searchProvider.clearSearch();
                        _searchController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            body: Stack(
              children: [
                SfPdfViewer.network(
                  widget.pdfUrl,
                  controller: _pdfController,
                  onDocumentLoaded: (_) => setState(() => _isLoading = false),
                  onDocumentLoadFailed: (details) {
                    setState(() => _isLoading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi tải PDF: ${details.description}')),
                    );
                  },
                ),
                if (_isSearching)
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_upward),
                              onPressed: () {
                                searchProvider.previousInstance();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_downward),
                              onPressed: () {
                                searchProvider.nextInstance();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_isLoading)
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Chờ một chút...', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
