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
// ============================================================
// SCAN LOG MODEL — Updated
// ============================================================
// Change: Added HiveField(8) weightGrams (double)
//
// WHY a new field instead of changing an existing one:
//   Hive identifies fields by their NUMBER, not their name.
//   If you change the type of field 2 from int to double, old
//   data stored as int will be misread. Safe practice is always
//   to ADD new fields at the end with a new number.
//   Old records that don't have field 8 will get the default
//   value (0.0) — no crash, no data loss.
//
// Also fixed: timeDisplay now compares actual calendar dates
//   instead of diff.inDays, which caused the "always Today" bug.
//   Root cause: diff.inDays returns 0 for anything within 24h,
//   so a scan at 11:59pm and a check at 00:01am next day both
//   show "Today" even though they're on different calendar days.
//   Fix: compare year+month+day directly.
// ============================================================
// ============================================================
// SCAN LOG MODEL — Migration Fix
// ============================================================
// THE PROBLEM (why you got the TypeError):
//
//   When you added @HiveField(8) double weightGrams and ran
//   build_runner, it regenerated the adapter. The adapter reads
//   each field from binary storage by index. Old records saved
//   before field 8 existed simply don't have any bytes for it,
//   so the adapter reads null for that slot.
//
//   The generated adapter code looks roughly like:
//     fields[8] as double   ← CRASH when fields[8] is null
//
//   Your default value `this.weightGrams = 16.0` in the
//   constructor ONLY applies when you call ScanLogModel(...)
//   in Dart code. It does NOT apply during deserialization —
//   the adapter bypasses the constructor entirely and assigns
//   fields directly. So the default is never reached.
//
// THE FIX:
//   Declare weightGrams as double? (nullable) in the @HiveField.
//   The adapter will now read null safely without crashing.
//   Add a getter `weight` that returns the nullable field with
//   a fallback: `_weightGrams ?? 16.0`.
//   All existing code that uses weightGrams goes through this
//   getter and gets the correct value for both old and new records.
//
// AFTER THIS FIX: run build_runner again to regenerate the adapter.
//   flutter pub run build_runner build --delete-conflicting-outputs
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

  // NEW: weight in grams per item
  // Metal  = 13g average per recyclable item
  // Plastic = 18g average per recyclable item
  // Default = 16g for anything else
  // Stored as grams (not kg) to keep it an exact int-friendly float
  // and avoid floating point drift when summing many records.
  // FIX: declared as double? (nullable)
  // Old records will deserialize this as null — no crash.
  // New records will have the real value (13.0 or 18.0).
  // Access via the `weightGrams` getter below, never directly.
  @HiveField(8)
  final double? _weightGrams;

  ScanLogModel({
    required this.id,
    required this.userId,
    required this.wasteType,
    required this.confidence,
    required this.imagePath,
    this.status = 'scanned',
    required this.scannedAt,
    required this.pointsEarned,
    double? weightGrams, // nullable in constructor too
  }) : _weightGrams = weightGrams;

  // ── Safe getter with fallback ─────────────────────────────
  // This is the ONLY way anything should read weight.
  // Returns the stored value, or 16.0 for old records that
  // were saved before this field existed.
  double get weightGrams => _weightGrams ?? 16.0;

  // ── Helpers ────────────────────────────────────────────────
  // These make it easier to display data in the UI
  // without putting logic in your widgets.

  /// Returns the points earned as a formatted string e.g. "+10 pts"
  String get pointsDisplay => '+$pointsEarned pts';

  /// Returns confidence as a percentage string e.g. "87%"
  String get confidenceDisplay => '${(confidence * 100).toStringAsFixed(0)}%';

  /// Weight display: shows grams if < 1000g, otherwise kg with 2 decimals
  String get weightDisplay {
    if (weightGrams < 1000) {
      return '${weightGrams.toStringAsFixed(0)}g';
    }
    return '${(weightGrams / 1000).toStringAsFixed(2)}kg';
  }

  /// Returns a human-readable time like "Today", "Yesterday", "3 days ago"
  // FIX: timeDisplay — compare actual calendar dates, not diff.inHours/days
  //
  // OLD (broken):
  //   if (diff.inDays == 0) return 'Today';   ← wrong for cross-midnight
  //
  // NEW (correct):
  //   Check if year, month, and day all match today's date.
  //   A scan at 11:59pm that is checked at 12:01am the next day
  //   will correctly show "Yesterday" instead of "Today".
  String get timeDisplay {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final scanDate = DateTime(scannedAt.year, scannedAt.month, scannedAt.day);
    final diff = today.difference(scanDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
  }
}
