// // Widget hiển thị thống kê (lượt xem, lượt thích)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/models.dart';
import 'StatItem.dart';

class BookStatsSection extends StatefulWidget {
  final Book book;

  const BookStatsSection({super.key, required this.book});

  @override
  _BookStatsSectionState createState() => _BookStatsSectionState();
}

class _BookStatsSectionState extends State<BookStatsSection> {
  late Book _book;
  late Realm _realm;
  late StreamSubscription<RealmObjectChanges<Book>> _subscription;

  @override
  void initState() {
    super.initState();
    _realm = Realm(Configuration.local([Book.schema, Category.schema]));

    // Lấy lại book từ Realm (để nhận object Realm chính xác)
    _book = _realm.find<Book>(widget.book.id)!;

    // Lắng nghe thay đổi của _book
    _subscription = _book.changes.listen((changes) {
      // Khi có thay đổi, gọi setState để rebuild UI
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    _realm.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: StatItem(
              icon: Icons.visibility_outlined,
              label: S.of(context).view,
              value: _formatNumber(_book.viewCount),
              color: Colors.blue,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
          ),
          Expanded(
            child: StatItem(
              icon: Icons.favorite_outline,
              label: S.of(context).likes,
              value: _formatNumber(_book.likeCount),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
