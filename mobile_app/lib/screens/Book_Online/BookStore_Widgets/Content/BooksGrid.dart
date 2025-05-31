import 'package:flutter/cupertino.dart';
import '../../../../models/models.dart';
import '../Book Item/BookCard.dart';

class BooksGrid extends StatelessWidget {
  final List<Book> books;
  final Function(Book) onBookTap;

  const BooksGrid({
    super.key,
    required this.books,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: books.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return BookCard(
          book: books[index],
          index: index,
          onTap: () => onBookTap(books[index]),
        );
      },
    );
  }
}