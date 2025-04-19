import 'package:flutter/material.dart';
import 'package:project_flutter/screens/Book_Online/witgets/book_card.dart';
import 'package:project_flutter/screens/Book_Online/witgets/category_tab.dart';

class BookStoreHomePage extends StatelessWidget {
  const BookStoreHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            const SizedBox(height: 10),
            _buildCategoryTabs(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeaturedBook(),
                    const SizedBox(height: 24),
                    _buildLatestBooksHeader(),
                    const SizedBox(height: 16),
                    _buildBooksList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.apps),
            onPressed: () {},
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text("Xin chào", style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _buildFeaturedBook() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 280,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1D2339),
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://via.placeholder.com/400x280/121933/121933'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 180,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/120x180/4080FF/FFFFFF'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Trở lại thời điểm yêu anh',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Đã có trên 400K lượt đọc',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestBooksHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Mới nhất',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _buildBooksList() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          BookCard(
            title: 'ĐẬP NỐI BÀN SÁT ĐI HỌC',
            color: Colors.pink,
            isNew: true,
          ),
          SizedBox(width: 16),
          BookCard(
            title: 'SỰ SỐNG',
            color: Colors.blue,
            isHot: true,
          ),
          SizedBox(width: 16),
          BookCard(
            title: 'TRỞ LẠI THỜI ĐIỂM YÊU ANH',
            color: Colors.purple,
            isPopular: true,
          ),
        ],
      ),
    );
  }
}