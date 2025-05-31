import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi'); // mặc định tiếng Việt
  late final Box _settingsBox;

  Locale get locale => _locale;

  // Khởi tạo async để mở box Hive nếu chưa mở
  Future<void> init() async {
    if (!Hive.isBoxOpen('settings')) {
      await Hive.openBox('settings');
    }
    _settingsBox = Hive.box('settings');

    final String? langCode = _settingsBox.get('languageCode', defaultValue: 'vi');
    _locale = Locale(langCode!);
    notifyListeners();  // thông báo UI cập nhật sau khi load
  }

  void changeLanguage(String languageCode) {
    _locale = Locale(languageCode);
    _settingsBox.put('languageCode', languageCode);
    notifyListeners();
  }
}
