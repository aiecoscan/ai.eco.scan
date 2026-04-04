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
// ============================================================
// SCAN SERVICE — Updated
// ============================================================
// Changes:
// 1. Added 65% confidence threshold — scans below this are
//    rejected at the service level, not just the screen.
//    Returns null instead of a ScanLogModel when rejected.
//
// 2. Weight per waste type:
//    METAL   = 13g per item
//    PLASTIC = 18g per item
//    default = 16g per item
//    This is passed to both ScanLogModel and PointsService.
//
// 3. Added deleteScanAndReversePoints() for the Hive Inspector.
//    Deleting a scan record must also subtract the points it
//    awarded from the user — otherwise the totals go out of sync.
// ============================================================

import 'package:hive/hive.dart';
import '../models/scan_log_model.dart';
import '../models/hive_init.dart';
import 'points_service.dart';

class ScanService {
  // ── Private Box Accessor ─────────────────────────────────
  static Box<ScanLogModel> get _box => Hive.box<ScanLogModel>(HiveInit.scanBox);

  // ── Business rules ────────────────────────────────────────

  // Minimum confidence to accept a scan as valid.
  // Below this threshold the scan is shown as "Not confident enough"
  // and is NOT saved to Hive or awarded points.
  static const double minConfidence = 0.65; // 65%

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

  // Weight in grams per item by type
  static const Map<String, double> _weightMap = {
    'PLASTIC': 18.0, // 18g average per plastic recyclable item
    'METAL': 13.0, // 13g average per metal recyclable item
  };
  static const double _defaultWeight = 16.0; // fallback for unknown types

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
  // ============================================================
  // Returns null if confidence < 65% — caller must handle this.
  // Returns the saved ScanLogModel on success.
  // ============================================================

  static Future<ScanLogModel?> saveScan({
    required String userId,
    required String wasteType,
    required double confidence,
    required String imagePath,
  }) async {
    // GATE: reject low-confidence detections
    // These are not saved to history and earn no points.
    if (confidence < minConfidence) return null;

    // 1. Calculate points based on waste type
    //    Default to 5 points if type is unknown final points = _pointsMap[wasteType.toUpperCase()] ?? 5;
    final type = wasteType.toUpperCase();
    final points = _pointsMap[type] ?? 5;
    final weightGrams = _weightMap[type] ?? _defaultWeight;

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
      weightGrams: weightGrams, // NEW: per-type weight
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
      weightGrams: weightGrams, // NEW: pass weight through
    );

    return scan;
  }

  // ============================================================
  // DELETE SCAN AND REVERSE POINTS
  // ============================================================
  // Called by the Hive Inspector when an admin deletes a scan.
  // MUST reverse the points that were awarded for this scan,
  // otherwise totals in UserModel and PointsDataModel go stale.
  //
  // Steps:
  //   1. Find the scan record
  //   2. Tell PointsService to subtract its points and weight
  //   3. Delete the scan record from Hive
  // ============================================================
  static Future<void> deleteScanAndReversePoints(String scanId) async {
    final scan = _box.get(scanId);
    if (scan == null) return; // already gone — nothing to do

    // Reverse the points BEFORE deleting (we need the data first)
    await PointsService.removeScanPoints(
      userId: scan.userId,
      points: scan.pointsEarned,
      weightGrams: scan.weightGrams,
    );

    // Now delete the scan record
    await _box.delete(scanId);
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
    final scans = _box.values.where((s) => s.userId == userId).toList();

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
    return getScansForUser(userId).take(limit).toList();
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
  // GET TOTAL SCAN COUNT ACROSS ALL USERS — used by admin stats
  // ============================================================
  static int getTotalScanCount() {
    return _box.length;
  }

  // ============================================================
  // GET MAX SCANS BY ANY SINGLE USER — used for recycle rate
  // ============================================================
  static int getMaxScansForAnyUser() {
    if (_box.isEmpty) return 0;

    // Count scans per user ID
    final Map<String, int> counts = {};
    for (final scan in _box.values) {
      counts[scan.userId] = (counts[scan.userId] ?? 0) + 1;
    }

    return counts.values.reduce((a, b) => a > b ? a : b);
  }
}
