import 'package:realm/realm.dart';
import '../models/models.dart';

class RealmService {
  static final RealmService _instance = RealmService._internal();
  late Realm _realm;

  factory RealmService() {
    return _instance;
  }

  RealmService._internal() {
    final config = Configuration.local([Book.schema, Category.schema]);
    _realm = Realm(config);
  }

  Realm get realm => _realm;


  // ====== CRUD cho Category ======
  void addCategory(Category category) {
    _realm.write(() {
      _realm.add(category);
    });
  }

  List<Category> getAllCategories() {
    return _realm.all<Category>().toList();
  }

  void deleteCategory(Category category) {
    _realm.write(() {
      _realm.delete(category);
    });
  }

  void updateCategory(Category category, String newName) {
    _realm.write(() {
      category.name = newName;
    });
  }

  // ====== CRUD cho Book ======
  void addBook(Book book) {
    _realm.write(() {
      _realm.add(book);
    });
  }

  List<Book> getAllBooks() {
    return _realm.all<Book>().toList();
  }

  void deleteBook(Book book) {
    _realm.write(() {
      _realm.delete(book);
    });
  }

  void updateBook(Book book, {String? title, int? viewCount}) {
    _realm.write(() {
      if (title != null) book.title = title;
      if (viewCount != null) book.viewCount = viewCount;
    });
  }
}
