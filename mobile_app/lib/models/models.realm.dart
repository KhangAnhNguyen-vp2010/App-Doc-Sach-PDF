// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class Category extends _Category
    with RealmEntity, RealmObjectBase, RealmObject {
  Category(String id, String name) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
  }

  Category._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  Stream<RealmObjectChanges<Category>> get changes =>
      RealmObjectBase.getChanges<Category>(this);

  @override
  Stream<RealmObjectChanges<Category>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Category>(this, keyPaths);

  @override
  Category freeze() => RealmObjectBase.freezeObject<Category>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{'id': id.toEJson(), 'name': name.toEJson()};
  }

  static EJsonValue _toEJson(Category value) => value.toEJson();
  static Category _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'name': EJsonValue name} => Category(
        fromEJson(id),
        fromEJson(name),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Category._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Category, 'Category', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Book extends _Book with RealmEntity, RealmObjectBase, RealmObject {
  Book(
    String id,
    String title,
    String author,
    String description,
    String coverUrl,
    String pdfUrl,
    DateTime uploadDate,
    int pageCount,
    int publicationYear,
    int viewCount,
    int likeCount, {
    Category? category,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'author', author);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'coverUrl', coverUrl);
    RealmObjectBase.set(this, 'pdfUrl', pdfUrl);
    RealmObjectBase.set(this, 'uploadDate', uploadDate);
    RealmObjectBase.set(this, 'pageCount', pageCount);
    RealmObjectBase.set(this, 'publicationYear', publicationYear);
    RealmObjectBase.set(this, 'viewCount', viewCount);
    RealmObjectBase.set(this, 'likeCount', likeCount);
  }

  Book._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get author => RealmObjectBase.get<String>(this, 'author') as String;
  @override
  set author(String value) => RealmObjectBase.set(this, 'author', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  Category? get category =>
      RealmObjectBase.get<Category>(this, 'category') as Category?;
  @override
  set category(covariant Category? value) =>
      RealmObjectBase.set(this, 'category', value);

  @override
  String get coverUrl =>
      RealmObjectBase.get<String>(this, 'coverUrl') as String;
  @override
  set coverUrl(String value) => RealmObjectBase.set(this, 'coverUrl', value);

  @override
  String get pdfUrl => RealmObjectBase.get<String>(this, 'pdfUrl') as String;
  @override
  set pdfUrl(String value) => RealmObjectBase.set(this, 'pdfUrl', value);

  @override
  DateTime get uploadDate =>
      RealmObjectBase.get<DateTime>(this, 'uploadDate') as DateTime;
  @override
  set uploadDate(DateTime value) =>
      RealmObjectBase.set(this, 'uploadDate', value);

  @override
  int get pageCount => RealmObjectBase.get<int>(this, 'pageCount') as int;
  @override
  set pageCount(int value) => RealmObjectBase.set(this, 'pageCount', value);

  @override
  int get publicationYear =>
      RealmObjectBase.get<int>(this, 'publicationYear') as int;
  @override
  set publicationYear(int value) =>
      RealmObjectBase.set(this, 'publicationYear', value);

  @override
  int get viewCount => RealmObjectBase.get<int>(this, 'viewCount') as int;
  @override
  set viewCount(int value) => RealmObjectBase.set(this, 'viewCount', value);

  @override
  int get likeCount => RealmObjectBase.get<int>(this, 'likeCount') as int;
  @override
  set likeCount(int value) => RealmObjectBase.set(this, 'likeCount', value);

  @override
  Stream<RealmObjectChanges<Book>> get changes =>
      RealmObjectBase.getChanges<Book>(this);

  @override
  Stream<RealmObjectChanges<Book>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Book>(this, keyPaths);

  @override
  Book freeze() => RealmObjectBase.freezeObject<Book>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'title': title.toEJson(),
      'author': author.toEJson(),
      'description': description.toEJson(),
      'category': category.toEJson(),
      'coverUrl': coverUrl.toEJson(),
      'pdfUrl': pdfUrl.toEJson(),
      'uploadDate': uploadDate.toEJson(),
      'pageCount': pageCount.toEJson(),
      'publicationYear': publicationYear.toEJson(),
      'viewCount': viewCount.toEJson(),
      'likeCount': likeCount.toEJson(),
    };
  }

  static EJsonValue _toEJson(Book value) => value.toEJson();
  static Book _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'title': EJsonValue title,
        'author': EJsonValue author,
        'description': EJsonValue description,
        'coverUrl': EJsonValue coverUrl,
        'pdfUrl': EJsonValue pdfUrl,
        'uploadDate': EJsonValue uploadDate,
        'pageCount': EJsonValue pageCount,
        'publicationYear': EJsonValue publicationYear,
        'viewCount': EJsonValue viewCount,
        'likeCount': EJsonValue likeCount,
      } =>
        Book(
          fromEJson(id),
          fromEJson(title),
          fromEJson(author),
          fromEJson(description),
          fromEJson(coverUrl),
          fromEJson(pdfUrl),
          fromEJson(uploadDate),
          fromEJson(pageCount),
          fromEJson(publicationYear),
          fromEJson(viewCount),
          fromEJson(likeCount),
          category: fromEJson(ejson['category']),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Book._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(ObjectType.realmObject, Book, 'Book', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('author', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty(
        'category',
        RealmPropertyType.object,
        optional: true,
        linkTarget: 'Category',
      ),
      SchemaProperty('coverUrl', RealmPropertyType.string),
      SchemaProperty('pdfUrl', RealmPropertyType.string),
      SchemaProperty('uploadDate', RealmPropertyType.timestamp),
      SchemaProperty('pageCount', RealmPropertyType.int),
      SchemaProperty('publicationYear', RealmPropertyType.int),
      SchemaProperty('viewCount', RealmPropertyType.int),
      SchemaProperty('likeCount', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
