import 'package:flutter/material.dart';

class PopupPromotion extends StatelessWidget {
  const PopupPromotion({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              image: const DecorationImage(
                image: AssetImage('assets/PopUpEvent.png'), // <-- Hình bạn vừa tạo
                fit: BoxFit.cover,
              ),
            ),
            height: 500,
            width: double.infinity,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
