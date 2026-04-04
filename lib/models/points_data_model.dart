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

  PointsDataModel({
    required this.userId,
    this.totalPoints = 0,
    this.recycledKg = 0,
    this.recycledTimes = 0,
    List<String>? rewardTypes,
    List<int>? pointAmounts,
    List<DateTime>? transactionDates,
  })  : rewardTypes = rewardTypes ?? [],
        pointAmounts = pointAmounts ?? [],
        transactionDates = transactionDates ?? [];

  // ── Helpers ────────────────────────────────────────────────

  /// How many trees saved — your app shows this on HomeScreen.
  /// Using the common estimate: 1 tree = ~8333 sheets = ~80kg paper.
  /// For a fun metric, we say every 10kg recycled = 1 tree saved.
  int get treesSaved => (recycledKg / 10).floor();
}
