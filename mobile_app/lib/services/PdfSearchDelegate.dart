import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../generated/l10n.dart';
import '../screens/Book_Offline/PdfViewerPage.dart';

class PdfSearchDelegate extends SearchDelegate<File?> {
  final List<File> pdfFiles;

  PdfSearchDelegate(this.pdfFiles);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Đóng thanh tìm kiếm
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    List<File> filteredFiles = pdfFiles
        .where((file) => path.basename(file.path).toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (filteredFiles.isEmpty) {
      return Center(child: Text(S.of(context).noFilesFound));
    }

    return ListView.builder(
      itemCount: filteredFiles.length,
      itemBuilder: (context, index) {
        File file = filteredFiles[index];
        return ListTile(
          leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
          title: Text(path.basename(file.path).replaceAll('.pdf', ''), maxLines: 1, overflow: TextOverflow.ellipsis),
          onTap: () {
            close(context, file); // Đóng search và trả về file
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PdfViewerPage(file: file)),
            );
          },
        );
      },
    );
  }
}
