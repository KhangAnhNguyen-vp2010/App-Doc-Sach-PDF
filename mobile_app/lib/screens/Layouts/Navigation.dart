import 'package:flutter/material.dart';
import 'package:mobile_app/screens/Layouts/Widgets/comment_dialog.dart';
import 'package:mobile_app/screens/Layouts/Widgets/moreApp_dialog.dart';
import 'package:mobile_app/screens/Layouts/Widgets/privacyPolicy_dialog.dart';
import 'package:provider/provider.dart';
import '../../Providers/ThemeProvider.dart';
import '../../generated/l10n.dart';
import '../Book_Offline/pdf_scanner.dart';
import '../Book_Online/BookStoreSreen.dart';
import '../Setting/Menu.dart';
import 'Widgets/rating_dialog.dart';


class NavApp extends StatefulWidget {
  const NavApp({super.key});


  @override
  State<NavApp> createState() => _NavAppState();
}

class _NavAppState extends State<NavApp> {
  int _selectedIndex = 1; // Chỉ số của tab được chọn
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    PdfListScreen(),
    BookStoreHomePage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  String getTitleByIndex(int index) {
    switch (index) {
      case 0:
        return S.of(context).allFiles;
      case 1:
        return S.of(context).books;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer( // Thêm drawer
        backgroundColor: isDark ? Colors.black87 : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).allTrusted,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    S.of(context).pDFReader,
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    S.of(context).version2025,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: isDark ? Colors.white : Color(0xFF2D3142)),
              title: Text(
                S.of(context).settings,
                style: TextStyle(
                    color: isDark ? Colors.white : Color(0xFF2D3142)
                )
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Menu()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.thumb_up, color: isDark ? Colors.white : Color(0xFF2D3142)),
              title: Text(
                  S.of(context).appReview,
                  style: TextStyle(
                      color: isDark ? Colors.white : Color(0xFF2D3142)
                  )
              ),
              onTap: () {
                // Xử lý khi nhấn Đánh giá ứng dụng
                showDialog(
                  context: context,
                  builder: (_) => const RatingDialog(),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: isDark ? Colors.white : Color(0xFF2D3142)),
              title: Text(
                  S.of(context).comment,
                  style: TextStyle(
                      color: isDark ? Colors.white : Color(0xFF2D3142)
                  )
              ),
              onTap: () {
                // Xử lý khi nhấn Nhận xét
                showDialog(
                  context: context,
                  builder: (_) => const CommentDialog(),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.security, color: isDark ? Colors.white : Color(0xFF2D3142)),
              title: Text(
                  S.of(context).privacyPolicy,
                  style: TextStyle(
                      color: isDark ? Colors.white : Color(0xFF2D3142)
                  )
              ),
              onTap: () {
                // Xử lý khi nhấn Chính sách bảo mật
                showDialog(
                  context: context,
                  builder: (_) => PrivacyPolicyDialog(privacyText: S.of(context).privacyText),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.apps, color: isDark ? Colors.white : Color(0xFF2D3142)),
              title: Text(
                  S.of(context).moreApplications,
                  style: TextStyle(
                      color: isDark ? Colors.white : Color(0xFF2D3142)
                  )
              ),
              onTap: () {
                // Xử lý khi nhấn Nhiều ứng dụng hơn
                showDialog(
                  context: context,
                  builder: (_) => MoreAppsDialog(),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black87 : Colors.white10,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: isDark ? Colors.white : Color(0xFF2D3142)),
          onPressed: () {
            // Xử lý khi nhấn menu
            _scaffoldKey.currentState?.openDrawer();  // Mở drawer khi nhấn nút menu
          },
        ),
        title: Text(
          getTitleByIndex(_selectedIndex),
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.book_rounded,
              color: Colors.orange,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: const Icon(
              Icons.book_rounded,
              color: Colors.blueAccent,
            ),
            onPressed: null,
          ),
          IconButton(
            icon: const Icon(
              Icons.book_rounded,
              color: Colors.green,
            ),
            onPressed: null,
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 1000), // Thời gian hiệu ứng
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child); // Hiệu ứng fade
        },
        child: _screens[_selectedIndex], // Hiển thị màn hình tương ứng
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? Colors.grey.shade400 : null,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.file_copy),
            label: S.of(context).allFiles,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: S.of(context).books,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: isDark ? Colors.white : Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}