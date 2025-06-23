import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_app/services/api/api_urls.dart';
import '../../generated/l10n.dart';
import '../../models/api_book.dart';
import '../../models/api_category.dart';
import 'BookDetailScreen.dart';
import 'BookStore_Widgets/Content/BookStoreContent.dart';
import 'BookStore_Widgets/Filter/BookStoreFilters.dart';
import 'BookStore_Widgets/Header/BookStoreHeader.dart';
import 'BookStore_Widgets/NetworkChecker.dart';

class BookStoreHomePage extends StatefulWidget {
  const BookStoreHomePage({super.key});

  @override
  State<BookStoreHomePage> createState() => _BookStoreHomePageState();
}

class _BookStoreHomePageState extends State<BookStoreHomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  List<ApiBook> books = [];
  List<ApiCategory> categories = [];
  List<ApiBook> displayedBooks = [];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String searchQuery = '';
  String selectedCategory = 'All';
  String selectedSort = "Mới nhất";
  bool isGridView = true;

  final TextEditingController _searchController = TextEditingController();
  late Map<String, String> sortOptions;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sortOptions = {
      'Mới nhất': S.of(context).latest,
      'A-Z': S.of(context).name,
      'Lượt xem': S.of(context).view,
      'Lượt thích': S.of(context).likes,
    };
  }

  @override
  void initState() {
    super.initState();
    Hive.openBox('markedPages');
    Hive.openBox('favoriteBooks');
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final bookRes = await http.get(Uri.parse('$baseUrl/Sach'));
      final catRes = await http.get(Uri.parse('$baseUrl/Theloai'));

      if (bookRes.statusCode == 200 && catRes.statusCode == 200) {
        final bookData = json.decode(bookRes.body) as List;
        final catData = json.decode(catRes.body) as List;

        setState(() {
          books = bookData.map((e) => ApiBook.fromJson(e)).toList();
          categories = [ApiCategory(id: 'all', name: 'All')] +
              catData.map((e) => ApiCategory.fromJson(e)).toList();
          _filterAndSortBooks();
          _animationController.forward();
        });
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void _filterAndSortBooks() {
    setState(() {
      displayedBooks = books.where((book) {
        final matchSearch = book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(searchQuery.toLowerCase());

        final matchCategory = selectedCategory == 'All' ||
            book.category?.name == selectedCategory;

        return matchSearch && matchCategory;
      }).toList();

      switch (selectedSort) {
        case 'A-Z' :
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

  void _navigateToDetail(ApiBook book) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BookDetailScreen(book: book),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    // realm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NetworkChecker(
      onFetchData: _fetchData,
      child: Scaffold(
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                BookStoreHeader(
                  booksCount: displayedBooks.length,
                  isGridView: isGridView,
                  onViewToggle: (isGrid) => setState(() => isGridView = isGrid),
                  searchController: _searchController,
                  searchQuery: searchQuery,
                  onSearchChanged: (value) {
                    setState(() => searchQuery = value);
                    _filterAndSortBooks();
                  },
                ),
                BookStoreFilters(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  selectedSort: selectedSort,
                  sortOptions: sortOptions,
                  onCategoryChanged: (category) {
                    setState(() => selectedCategory = category);
                    _filterAndSortBooks();
                  },
                  onSortChanged: (sort) {
                    setState(() => selectedSort = sort);
                    _filterAndSortBooks();
                  },
                ),
                Expanded(
                  child: BookStoreContent(
                    books: displayedBooks,
                    isGridView: isGridView,
                    onBookTap: _navigateToDetail,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}