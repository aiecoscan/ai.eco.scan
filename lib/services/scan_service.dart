// ============================================================
// SCAN SERVICE
// ============================================================
// This service handles everything related to scan results.
// It covers the "Scanned_Items" table from your DB schema.
//
// KEY RESPONSIBILITY: When a scan is saved, this service
// automatically tells PointsService to award points.
// The screen never has to think about points — it just calls
// saveScan() and everything cascades correctly.
// ============================================================

import 'package:hive/hive.dart';
import '../models/scan_log_model.dart';
import '../models/hive_init.dart';
import 'points_service.dart';

class ScanService {
  // ── Private Box Accessor ─────────────────────────────────
  static Box<ScanLogModel> get _box =>
      Hive.box<ScanLogModel>(HiveInit.scanBox);

  // ── Points per waste type ─────────────────────────────────
  // This is your business logic for how many points each
  // waste type earns. Change these values to adjust rewards.
  // In your schema this would be a config table or backend rule.
  static const Map<String, int> _pointsMap = {
    'PLASTIC': 10,
    'METAL': 15,
    'GLASS': 12,
    'PAPER': 7,
  };

  // ============================================================
  // SAVE SCAN
  // ============================================================
  // Called from scan_waste_screen.dart after classification.
  // 
  // What this does in one call:
  // 1. Creates a ScanLogModel and saves it to Hive
  // 2. Figures out how many points to award
  // 3. Tells PointsService to add those points
  // 4. Returns the saved ScanLogModel so the screen can show it
  //
  // Maps to:
  //   INSERT INTO Scanned_Items (user_id, waste_type, ...) VALUES (...)
  //   INSERT INTO Recycling_Transaction (...) VALUES (...)
  //   INSERT INTO Points_Transaction (...) VALUES (...)
  // ============================================================
  static Future<ScanLogModel> saveScan({
    required String userId,
    required String wasteType,
    required double confidence,
    required String imagePath,
  }) async {
    // 1. Calculate points based on waste type
    //    Default to 5 points if type is unknown
    final points = _pointsMap[wasteType.toUpperCase()] ?? 5;

    // 2. Generate a unique ID for this scan
    final id = '${DateTime.now().millisecondsSinceEpoch}_$userId';

    // 3. Create the scan log object
    final scan = ScanLogModel(
      id: id,
      userId: userId,
      wasteType: wasteType,
      confidence: confidence,
      imagePath: imagePath,
      status: 'scanned',
      scannedAt: DateTime.now(),
      pointsEarned: points,
    );

    // 4. Save to Hive — using scan ID as the key
    await _box.put(scan.id, scan);

    // 5. Award points to the user — this call handles everything
    //    points-related so this service doesn't need to know about it
    await PointsService.addPointsForScan(
      userId: userId,
      points: points,
      wasteType: wasteType,
      scanId: id,
    );

    return scan;
  }

  // ============================================================
  // GET ALL SCANS FOR USER
  // ============================================================
  // Called from green_points_screen.dart to build the history list.
  // Returns scans sorted newest-first.
  //
  // Maps to:
  //   SELECT * FROM Scanned_Items WHERE user_id = ?
  //   ORDER BY scanned_at DESC
  // ============================================================
  static List<ScanLogModel> getScansForUser(String userId) {
    final scans = _box.values
        .where((s) => s.userId == userId)
        .toList();

    // Sort newest first — most recent scans at top of history
    scans.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    return scans;
  }

  // ============================================================
  // GET RECENT SCANS
  // ============================================================
  // Called from home_screen.dart if you want to show
  // a "recent activity" section. Returns only the last N scans.
  // ============================================================
  static List<ScanLogModel> getRecentScans(String userId, {int limit = 5}) {
    final all = getScansForUser(userId);
    return all.take(limit).toList();
  }

  // ============================================================
  // GET SCAN COUNT
  // ============================================================
  // Used by PointsService and GreenPointsScreen for stats.
  // Maps to: SELECT COUNT(*) FROM Scanned_Items WHERE user_id = ?
  // ============================================================
  static int getScanCount(String userId) {
    return _box.values.where((s) => s.userId == userId).length;
  }

  // ============================================================
  // GET TOTAL KG RECYCLED
  // ============================================================
  // Estimates total weight recycled — we use 1 scan ≈ 0.5kg.
  // In a real system this would come from Recycling_Transaction.weight_kg
  // ============================================================
  static double getTotalKgRecycled(String userId) {
    final count = getScanCount(userId);
    return count * 0.5; // 500g per item scanned
  }
}
