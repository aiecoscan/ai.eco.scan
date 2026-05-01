import 'package:hive/hive.dart';
part 'bin_model.g.dart';

@HiveType(typeId: 3) // Make sure this ID is unique!
class BinModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String city;
  @HiveField(3)
  final String district;
  @HiveField(4)
  bool isActive;
  @HiveField(5)
  int reportCount;

  BinModel({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
    this.isActive = true,
    this.reportCount = 0,
  });
}
