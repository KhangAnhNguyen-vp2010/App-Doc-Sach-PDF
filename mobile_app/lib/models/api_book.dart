import 'api_category.dart';

class ApiBook {
  final String id;
  final String title;
  final String author;
  final String description;
  final String coverUrl;
  final String pdfUrl;
  final DateTime uploadDate;
  final int pageCount;
  final int publicationYear;
  final int viewCount;
  final int likeCount;
  final ApiCategory? category;

  ApiBook({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.coverUrl,
    required this.pdfUrl,
    required this.uploadDate,
    required this.pageCount,
    required this.publicationYear,
    required this.viewCount,
    required this.likeCount,
    this.category,
  });

  factory ApiBook.fromJson(Map<String, dynamic> json) {
    return ApiBook(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      description: json['description'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
      uploadDate: json['uploadDate'] != null
          ? DateTime.parse(json['uploadDate'])
          : DateTime.now(),
      pageCount: json['pageCount'] ?? 0,
      publicationYear: json['publicationYear'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      category: json['category'] != null
          ? ApiCategory.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'publicationYear': publicationYear,
    'viewCount': viewCount,
    'likeCount': likeCount,
    'category': category?.toJson(),
  };
}
