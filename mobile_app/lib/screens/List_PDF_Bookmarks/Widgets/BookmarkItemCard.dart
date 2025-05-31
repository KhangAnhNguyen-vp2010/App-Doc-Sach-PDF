
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class BookmarkItemCard extends StatelessWidget {
  final String fileName;
  final dynamic data;
  final VoidCallback onTap;

  const BookmarkItemCard({
    super.key,
    required this.fileName,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int page = data['page'];
    final String note = data['note'];
    final String? url = data['link'];
    final bool isOnlineBook = url != "";

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookmarkIcon(isOnlineBook),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBookTitle(fileName, isOnlineBook),
                    const SizedBox(height: 8),
                    _buildPageInfo(page, context),
                    if (note.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildNoteSection(note),
                    ],
                    const SizedBox(height: 8),
                    _buildBookTypeChip(isOnlineBook, context),
                  ],
                ),
              ),
              _buildArrowIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkIcon(bool isOnlineBook) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Icon(
        isOnlineBook ? Icons.cloud_download : Icons.folder,
        color: Colors.amber[700],
        size: 24,
      ),
    );
  }

  Widget _buildBookTitle(String fileName, bool isOnline) {
    String displayName = fileName;

    if(isOnline) {
      displayName = fileName.substring(fileName.indexOf('-') + 1).trim();
    }

    return Text(
      displayName,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPageInfo(int page, BuildContext context) {
    return Row(
      children: [
        Icon(Icons.menu_book, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          "${S.of(context).page} $page",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteSection(String note) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.sticky_note_2, size: 16, color: Colors.blue[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              note,
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue[800],
                fontStyle: FontStyle.italic,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookTypeChip(bool isOnlineBook, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOnlineBook ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOnlineBook ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnlineBook ? Icons.cloud : Icons.phone_android,
            size: 12,
            color: isOnlineBook ? Colors.green[700] : Colors.orange[700],
          ),
          const SizedBox(width: 4),
          Text(
            isOnlineBook ? S.of(context).onlineBooks : S.of(context).offlineBooks,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isOnlineBook ? Colors.green[700] : Colors.orange[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
    );
  }
}