import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class FavoriteBookCard extends StatelessWidget {
  final String fileName;
  final dynamic data;
  final VoidCallback onTap;

  const FavoriteBookCard({
    super.key,
    required this.fileName,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Null safety checks
    if (data == null) {
      return const SizedBox.shrink();
    }

    final String? url = data is Map ? data['link'] : null;
    final bool isOnlineBook = url != "";

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: Colors.pink.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.pink[25] ?? Colors.pink.shade50,
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildBookIcon(isOnlineBook),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBookTitle(fileName, isOnlineBook),
                    const SizedBox(height: 8),
                    _buildFavoriteInfo(context),
                    const SizedBox(height: 12),
                    _buildBookTypeChip(isOnlineBook, context),
                  ],
                ),
              ),
              _buildFavoriteHeart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookIcon(bool isOnlineBook) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink[100] ?? Colors.pink.shade100,
            Colors.pink[200] ?? Colors.pink.shade200,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        isOnlineBook ? Icons.cloud_download : Icons.menu_book,
        color: Colors.white,
        size: 28,
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
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFavoriteInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.pink[50] ?? Colors.pink.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink[200] ?? Colors.pink.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.thumb_up, size: 14, color: Colors.pink[600] ?? Colors.pink.shade600),
          const SizedBox(width: 6),
          Text(
            S.of(context).youHaveLiked,
            style: TextStyle(
              fontSize: 12,
              color: Colors.pink[700] ?? Colors.pink.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookTypeChip(bool isOnlineBook, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isOnlineBook ? (Colors.green[50] ?? Colors.green.shade50) : (Colors.orange[50] ?? Colors.orange.shade50),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isOnlineBook ? (Colors.green[300] ?? Colors.green.shade300) : (Colors.orange[300] ?? Colors.orange.shade300),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnlineBook ? Icons.wifi : Icons.offline_pin,
            size: 14,
            color: isOnlineBook ? (Colors.green[700] ?? Colors.green.shade700) : (Colors.orange[700] ?? Colors.orange.shade700),
          ),
          const SizedBox(width: 6),
          Text(
            isOnlineBook ? S.of(context).onlineBooks : S.of(context).offlineBooks,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isOnlineBook ? (Colors.green[700] ?? Colors.green.shade700) : (Colors.orange[700] ?? Colors.orange.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteHeart() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50] ?? Colors.red.shade50,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red[200] ?? Colors.red.shade200),
      ),
      child: Icon(
        Icons.favorite,
        color: Colors.red[600] ?? Colors.red.shade600,
        size: 24,
      ),
    );
  }
}