import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MarkedPagesScreen extends StatelessWidget {
  const MarkedPagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final markedBox = Hive.box('markedPages');

    if (markedBox.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Trang đã đánh dấu")),
        body: Center(child: Text("🙃 Chưa có trang nào được đánh dấu")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("📑 Các trang đã đánh dấu")),
      body: ListView.builder(
        itemCount: markedBox.length,
        itemBuilder: (context, index) {
          final fileName = markedBox.keyAt(index) as String;
          final data = markedBox.get(fileName) as dynamic;
          final int page = data['page'];
          final String note = data['note'];
          return ListTile(
            leading: Icon(Icons.bookmark, color: Colors.amber),
            title: Text('$fileName - Trang $page'),
            subtitle: Text('📝 $note'),
            onTap: () {
              // TODO: mở lại file và nhảy đến trang đã đánh dấu
              // bạn có thể truyền fileName để tìm lại file gốc nếu cần
            },
          );
        },
      ),
    );
  }
}
