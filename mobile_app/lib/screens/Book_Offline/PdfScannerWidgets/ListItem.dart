import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class PdfListItem extends StatelessWidget {
  final File file;
  final VoidCallback onTap;
  final VoidCallback onMoreOptions;

  const PdfListItem({
    Key? key,
    required this.file,
    required this.onTap,
    required this.onMoreOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFileIcon(),
                SizedBox(width: 16),
                Expanded(child: _buildFileInfo()),
                _buildMoreButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
        size: 24,
      ),
    );
  }

  Widget _buildFileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          path.basename(file.path).replaceAll('.pdf', ''),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.folder_outlined,
              size: 14,
              color: Colors.grey[500],
            ),
            SizedBox(width: 4),
            Text(
              _getFileSize(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.schedule,
              size: 14,
              color: Colors.grey[500],
            ),
            SizedBox(width: 4),
            Text(
              _getFormattedDate(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMoreButton() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey[600],
          size: 18,
        ),
        onPressed: onMoreOptions,
        padding: EdgeInsets.zero,
      ),
    );
  }

  String _getFileSize() {
    int bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getFormattedDate() {
    DateTime lastModified = file.lastModifiedSync();
    return '${lastModified.day.toString().padLeft(2, '0')}/${lastModified.month.toString().padLeft(2, '0')}/${lastModified.year}';
  }
}