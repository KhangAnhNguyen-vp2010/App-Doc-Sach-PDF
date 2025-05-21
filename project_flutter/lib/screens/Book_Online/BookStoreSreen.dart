import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import '../../models/models.dart';
import 'BookDetailScreen.dart';

class BookStoreHomePage extends StatefulWidget {
  const BookStoreHomePage({super.key});

  @override
  State<BookStoreHomePage> createState() => _BookStoreHomePageState();
}

class _BookStoreHomePageState extends State<BookStoreHomePage> with AutomaticKeepAliveClientMixin {
  late Realm realm;
  late List<Book> books;
  List<Book> displayedBooks = [];
  List<Category> categories = [];

  String searchQuery = '';
  String selectedCategory = 'Tất cả';
  String selectedSort = 'Mới nhất';

  final sortOptions = ['Mới nhất', 'A-Z', 'Lượt xem', 'Lượt thích'];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    final config = Configuration.local([Book.schema, Category.schema]);
    realm = Realm(config);

    books = realm.all<Book>().toList();

    categories = [Category('all', 'Tất cả')] + realm.all<Category>().toList();

    _filterAndSortBooks();
  }

  void _filterAndSortBooks() {
    setState(() {
      displayedBooks = books.where((book) {
        final matchSearch = book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(searchQuery.toLowerCase());

        final matchCategory = selectedCategory == 'Tất cả' ||
            book.category?.name == selectedCategory;

        return matchSearch && matchCategory;
      }).toList();

      switch (selectedSort) {
        case 'A-Z':
          displayedBooks.sort((a, b) => a.title.compareTo(b.title));
          break;
        case 'Lượt xem':
          displayedBooks.sort((a, b) => b.viewCount.compareTo(a.viewCount));
          break;
        case 'Lượt thích':
          displayedBooks.sort((a, b) => b.likeCount.compareTo(a.likeCount));
          break;
        case 'Mới nhất':
        default:
          displayedBooks.sort((a, b) => b.publicationYear.compareTo(a.publicationYear));
      }
    });
  }


  @override
  void dispose() {
    realm.close();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildSearchAndFilterBar(),
            const SizedBox(height: 12),
            Expanded(child: _buildBooksGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Column(
      children: [
        // Tìm kiếm
        TextField(
          decoration: InputDecoration(
            hintText: 'Tìm sách theo tên hoặc tác giả',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onChanged: (value) {
            searchQuery = value;
            _filterAndSortBooks();
          },
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            // Dropdown thể loại
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(
                  value: c.name,
                  child: Text(c.name),
                ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Thể loại',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                    _filterAndSortBooks();
                  }
                },
              ),
            ),
            const SizedBox(width: 10),

            // Dropdown sắp xếp
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedSort,
                items: sortOptions
                    .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s),
                ))
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Sắp xếp theo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) {
                  if (value != null) {
                    selectedSort = value;
                    _filterAndSortBooks();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBooksGrid() {
    if (displayedBooks.isEmpty) {
      return const Center(child: Text('Không tìm thấy sách nào.'));
    }

    return GridView.builder(
      itemCount: displayedBooks.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        final book = displayedBooks[index];
        return _buildBookCard(book);
      },
    );
  }

  Widget _buildBookCard(Book book) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Chuyển đến màn chi tiết nếu cần
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailScreen(book: book),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh bìa
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                book.coverUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 160,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(book.author,
                      style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${book.viewCount}', style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 10),
                      const Icon(Icons.favorite, size: 14, color: Colors.redAccent),
                      const SizedBox(width: 4),
                      Text('${book.likeCount}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
