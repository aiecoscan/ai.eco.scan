// ============================================================
// USER MODEL
// ============================================================
// This file defines the structure of a "User" object as it
// will be stored in Hive. Think of this as one row in your
// "Users" table from the DB schema.
//
// We use the 'hive' package annotations so Hive knows how
// to automatically serialize/deserialize this object.
// The numbers (field: 0, field: 1...) are Hive's internal
// field IDs — they must NEVER change once set, or stored
// data will break.
// ============================================================

import 'package:hive/hive.dart';

// This tells Hive: "generate an adapter for this class"
// The typeId must be unique across ALL your Hive models.
// User = 0, ScanLog = 1, PointsData = 2
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  // HiveObject gives us .save() and .delete() methods for free

  @HiveField(0)
  final String id; // Replaces user_id from schema. We generate a UUID.

  @HiveField(1)
  String name; // Maps to 'name' varchar(100) in schema

  @HiveField(2)
  String email; // Maps to 'email' varchar(150) in schema

  @HiveField(3)
  String passwordHash; // Maps to 'password' varchar(255). We store a hash, NEVER plain text.

  @HiveField(4)
  String phone; // Maps to 'phone' varchar(20) in schema

  @HiveField(5)
  int totalPoints; // Maps to 'total_points' int in schema

  @HiveField(6)
  final DateTime createdAt; // Maps to 'created_at' datetime in schema

  @HiveField(7)
  final bool isAdmin; // Separates Users from Admins table in schema.
  // We merge both into one model for simplicity since
  // the only difference in your schema is the table.

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.phone,
    this.totalPoints = 0, // New users start with 0 points
    required this.createdAt,
    this.isAdmin = false, // Default: regular user
  });
}
