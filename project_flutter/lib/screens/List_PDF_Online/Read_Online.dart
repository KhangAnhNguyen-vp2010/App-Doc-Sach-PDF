import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PDFScreen extends StatefulWidget {
  const PDFScreen({Key? key}) : super(key: key);

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final pdfUrl = 'https://raw.githubusercontent.com/KhangAnhNguyen-vp2010/pdf-hosting/main/Quang-ganh-lo-di-va-vui-song.pdf';
    final viewerUrl = 'https://docs.google.com/gview?embedded=true&url=$pdfUrl';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(viewerUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xem PDF Online")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
