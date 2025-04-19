import 'dart:io';
import 'dart:math';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import '../services/PdfSearchDelegate.dart';
import 'PdfViewerPage.dart';


class PdfListScreen extends StatefulWidget {
  @override
  _PdfListScreenState createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Giữ trạng thái màn hình khi chuyển tab
  String _selectedSortOption = 'name_asc'; // Mặc định sắp xếp theo tên (A-Z)


  List<File> _pdfFiles = [];
  int _filesToShow = 10;
  bool _isLoading = true;
  bool _isLoadingMore = false;

  bool _isMarked = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    Hive.openBox('markedPages');
    Hive.openBox('favoriteBooks');
    setState(() {

    });
    _loadFilesWithDelay();
  }

  //////////////////////////////////////////////BOOKMARKS
  void _checkMarkedPage(File file) {
    String fileName = path.basename(file.path);
    getMarkedPage(fileName).then((data) {
      var markedPage = data['page'];
      var _note = data['note'];
      if (markedPage != null) {
        setState(() {
          _isMarked = true; // Đánh dấu trang đã lưu
        });
      }

      if (_note != null) {
        // Handle the note if it exists
        print('Note: $_note');
        // You can display the note in your UI if needed
      }
    });
  }

  // Hàm xử lý đánh dấu hoặc bỏ lưu trang
  void _toggleMarkedPage(File file) {
    String fileName = path.basename(file.path);
    if (_isMarked) {
      removeMarkedPage(fileName);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Đã bỏ đánh dấu'), duration: Duration(seconds: 2), backgroundColor: Colors.blueAccent,));
      setState(() {
        _isMarked = false;
      });
    } else {
      saveMarkedPage(fileName, 1, "Note tạm");
      setState(() {
        _isMarked = true;
      });
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
  //////////////////////////////////////////////


  /// Chức năng yêu thích
  Future<void> _toggleFavorite(File file) async {
    String fileName = path.basename(file.path);

    if (_isFavorite) {
      removeFavorite(fileName); // Nếu đã yêu thích, xóa khỏi danh sách
      setState(() {
        _isFavorite = false;
      });
    } else {
      saveFavorite(fileName); // Nếu chưa yêu thích, thêm vào danh sách
      setState(() {
        _isFavorite = true;
      });
    }
  }

  Future<void> _checkFavoriteStatus(File file) async {
    String fileName = path.basename(file.path);
    getFavorite(fileName).then((data) {
      setState(() {
        _isFavorite = data;
      });
    });
  }

  Future<void> saveFavorite(String fileName) async {
    var box = await Hive.openBox('favoriteBooks');
    box.put(fileName, true);
  }

  Future<bool> getFavorite(String fileName) async {
    var box = await Hive.openBox('favoriteBooks');
    return box.get(fileName);
  }

  Future<void> removeFavorite(String fileName) async {
    var box = await Hive.openBox('favoriteBooks');
    await box.delete(fileName); // Xóa dữ liệu đã lưu
    print("Đã bỏ thích file $fileName");
  }
  //////////////////////////////////////////////


  ////////////////////////////////////////////// LOAD FILE
  Future<void> _loadFilesWithDelay() async {
    await _requestPermissionAndLoadFiles();
    await Future.delayed(Duration(milliseconds: 1500)); // Giữ vòng tròn loading 3-5 giây
  }

  Future<void> _requestPermissionAndLoadFiles() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted) {
      _pdfFiles = await _loadPdfFiles();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("Cung cấp quyền truy cập"),
            content: Text("Ứng dụng cần quyền truy cập bộ nhớ để tải tệp PDF. Vui lòng cấp quyền trong cài đặt."),
            actions: [
              TextButton(
                child: Text("Hủy"),
                onPressed: () => Navigator.pop(ctx),
              ),
              TextButton(
                child: Text("Cài đặt"),
                onPressed: () async{
                  Navigator.pop(ctx);
                  openManageAllFilesAccessSettings();
                  _loadFilesWithDelay();
                },
              ),
            ],
          );
        },
      );
    }
    setState(() => _isLoading = false);
  }

  void openManageAllFilesAccessSettings() async {
    final intent = AndroidIntent(
      action: "android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION",
      data: "package:com.example.project_flutter", // Thay bằng package của bạn
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await intent.launch();
  }

  Future<List<File>> _loadPdfFiles() async {
    Directory downloadDir = Directory('/storage/emulated/0/Download');
    if (await downloadDir.exists()) {
      List<FileSystemEntity> files = downloadDir.listSync();
      List<File> filteredFiles = [];
      filteredFiles = files
          .where((file) => file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();
      // Sắp xếp các tệp PDF theo tên (A-Z)
      _sortFiles(filteredFiles);
      return filteredFiles;
    }
    return [];
  }

  void _loadMoreFiles() {
    if (_isLoadingMore || _filesToShow >= _pdfFiles.length) return;
    setState(() => _isLoadingMore = true);

    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        _filesToShow += 20;
        if (_filesToShow > _pdfFiles.length) _filesToShow = _pdfFiles.length;
        _isLoadingMore = false;
      });
    });
  }

  void _openPdfFile(File file) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PdfViewerPage(file: file)));
  }

  void _renameFile(BuildContext context, File file) {
    TextEditingController _controller = TextEditingController(text: path.basenameWithoutExtension(file.path));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.black87,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 30),
                  SizedBox(width: 10),
                  Text(
                    "Rename",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _controller,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF2A2A2A),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => _controller.clear(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text("CANCEL", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String newName = _controller.text.trim();
                        if (newName.isNotEmpty && newName != path.basenameWithoutExtension(file.path)) {
                          String newPath = path.join(file.parent.path, "$newName.pdf");

                          if (await File(newPath).exists()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Tên file đã tồn tại!")),
                            );
                          } else {
                            await file.rename(newPath);
                            setState(() {
                              _pdfFiles[_pdfFiles.indexOf(file)] = File(newPath);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Đổi tên thành công!")),
                            );
                          }
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, File file) {
    _isMarked = false;
    _isFavorite = false;
    _checkMarkedPage(file);
    _checkFavoriteStatus(file);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
                title: Text(
                  path.basename(file.path),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  file.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: Hive.box('markedPages').listenable(),
                      builder: (context, box, widget) {
                        return IconButton(
                          icon: _isMarked ? Icon(Icons.bookmark, color: Colors.amber) : Icon(Icons.bookmark_border, color: Colors.grey),
                          onPressed: () {
                            _toggleMarkedPage(file);
                          },
                        );
                      },
                    ),

                    // Nút Favorite
                    ValueListenableBuilder(
                      valueListenable: Hive.box('favoriteBooks').listenable(),
                      builder: (context, box, widget) {
                        return IconButton(
                          icon: _isFavorite ? Icon(Icons.favorite, color: Colors.redAccent) : Icon(Icons.favorite_border, color: Colors.grey,),
                          onPressed: () {
                            _toggleFavorite(file);
                          },
                        );
                      },
                    ),

                  ],
                ),
              ),

              Divider(),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Đổi tên'),
                onTap: () {
                  Navigator.pop(context);
                  _renameFile(context, file);
                },
              ),
              ListTile(
                leading: Icon(Icons.open_in_new),
                title: Text('Mở file'),
                onTap: () {
                  Navigator.pop(context);
                  _openPdfFile(file);
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Chia sẻ'),
                onTap: () async {
                  Navigator.pop(context);
                  await Share.shareXFiles([XFile(file.path)], text: "Xem tài liệu này");
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Xóa'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteFile(file);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteFile(File file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xóa File"),
        content: Text("Bạn có chắc muốn xóa '${path.basename(file.path)}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Hủy")),
          TextButton(
            onPressed: () {
              file.deleteSync();
              setState(() => _pdfFiles.remove(file));
              Navigator.pop(context);
            },
            child: Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Color(0xFF2D3142),
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PdfSearchDelegate(_pdfFiles),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Color(0xFF2D3142)),
            onSelected: (String value) {
              setState(() {
                _selectedSortOption = value;
                _sortFiles(); // Gọi lại hàm sắp xếp sau khi thay đổi giá trị
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'name_asc',
                child: Row(
                  children: [
                    if (_selectedSortOption == 'name_asc')
                      Row(
                        children: [
                          Text('Tên File (A-Z)', style: TextStyle(color: Colors.red)),
                          SizedBox(width: 8),
                          Icon(Icons.sort_by_alpha, color: Colors.red), // Biểu tượng check màu xanh
                        ],
                      ),
                    if (_selectedSortOption != 'name_asc')
                      Row(
                        children: [
                          Text('Tên File (A-Z)'),
                          SizedBox(width: 8),
                          Icon(Icons.sort_by_alpha_outlined, color: Colors.black26), // Biểu tượng check màu xanh
                        ],
                      ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'size',
                child: Row(
                  children: [
                    if (_selectedSortOption == 'size')
                      Row(
                        children: [
                          Text('Kích thước', style: TextStyle(color: Colors.red)),
                          SizedBox(width: 8),
                          Icon(Icons.insert_drive_file_outlined, color: Colors.red), // Biểu tượng check màu xanh
                        ],
                      ),
                    if (_selectedSortOption != 'size')
                      Row(
                        children: [
                          Text('Kích thước'),
                          SizedBox(width: 8),
                          Icon(Icons.insert_drive_file_outlined, color: Colors.black26), // Biểu tượng check màu xanh
                        ],
                      ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'date',
                child: Row(
                  children: [
                    if (_selectedSortOption == 'date')
                      Row(
                        children: [
                          Text("Thời gian", style: TextStyle(color: Colors.red)),
                          SizedBox(width: 8),
                          Icon(Icons.timer_sharp, color: Colors.red), // Biểu tượng check màu xanh
                        ],
                      ),
                    if (_selectedSortOption != 'date')
                      Row(
                        children: [
                          Text('Thời gian'),
                          SizedBox(width: 8),
                          Icon(Icons.timer_sharp, color: Colors.black26), // Biểu tượng check màu xanh
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Chờ chút xíu...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
            ],
          )) // Hiện loading 3-5 giây trước khi load dữ liệu
          : _pdfFiles.isEmpty
          ? Center(child: Text("Không tìm thấy file PDF"))
          : NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoadingMore && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMoreFiles();
          }
          return false;
        },
        child: ListView.builder(
          itemCount: (_filesToShow < _pdfFiles.length) ? _filesToShow + 1 : _filesToShow,
          itemBuilder: (context, index) {
            if (index == _filesToShow) {
              return Center(child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(),
              ));
            }

            File file = _pdfFiles[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(Icons.picture_as_pdf, color: Colors.red, size: 28),
              title: Text(path.basename(file.path).replaceAll('.pdf', ''),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('${_getFileSize(file)} · ${_getFormattedDate(file)}'),
              onTap: () => _openPdfFile(file),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () => _showOptionsMenu(context, file),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getFileSize(File file) {
    int bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  String _getFormattedDate(File file) {
    DateTime lastModified = file.lastModifiedSync();
    return 'thg ${lastModified.month} ${lastModified.day}, ${lastModified.year}';
  }

  // Sửa hàm _sortFiles để nhận tham số danh sách file (dùng cho _loadPdfFiles)
  void _sortFiles([List<File>? filesToSort]) {
    final files = filesToSort ?? _pdfFiles;

    if (_selectedSortOption == 'name_asc') {
      files.sort((a, b) => path.basename(a.path).compareTo(path.basename(b.path)));
    } else if (_selectedSortOption == 'size') {
      files.sort((a, b) => a.lengthSync().compareTo(b.lengthSync()));
    } else if (_selectedSortOption == 'date') {
      files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
    }
  }

}


