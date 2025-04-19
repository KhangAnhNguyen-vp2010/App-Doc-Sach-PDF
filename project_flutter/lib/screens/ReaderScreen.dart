import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter/models/document_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class ReaderScreen extends StatefulWidget {
  ReaderScreen(this.doc, {Key? key}) : super(key: key);
  Document doc;
  @override
  State<ReaderScreen> createState() => _ReaderscreenState();
}

class _ReaderscreenState extends State<ReaderScreen> {

  @override
  Widget build(BuildContext context) {
    print(widget.doc.doc_url);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.doc.doc_title!),
      ),
      body: Container(
        child: widget.doc.doc_url != null
            ? SfPdfViewer.network(widget.doc.doc_url!)
            : Center(child: Text("Không có URL hợp lệ")),
      ),
    );
  }
}


// class ReaderScreen extends StatelessWidget {
//   final Document doc;
//   ReaderScreen(this.doc, {Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple,
//         title: Text(doc.doc_title ?? "No Title"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             final Uri url = Uri.parse(doc.doc_url!);
//             if (await canLaunchUrl(url)) {
//               await launchUrl(url);
//             } else {
//               print("Không mở được URL");
//             }
//           },
//           child: Text("Mở PDF"),
//         ),
//       ),
//     );
//   }
// }

