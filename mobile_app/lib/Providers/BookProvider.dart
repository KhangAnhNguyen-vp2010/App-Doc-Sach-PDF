// providers/book_provider.dart
import 'package:flutter/material.dart';
import '../../models/api_book.dart';
import '../../services/BookServices/fetch.dart';
import '../../services/BookServices/updateLikeCount.dart';
import '../../services/BookServices/updateViewCount.dart';

class BookProvider extends ChangeNotifier {
  ApiBook? _book;
  bool _isLoading = false;

  ApiBook? get book => _book;
  bool get isLoading => _isLoading;

  /// Khởi tạo book bằng ID
  Future<void> init(String bookId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _book = await fetchBookById(bookId);
    } catch (e) {
      print('Error fetching book: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Cập nhật toàn bộ object book từ nơi khác (nếu đã có)
  void setBook(ApiBook book) {
    _book = book;
    notifyListeners();
  }

  /// Tăng lượt xem và làm mới dữ liệu
  Future<void> incrementViewCountAndRefresh() async {
    if (_book == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await incrementViewCount(_book!.id);
      _book = await fetchBookById(_book!.id);
    } catch (e) {
      print('Error incrementing view count: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Tăng lượt thích và làm mới dữ liệu
  Future<void> incrementLikeCountAndRefresh() async {
    if (_book == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await incrementLikeCount(_book!.id);
      _book = await fetchBookById(_book!.id);
    } catch (e) {
      print('Error incrementing like count: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearBook() {
    _book = null;
    notifyListeners();
  }
}
