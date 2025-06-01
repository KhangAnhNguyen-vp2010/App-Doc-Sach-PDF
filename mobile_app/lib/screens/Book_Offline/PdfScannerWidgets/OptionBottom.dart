import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../Providers/ThemeProvider.dart';
import '../../../generated/l10n.dart';
import '../../../services/BookMarkService.dart';
import '../../../services/FavoriteService.dart';

class PdfOptionsBottomSheet extends StatefulWidget {
  final File file;
  final VoidCallback onRename;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const PdfOptionsBottomSheet({
    super.key,
    required this.file,
    required this.onRename,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  _PdfOptionsBottomSheetState createState() => _PdfOptionsBottomSheetState();
}

class _PdfOptionsBottomSheetState extends State<PdfOptionsBottomSheet> {
  bool _isMarked = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    await _checkMarkedPage();
    await _checkFavoriteStatus();
  }

  Future<void> _checkMarkedPage() async {
    try {
      final data = await BookmarkService.getMarkedPage(path.basename(widget.file.path));
      if (mounted) {
        setState(() => _isMarked = data?['page'] != null);
      }
    } catch (e) {
      debugPrint('Error checking marked page: $e');
    }
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await FavoriteService.isFavorite(path.basename(widget.file.path));
    if (mounted) {
      setState(() => _isFavorite = isFavorite);
    }
  }

  void _toggleMarkedPage() {
    if (_isMarked) {
      BookmarkService.removeMarkedPage(path.basename(widget.file.path));
      setState(() => _isMarked = false);
    } else {
      BookmarkService.saveMarkedPage(
          path.basename(widget.file.path),
          1,
          S.of(context).temporary_note,
          ""
      );
      setState(() => _isMarked = true);
    }
  }

  void _toggleFavorite() {
    try {
      if (_isFavorite) {
        FavoriteService.removeFavorite(path.basename(widget.file.path));
        setState(() => _isFavorite = false);
      } else {
        FavoriteService.addFavorite(path.basename(widget.file.path), "");
        setState(() => _isFavorite = true);
      }
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.black87 : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildFileHeader(),
          Divider(height: 1, color: Colors.grey[200]),
          _buildActionButtons(),
          Divider(height: 1, color: Colors.grey[200]),
          _buildMenuOptions(),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: EdgeInsets.only(top: 12, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildFileHeader() {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  path.basename(widget.file.path),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.file.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('markedPages').listenable(),
              builder: (context, box, widget) {
                return _buildActionButton(
                  icon: _isMarked ? Icons.bookmark : Icons.bookmark_border,
                  label: 'Bookmark',
                  color: _isMarked ? Colors.amber : (isDark ? Colors.white : Colors.grey[600]!),
                  onTap: _toggleMarkedPage,
                );
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('favoriteBooks').listenable(),
              builder: (context, box, widget) {
                return _buildActionButton(
                  icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                  label: 'Yêu thích',
                  color: _isFavorite ? Colors.red : (isDark ? Colors.white : Colors.grey[600]!),
                  onTap: _toggleFavorite,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOptions() {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Column(
      children: [
        _buildMenuOption(
          icon: Icons.open_in_new,
          title: S.of(context).openFile,
          onTap: () {
            Navigator.pop(context);
            widget.onOpen();
          },
          color: isDark ? Colors.white : Colors.grey[700],
        ),
        _buildMenuOption(
          icon: Icons.edit,
          title: S.of(context).rename,
          onTap: () {
            Navigator.pop(context);
            widget.onRename();
          },
          color: isDark ? Colors.white : Colors.grey[700],
        ),
        _buildMenuOption(
          icon: Icons.share,
          title: S.of(context).share,
          onTap: () async {
            Navigator.pop(context);
            await Share.shareXFiles([XFile(widget.file.path)], text: "Xem tài liệu này");
          },
          color: isDark ? Colors.white : Colors.grey[700],
        ),
        _buildMenuOption(
          icon: Icons.delete,
          title: S.of(context).delete,
          color: Colors.red,
          onTap: () {
            Navigator.pop(context);
            widget.onDelete();
          },
        ),
      ],
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color;

    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: itemColor!.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: itemColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: itemColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }
}