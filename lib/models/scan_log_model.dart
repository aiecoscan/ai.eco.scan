// ============================================================
// SCAN LOG MODEL
// ============================================================
// This maps to your "Scanned_Items" table in the DB schema.
// Every time a user scans something and gets a result,
// we create one of these and save it to Hive.
//
// It also partially covers "Recycling_Transaction" because
// in a local-only app without a real bin, the scan IS the
// recycling event. We capture everything we can.
// ============================================================

import 'package:hive/hive.dart';

part 'scan_log_model.g.dart';

@HiveType(typeId: 1) // typeId 1 — must be different from UserModel (0)
class ScanLogModel extends HiveObject {

  @HiveField(0)
  final String id; // Replaces scan_id. UUID generated at creation.

  @HiveField(1)
  final String userId; // FK to UserModel.id — replaces user_id in schema

  @HiveField(2)
  final String wasteType; // Maps to 'waste_type' — "PLASTIC" or "METAL"

  @HiveField(3)
  final double confidence; // Maps to 'confidence' float in schema
  // This is the score from your classifier (0.0 to 1.0)

  @HiveField(4)
  final String imagePath; // Maps to 'image_path' varchar(500)
  // The path to the saved tagged image on device storage

  @HiveField(5)
  final String status; // Maps to 'status' varchar(50)
  // For now: "scanned". Could later be "recycled", "pending"

  @HiveField(6)
  final DateTime scannedAt; // Maps to 'scanned_at' datetime

  @HiveField(7)
  final int pointsEarned; // How many points this scan gave the user
  // Not in schema directly — comes from Points_Transaction

  ScanLogModel({
    required this.id,
    required this.userId,
    required this.wasteType,
    required this.confidence,
    required this.imagePath,
    this.status = 'scanned',
    required this.scannedAt,
    required this.pointsEarned,
  });

  // ── Helpers ────────────────────────────────────────────────
  // These make it easier to display data in the UI
  // without putting logic in your widgets.

  /// Returns the points earned as a formatted string e.g. "+10 pts"
  String get pointsDisplay => '+$pointsEarned pts';

  /// Returns confidence as a percentage string e.g. "87%"
  String get confidenceDisplay =>
      '${(confidence * 100).toStringAsFixed(0)}%';

  /// Returns a human-readable time like "Today", "Yesterday", "3 days ago"
  String get timeDisplay {
    final now = DateTime.now();
    final diff = now.difference(scannedAt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }
}
