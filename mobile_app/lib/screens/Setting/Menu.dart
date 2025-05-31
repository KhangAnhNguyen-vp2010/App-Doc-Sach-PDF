import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Setting/Widgets/ThemeDialog.dart';
import 'package:provider/provider.dart';
import '../../Providers/ThemeProvider.dart';
import '../../generated/l10n.dart';
import '../List_PDF_Bookmarks/MarkedPagesScreen.dart';
import '../List_PDF_Favorite/FavoritedPagesScreen.dart';
import 'Widgets/LanguageDialog.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required Color colorItem,
    required Color colorCard,
    required Color colorText,
  }) {
    return Card(
      color: colorCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colorText),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: colorItem),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Color(0xFF2D3142),
        ),
        title: Text('⚙️${S.of(context).settings}⚙️',
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 22,
        ),),
        backgroundColor: isDark ? Colors.black87 : Colors.white10,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),  // Màu nền bạn muốn
        child: ListView(
          children: [
            SizedBox(height: 16),
            _buildSettingsItem(
              icon: Icons.language,
              title: S.of(context).language,
              color: Colors.blue,
              onTap: () {
                // Xử lý chọn ngôn ngữ
                showDialog(
                  context: context,
                  builder: (context) => const LanguageDialog(),
                );
              },
              colorCard: isDark ? Colors.black87 : Colors.white,
              colorItem: isDark ? Colors.white : Colors.grey,
              colorText: isDark ? Colors.white : Colors.black87,
            ),
            _buildSettingsItem(
              icon: Icons.color_lens,
              title: S.of(context).theme,
              color: Colors.purple,
              onTap: () {
                // Xử lý đổi theme
                showDialog(
                  context: context,
                  builder: (context) => const ThemeDialog(),
                );
              },
              colorCard: isDark ? Colors.black87 : Colors.white,
              colorItem: isDark ? Colors.white : Colors.grey,
              colorText: isDark ? Colors.white : Colors.black87,
            ),
            _buildSettingsItem(
              icon: Icons.bookmark,
              title: S.of(context).bookmarkList,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MarkedPagesScreen()),
                );
              },
              colorCard: isDark ? Colors.black87 : Colors.white,
              colorItem: isDark ? Colors.white : Colors.grey,
              colorText: isDark ? Colors.white : Colors.black87,
            ),
            _buildSettingsItem(
              icon: Icons.favorite,
              title: S.of(context).favoritesList,
              color: Colors.redAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FavoritedPagesScreen()),
                );
              },
              colorCard: isDark ? Colors.black87 : Colors.white,
              colorItem: isDark ? Colors.white : Colors.grey,
              colorText: isDark ? Colors.white : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
