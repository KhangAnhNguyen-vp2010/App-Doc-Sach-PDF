import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_flutter/screens/BooksScreen.dart';
import 'package:project_flutter/screens/HomeScreen.dart';
import 'package:project_flutter/screens/Navigation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!mounted) return; // Tránh lỗi nếu màn hình bị hủy trước khi hoàn tất
      setState(() {
        progress += 0.05;
      });

      if (progress >= 1) {
        timer.cancel();
        Future.delayed(Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NavApp()),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Image.asset("assets/pdf_icon.png", width: 150), // Logo PDF
          SizedBox(height: 20),
          Text(
            "All Trusted - PDF Reader",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          SizedBox(height: 10),
          Text(
            "Đọc, chú thích và quản lý PDF dễ dàng!",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.red.shade100,
                  color: Colors.red,
                ),
                SizedBox(height: 10),
                Text(
                  "${(progress * 100).toInt()}%", // Hiển thị phần trăm
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
