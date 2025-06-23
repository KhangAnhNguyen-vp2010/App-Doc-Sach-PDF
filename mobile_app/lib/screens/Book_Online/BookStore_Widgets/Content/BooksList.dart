import 'package:flutter/cupertino.dart';
import 'package:mobile_app/models/api_book.dart';
import '../Book Item/BookListItem.dart';

class BooksList extends StatelessWidget {
  // final List<Book> books;
  final List<ApiBook> books;
  // final Function(Book) onBookTap;
  final Function(ApiBook) onBookTap;

  const BooksList({
    super.key,
    required this.books,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookListItem(
          book: books[index],
          index: index,
          onTap: () => onBookTap(books[index]),
        );
      },
    );
  }
}