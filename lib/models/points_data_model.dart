// ============================================================
// POINTS DATA MODEL
// ============================================================
// This partially maps to "Points_Transaction" in your schema.
// Instead of storing individual transaction rows (which Hive
// can do but adds complexity), we store a running summary
// for the user. The full history comes from ScanLogModel.
//
// Why not use ScanLogModel for everything?
// Because points could eventually come from non-scan sources
// (referrals, bonuses, redemptions). This model handles that.
// ============================================================
// ============================================================
// POINTS DATA MODEL — Updated
// ============================================================
// Change: Added HiveField(7) recycledGrams (double)
//
// WHY not change field 2 (recycledKg int → double):
//   Same reason as scan_log_model — changing the type of an
//   existing Hive field breaks deserialization of old records.
//   We ADD a new field (7) for the precise float weight.
//   Field 2 (recycledKg) is kept as int for backwards compat
//   but is no longer written to — only recycledGrams is updated.
//   The display getter converts grams → kg for the UI.
//
// Also fixed: treesSaved now uses recycledGrams so it scales
//   correctly with the new per-item gram weights.
// ============================================================
// ============================================================
// POINTS DATA MODEL — Migration Fix
// ============================================================
// Same fix as scan_log_model.dart — same root cause.
//
// @HiveField(7) double recycledGrams was declared non-nullable.
// Old PointsDataModel records on device have no bytes for field 7.
// The regenerated adapter reads null and crashes casting to double.
//
// Fix: declare the backing field as double? (_recycledGrams),
// expose it through a getter `recycledGrams` that returns ?? 0.0.
// The setter also goes through a private field so Hive can
// mutate it (since PointsDataModel needs to accumulate weight).
// ============================================================

import 'package:hive/hive.dart';

part 'points_data_model.g.dart';

@HiveType(typeId: 2) // typeId 2
class PointsDataModel extends HiveObject {
  @HiveField(0)
  final String userId; // FK to UserModel.id

  @HiveField(1)
  int totalPoints; // The running total — mirrors UserModel.totalPoints
  // We keep it here too so PointsService is self-contained

  @HiveField(2)
  int recycledKg; // Maps to weight_kg from Recycling_Transaction
  // We estimate: 1 scan = ~1kg for demo purposes
  // KEPT for backwards compat — no longer written to
  // Use recycledGrams for all new logic

  @HiveField(3)
  int recycledTimes; // Total number of successful scans

  @HiveField(4)
  List<String> rewardTypes; // Maps to 'reward_type' in Points_Transaction
  // e.g. ["scan", "scan", "bonus"] — parallel list with amounts

  @HiveField(5)
  List<int> pointAmounts; // Maps to 'points_amount' int
  // e.g. [10, 12, 50] — parallel list with rewardTypes

  @HiveField(6)
  List<DateTime> transactionDates; // When each transaction happened

  // NEW: precise weight in grams — replaces recycledKg for display
  // Metal=13g, Plastic=18g, default=16g per scan
  // FIX: nullable backing field — old records read null here, no crash.
  @HiveField(7)
  double? _recycledGrams;

  PointsDataModel({
    required this.userId,
    this.totalPoints = 0,
    this.recycledKg = 0,
    this.recycledTimes = 0,
    List<String>? rewardTypes,
    List<int>? pointAmounts,
    List<DateTime>? transactionDates,
    double? recycledGrams,
  }) : _recycledGrams = recycledGrams,
       rewardTypes = rewardTypes ?? [],
       pointAmounts = pointAmounts ?? [],
       transactionDates = transactionDates ?? [];

  // ── Safe getter: returns stored value or 0.0 for old records ──
  double get recycledGrams => _recycledGrams ?? 0.0;

  // ── Setter: used by PointsService to accumulate weight ────────
  set recycledGrams(double value) {
    _recycledGrams = value;
  }

  // ── Helpers ────────────────────────────────────────────────

  /// Total recycled weight as a formatted string for the UI.
  /// Shows grams if under 1kg, otherwise shows kg with 2 decimals.
  /// e.g. "754g" or "1.23 kg"
  String get recycledWeightDisplay {
    if (recycledGrams < 1000) {
      return '${recycledGrams.toStringAsFixed(0)}g';
    }
    return '${(recycledGrams / 1000).toStringAsFixed(2)} kg';
  }

  /// How many trees saved — your app shows this on HomeScreen.
  /// Using the common estimate: 1 tree = ~8333 sheets = ~80kg paper.
  /// For a fun metric, we say every 10kg recycled = 1 tree saved. int get treesSaved => (recycledKg / 10).floor();
  /// Trees saved — based on accurate gram weight now.
  /// 1 tree saved per 500g recycled (reasonable approximation).
  int get treesSaved => (recycledGrams / 500).floor();
}
