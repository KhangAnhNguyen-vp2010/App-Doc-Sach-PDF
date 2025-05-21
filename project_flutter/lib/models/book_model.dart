part of 'models.dart';

@RealmModel()
class _Book {
  @PrimaryKey()
  late String id;

  late String title;
  late String author;
  late String description;

  late _Category? category; // liên kết đến _Category

  late String coverUrl;
  late String pdfUrl;
  late DateTime uploadDate;
  late int pageCount;
  late int publicationYear;
  late int viewCount;
  late int likeCount;
}
