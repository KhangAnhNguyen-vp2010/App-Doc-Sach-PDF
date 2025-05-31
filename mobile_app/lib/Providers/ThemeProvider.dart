import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light; // Mặc định là chế độ sáng
  late final Box _settingsBox;

  ThemeMode get themeMode => _themeMode;

  // Khởi tạo Hive và đọc giá trị theme đã lưu
  Future<void> init() async {
    if (!Hive.isBoxOpen('settings')) {
      await Hive.openBox('settings');
    }
    _settingsBox = Hive.box('settings');

    final String themeString = _settingsBox.get('themeMode', defaultValue: 'light');
    _themeMode = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Thay đổi theme và lưu lại vào Hive
  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _settingsBox.put('themeMode', isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }

  // Hàm phụ để biết đang ở dark mode không (hữu ích cho UI toggle switch)
  bool get isDarkMode => _themeMode == ThemeMode.dark;
}
