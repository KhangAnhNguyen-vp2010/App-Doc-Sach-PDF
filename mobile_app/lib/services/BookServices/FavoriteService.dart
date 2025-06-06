import 'package:hive/hive.dart';

class FavoriteService {
  static Future<bool> isFavorite(String fileName) async {
    final box = await Hive.openBox('favoriteBooks');
    return box.containsKey(fileName);
  }

  static Future<void> addFavorite(String fileName, String url) async {
    final box = await Hive.openBox('favoriteBooks');
    await box.put(fileName, {
      "bool": true,
      "link": url,
    });
  }

  static Future<void> removeFavorite(String fileName) async {
    final box = await Hive.openBox('favoriteBooks');
    await box.delete(fileName);
  }
}