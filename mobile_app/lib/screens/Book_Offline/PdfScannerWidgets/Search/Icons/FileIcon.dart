// Widget cho icon PDF
import 'package:flutter/material.dart';

class PdfFileIcon extends StatelessWidget {
  const PdfFileIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.picture_as_pdf,
        color: Colors.red,
        size: 24,
      ),
    );
  }
}