import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:project_flutter/screens/BooksScreen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'List_PDF_Bookmarks/MarkedPagesScreen.dart';
import 'List_PDF_Favorite/FavoriteFilesPage.dart'; // Thêm thư viện để chia sẻ

class PdfViewerPage extends StatefulWidget {
  final File file;

  const PdfViewerPage({Key? key, required this.file}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late PdfViewerController _pdfController;
  bool _isMarked = false; // Thêm biến theo dõi trạng thái đánh dấu
  bool _isFavorite = false;
  late PdfTextSearchResult _searchResult;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _searchResult = PdfTextSearchResult();

    _checkMarkedPage(); // Kiểm tra trang đánh dấu
    _checkFavoriteStatus(); // Kiểm tra yêu thích
    // Giả lập việc tải trong 3 giây
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  /// Chức năng bookmark
  void _checkMarkedPage() {
    String fileName = path.basename(widget.file.path);
    getMarkedPage(fileName).then((data) {
      var markedPage = data['page'];
      var _note = data['note'];
      if (markedPage != null) {
        setState(() {
          _isMarked = true; // Đánh dấu trang đã lưu
        });
        _pdfController.jumpToPage(markedPage); // Nhảy đến trang đã đánh dấu
      }

      if (_note != null) {
        // Handle the note if it exists
        print('Note: $_note');
        // You can display the note in your UI if needed
      }
    });
  }

  // Hàm xử lý đánh dấu hoặc bỏ lưu trang
  void _toggleMarkedPage() {
    String fileName = path.basename(widget.file.path);
    if (_isMarked) {
      removeMarkedPage(fileName);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Đã bỏ đánh dấu'), duration: Duration(seconds: 2), backgroundColor: Colors.blueAccent,));
      setState(() {
        _isMarked = false;
      });
    } else {
      _showNoteDialogAndMark(); // gọi nhập ghi chú
    }
  }

  Future<void> saveMarkedPage(String fileName, int page, String note) async {
    var box = await Hive.openBox('markedPages');
    box.put(fileName, {"page": page, "note": note});
  }

  Future<dynamic> getMarkedPage(String fileName) async {
    var box = await Hive.openBox('markedPages');
    return box.get(fileName);
  }

  Future<void> removeMarkedPage(String fileName) async {
    var box = await Hive.openBox('markedPages');
    await box.delete(fileName); // Xóa dữ liệu đã lưu
    print("Đã bỏ đánh dấu file $fileName");
  }

  Future<void> _showNoteDialogAndMark() async {
    TextEditingController _noteController = TextEditingController();

    String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sticky_note_2_rounded, size: 48, color: Colors.amber[800]),
                const SizedBox(height: 10),
                const Text(
                  'Thêm ghi chú',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Ví dụ: Đoạn này cần đọc kỹ lại",
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text("Huỷ"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Lưu", style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context, _noteController.text);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null && result.trim().isNotEmpty) {
      String fileName = path.basename(widget.file.path);
      saveMarkedPage(fileName, _pdfController.pageNumber, result.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Đã đánh dấu trang ${_pdfController.pageNumber} kèm ghi chú!'),duration: Duration(seconds: 2), backgroundColor: Colors.blueAccent,),
      );
      setState(() {
        _isMarked = true;
      });
    }
  }


  /// Chức năng yêu thích
  Future<void> _toggleFavorite() async {
    String fileName = path.basename(widget.file.path);
    var box = await Hive.openBox('favoriteBooks');

    if (_isFavorite) {
      await box.delete(fileName); // Nếu đã yêu thích, xóa khỏi danh sách
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Đã bỏ thích'), duration: Duration(seconds: 2), backgroundColor: Colors.blueAccent,),
      );
    } else {
      await box.put(fileName, true); // Nếu chưa yêu thích, thêm vào danh sách
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❤️ Đã thích'), duration: Duration(seconds: 2), backgroundColor: Colors.blueAccent,),
      );
    }

