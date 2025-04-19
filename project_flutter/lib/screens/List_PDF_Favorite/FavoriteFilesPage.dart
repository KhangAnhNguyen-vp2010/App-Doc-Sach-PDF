import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoriteFilesPage extends StatefulWidget {
  @override
  _FavoriteFilesPageState createState() => _FavoriteFilesPageState();
}

class _FavoriteFilesPageState extends State<FavoriteFilesPage> {
  List<String> favoriteFiles = [];

  Future<List<String>> _getFavoriteFiles() async {
    var box = await Hive.openBox('favoriteBooks');
    return box.keys.cast<String>().toList(); // Lấy danh sách tất cả các file yêu thích
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriteFiles();
  }

  Future<void> _loadFavoriteFiles() async {
    List<String> files = await _getFavoriteFiles();
    setState(() {
      favoriteFiles = files; // Cập nhật UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách yêu thích")),
      body: favoriteFiles.isEmpty
          ? Center(child: Text("Không có tệp nào được yêu thích"))
          : ListView.builder(
        itemCount: favoriteFiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteFiles[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                var box = await Hive.openBox('favoriteBooks');
                await box.delete(favoriteFiles[index]);
                _loadFavoriteFiles(); // Cập nhật lại danh sách
              },
            ),
          );
        },
      ),
    );
  }
}
