import 'package:flutter/material.dart';

class SortDropdown extends StatelessWidget {
  final String selectedSort;
  final Map<String, String> sortOptions;
  final Function(String) onChanged;

  const SortDropdown({
    super.key,
    required this.selectedSort,
    required this.sortOptions,
    required this.onChanged,
  });

  String getSuffix(String key) {
    switch (key) {
      case "Mới nhất":
        return " 🆕";
      case "A-Z":
        return " 🚀";
      case "Lượt xem":
        return " 👁️";
      default:
        return " 👍";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.sort, color: Colors.white, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              borderRadius: BorderRadius.circular(12),
              value: selectedSort,
              dropdownColor: Colors.blueAccent,
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              items: sortOptions.entries.map((entry) {
                String key = entry.key;
                String label = entry.value;
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(label + getSuffix(key)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) onChanged(value);
              },
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }
}