    setState(() {
      _isFavorite = !_isFavorite; // Cập nhật UI ngay lập tức
    });
  }

  Future<void> _checkFavoriteStatus() async {
    String fileName = path.basename(widget.file.path);
    var box = await Hive.openBox('favoriteBooks');

    setState(() {
      _isFavorite = box.containsKey(fileName); // Nếu có trong danh sách thì là yêu thích
    });
  }

  void _showOptionsBottomSheet() {

    String fileName = path.basename(widget.file.path);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Phần header với tên file và icon
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Icon(Icons.picture_as_pdf, color: Colors.red),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fileName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'redragon.me/stored/0/Download',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),

              // Phần các nút tùy chọn dạng grid
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOptionButton(
                      icon: Icons.share,
                      label: 'Chia sẻ',
                      onTap: () {
                        Share.shareFiles([widget.file.path]);
                        Navigator.pop(context);
                      },
                    ),

                    _buildOptionButton(
                      icon: Icons.skip_next,
                      label: 'Đi đến trang',
                      onTap: () {
                        Navigator.pop(context);
                        _showGoToPageDialog();
                      },
                    ),

                    _buildOptionButton(
                      icon: Icons.add_to_home_screen,
                      label: 'Tạo biểu tượng tắt',
                      onTap: () {
                        // Thêm code xử lý tạo biểu tượng tắt
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MarkedPagesScreen()
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),

              _buildListOption(
                icon: Icons.bookmark,
                iconColor: _isMarked ? Colors.amber : null,
                title: _isMarked ? "Bỏ đánh dấu" : "Đánh dấu",
                onTap: () {
                  Navigator.pop(context);
                  _toggleMarkedPage();
                },
              ),

              _buildListOption(
                icon: Icons.favorite,
                iconColor: _isFavorite ? Colors.redAccent : null,
                title: _isFavorite ? "Bỏ thích" : 'Thích',
                onTap: () {
                  Navigator.pop(context);
                  _toggleFavorite();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(12),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(color: textColor),),
      onTap: onTap,
      dense: true,
    );
  }

  void _showGoToPageDialog() {
    TextEditingController _pageController = TextEditingController();
    int totalPages = _pdfController.pageCount;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đi đến trang'),
          content: TextField(
            controller: _pageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Nhập số trang (1-$totalPages)',
            ),
          ),
          actions: [
            TextButton(
              child: Text('HỦY'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('ĐI ĐẾN'),
              onPressed: () {
                int? pageNumber = int.tryParse(_pageController.text);
                if (pageNumber != null && pageNumber > 0 && pageNumber <= totalPages) {
                  _pdfController.jumpToPage(pageNumber);
                }else {
                  // Hiển thị thông báo khi số trang không hợp lệ
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Số trang không hợp lệ!')),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    String fileName = path.basename(widget.file.path);

    return _isLoading
        ? Scaffold(
            backgroundColor: Colors.white, // Đặt màu nền là trắng khi loading
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(), // Hiển thị loading
                  SizedBox(height: 10), // Khoảng cách giữa biểu tượng và text
                  Text(
                    'Chờ một chút...', // Thêm đoạn text này
                    style: TextStyle(
                      fontSize: 16, // Cỡ chữ
                      fontWeight: FontWeight.bold, // Đậm
                    ),
                  ),
                ],
              ),
            ),
          ) // Hiển thị loading trong 3 giây
        : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm...',
            border: InputBorder.none,
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _searchResult = _pdfController.searchText(value);
              _searchResult.addListener(() {
                if (_searchResult.hasResult) {
                  setState(() {});
                }
              });
            }
          },
        )
            : Text(
          fileName,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),

        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.black),
              onPressed: () {
                _searchController.clear();
              },
            ),
          IconButton(
            icon: Icon(_isSearching ? Icons.arrow_back_ios_new_rounded : Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  // Clear search when closing
                  _searchResult.clear();
                  _searchController.clear();
                }
              });
            },
          ),


          // Nút chuyển chế độ sáng/tối
          if (!_isSearching)

          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: _showOptionsBottomSheet,
            ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.file(
            widget.file,
            controller: _pdfController,
            enableDoubleTapZooming: true,
            pageLayoutMode: PdfPageLayoutMode.continuous,
            canShowScrollHead: true,
            canShowScrollStatus: true,
          ),
          // Add search result navigation UI
          if (_isSearching && _searchResult.hasResult)
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
                      Text(
                        '${_searchResult.currentInstanceIndex}/${_searchResult.totalInstanceCount}',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 15),
                      IconButton(
                        icon: Icon(Icons.arrow_upward),
                        onPressed: _searchResult.currentInstanceIndex == 1
                            ? null
                            : () {
                          _searchResult.previousInstance();
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: _searchResult.currentInstanceIndex == _searchResult.totalInstanceCount
                            ? null
                            : () {
                          _searchResult.nextInstance();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      )

    );
  }
}