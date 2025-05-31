part of 'models.dart';

@RealmModel()
class _Category {
  @PrimaryKey()
  late String id;
  late String name;
}
