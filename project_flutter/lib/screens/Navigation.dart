import 'package:flutter/material.dart';
import 'package:project_flutter/screens/Book_Online/BookStoreSreen.dart';
import 'package:project_flutter/screens/BooksScreen.dart';
import 'package:project_flutter/screens/HistoryScreen.dart';
import 'package:project_flutter/screens/List_PDF_Online/Read_Online.dart';
import 'package:project_flutter/screens/pdf_scanner.dart';
import 'package:project_flutter/screens/temp.dart';
import '../services/PdfSearchDelegate.dart';


class NavApp extends StatefulWidget {

  @override
  State<NavApp> createState() => _NavAppState();
}

class _NavAppState extends State<NavApp> {
  int _selectedIndex = 1; // Chỉ số của tab được chọn
  String title = "Books";
  bool _isDarkMode = false;
  final PageController _pageController = PageController(initialPage: 1);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  final List<Widget> _screens = [
    PdfListScreen(),
    BookStoreHomePage(),
    HistoryScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch(index){
      case 0:
        title = "All Files";
        break;
      case 1:
        title = "Books";
        break;
      case 2:
        title = "History";
        break;
      default:
        break;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(  // Thêm drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Trusted',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'PDF Reader',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Phiên bản 4.3.4',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Ngôn ngữ'),
              onTap: () {
                // Xử lý khi nhấn Ngôn ngữ
                Navigator.push(context, MaterialPageRoute(builder: (context) => temp()));
              },
            ),
            ListTile(
              leading: Icon(Icons.thumb_up),
              title: Text('Đánh giá ứng dụng'),
              onTap: () {
                // Xử lý khi nhấn Đánh giá ứng dụng
                Navigator.push(context, MaterialPageRoute(builder: (context) => PDFScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Nhận xét'),
              onTap: () {
                // Xử lý khi nhấn Nhận xét
              },
            ),
            ListTile(
              leading: Icon(Icons.security),
              title: Text('Chính sách bảo mật'),
              onTap: () {
                // Xử lý khi nhấn Chính sách bảo mật
              },
            ),
            ListTile(
              leading: Icon(Icons.apps),
              title: Text('Nhiều ứng dụng hơn'),
              onTap: () {
                // Xử lý khi nhấn Nhiều ứng dụng hơn
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF2D3142)),
          onPressed: () {
            // Xử lý khi nhấn menu
            _scaffoldKey.currentState?.openDrawer();  // Mở drawer khi nhấn nút menu
          },
        ),
        title: Text(
          '${title}',
          style: TextStyle(
            color: Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: Colors.orange,
            ),
            onPressed: () {
              // Xử lý khi nhấn icon check
            },
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.black),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Tất cả các tệp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Sách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_circle_rounded),
            label: 'Công cụ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}