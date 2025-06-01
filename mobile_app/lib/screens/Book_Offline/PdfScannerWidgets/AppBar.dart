import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class PdfAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String selectedSortOption;
  final Function(String) onSortChanged;
  final VoidCallback onSearch;

  const PdfAppBar({
    super.key,
    required this.selectedSortOption,
    required this.onSortChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigoAccent,
      elevation: 2,
      shadowColor: Colors.black26,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  S.of(context).allYourFiles,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        _buildSearchButton(context),
        _buildSortMenu(context),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(Icons.search, color: Colors.white),
        onPressed: onSearch,
        tooltip: 'Tìm kiếm',
      ),
    );
  }

  Widget _buildSortMenu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PopupMenuButton<String>(
        icon: Icon(Icons.sort, color: Colors.white),
        tooltip: 'Sắp xếp',
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onSelected: onSortChanged,
        itemBuilder: (BuildContext context) => [
          _buildSortMenuItem(
            context,
            'name_asc',
            '${S.of(context).name} (A-Z)',
            Icons.sort_by_alpha,
          ),
          _buildSortMenuItem(
            context,
            'size',
            S.of(context).size,
            Icons.insert_drive_file_outlined,
          ),
          _buildSortMenuItem(
            context,
            'date',
            S.of(context).time,
            Icons.access_time,
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(
      BuildContext context,
      String value,
      String label,
      IconData icon,
      ) {
    final bool isSelected = selectedSortOption == value;

    return PopupMenuItem<String>(
      value: value,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.indigoAccent : Colors.grey[600],
              size: 20,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.indigoAccent : Colors.grey[800],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Colors.indigoAccent,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}