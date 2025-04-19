import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Map<String, dynamic>> books = [
    {
      'title': 'How to Live on 24 Hours a Day',
      'author': 'By Arnold Bennett',
      'coverUrl': 'assets/book1.jpg',
      'rating': 4.9,
      'views': '132434',
      'likes': '826',
      'isReading': true,
      'coverColors': [Colors.cyan, Colors.purple, Colors.pink],
    },
    {
      'title': 'Beauty and the Beast',
      'author': 'By Anonymous',
      'coverUrl': 'assets/book2.jpg',
      'rating': 4.8,
      'views': '123224',
      'likes': '826',
      'isReading': false,
    },
    {
      'title': 'The Science of Getting Rich',
      'author': '',
      'coverUrl': 'assets/book3.jpg',
      'rating': 4.7,
      'views': '',
      'likes': '',
      'isReading': false,
      'isSmallCover': true,
    },
    {
      'title': 'Quatro Novelas',
      'author': '',
      'coverUrl': 'assets/book4.jpg',
      'rating': 0,
      'views': '',
      'likes': '',
      'isReading': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return _buildBookItem(books[index]);
          },
        ),
      ),
    );
  }
}

Widget _buildBookItem(Map<String, dynamic> book) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: book['coverColors'] != null
                  ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: book['coverColors'],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'HOW\nTO\nLIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  book['coverUrl'],
                  fit: book['isSmallCover'] == true ? BoxFit.contain : BoxFit.cover,
                ),
              ),
            ),
            if (book['isReading'] == true)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Đang đọc',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (book['rating'] > 0)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        book['rating'].toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 8),
      Text(
        book['title'],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      if (book['author'].isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            book['author'],
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
    ],
  );
}
