// widgets/search_controls.dart
import 'package:flutter/material.dart';

class SearchControls extends StatelessWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const SearchControls({
    super.key,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildControlButton(
                icon: Icons.keyboard_arrow_up_rounded,
                onPressed: onPrevious,
                tooltip: 'Kết quả trước',
              ),
              Container(
                width: 1,
                height: 24,
                color: Colors.grey[600],
              ),
              _buildControlButton(
                icon: Icons.keyboard_arrow_down_rounded,
                onPressed: onNext,
                tooltip: 'Kết quả tiếp theo',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}