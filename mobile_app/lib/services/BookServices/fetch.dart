import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/api_book.dart';

Future<ApiBook> fetchBookById(String id) async {
  final response = await http.get(Uri.parse("http://192.168.2.15:5140/api/Sach/$id"));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return ApiBook.fromJson(jsonData);
  } else {
    throw Exception('Failed to load book');
  }
}

