// ============================================================
// POINTS SERVICE
// ============================================================
// This service handles everything about points and rewards.
// It covers the "Points_Transaction" table from your schema.
//
// It is called BY ScanService — screens never call it directly
// for scan-based points. But screens CAN call getTotal() and
// getHistory() to READ points data for display.
// ============================================================

import 'package:hive/hive.dart';
import '../models/points_data_model.dart';
import '../models/hive_init.dart';
import 'auth_service.dart';

class PointsService {
  // ── Private Box Accessor ─────────────────────────────────
  static Box<PointsDataModel> get _box =>
      Hive.box<PointsDataModel>(HiveInit.pointsBox);

  // ============================================================
  // GET OR CREATE POINTS DATA
  // ============================================================
  // Every user has exactly ONE PointsDataModel in the box.
  // If it doesn't exist yet (new user), we create it.
  // This is a private helper used by all other methods.
  // ============================================================
  static PointsDataModel _getOrCreate(String userId) {
    // Try to get existing — using userId as the key
    final existing = _box.get(userId);
    if (existing != null) return existing;

    // First time for this user — create a fresh one
    final fresh = PointsDataModel(userId: userId);
    _box.put(userId, fresh); // save immediately
    return fresh;
  }

  // ============================================================
  // GET TOTAL POINTS
  // ============================================================
  // Called by HomeScreen and GreenPointsScreen to display points.
  // Replaces the hardcoded "int points = 1320" in your screens.
  //
  // Maps to: SELECT total_points FROM Users WHERE user_id = ?
  // ============================================================
  static int getTotal(String userId) {
    return _getOrCreate(userId).totalPoints;
  }

  // ============================================================
  // GET TREES SAVED
  // ============================================================
  // Called by HomeScreen to show "Over X Trees Are Saved".
  // Replaces hardcoded "int treesSaved = 50".
  // ============================================================
  static int getTreesSaved(String userId) {
    return _getOrCreate(userId).treesSaved;
  }

  // ============================================================
  // GET STATS
  // ============================================================
  // Called by GreenPointsScreen for the two stat boxes.
  // Returns kg recycled and number of times recycled.
  // ============================================================
  static Map<String, int> getStats(String userId) {
    final data = _getOrCreate(userId);
    return {
      'recycledKg': data.recycledKg,
      'recycledTimes': data.recycledTimes,
    };
  }

  // ============================================================
  // GET HISTORY
  // ============================================================
  // Called by GreenPointsScreen to build the history list.
  // Returns a list of maps that match the format your existing
  // history widget already expects — so minimal UI changes needed.
  //
  // Maps to:
  //   SELECT * FROM Points_Transaction WHERE user_id = ?
  //   ORDER BY transaction_date DESC
  // ============================================================
  static List<Map<String, String>> getHistory(String userId) {
    final data = _getOrCreate(userId);

    // Build history list from parallel arrays in the model.
    // We zip rewardTypes, pointAmounts, and transactionDates together.
    final List<Map<String, String>> history = [];

    for (int i = data.rewardTypes.length - 1; i >= 0; i--) {
      // Build time display string
      final date = data.transactionDates[i];
      final now = DateTime.now();
      final diff = now.difference(date);
      String timeDisplay;
      if (diff.inDays == 0) {
        timeDisplay = 'Today';
      } else if (diff.inDays == 1) {
        timeDisplay = 'Yesterday';
      } else {
        timeDisplay = '${diff.inDays} days ago';
      }

      history.add({
        'item': data.rewardTypes[i],  // e.g. "PLASTIC Scan"
        'time': timeDisplay,
        'points': '+${data.pointAmounts[i]} pts',
      });
    }

    return history;
  }

  // ============================================================
  // ADD POINTS FOR SCAN
  // ============================================================
  // This is called by ScanService — NOT directly by screens.
  // It updates all the points data when a new scan is saved.
  //
  // Maps to:
  //   INSERT INTO Points_Transaction (user_id, reward_type, points_amount...) VALUES (...)
  //   UPDATE Users SET total_points = total_points + ? WHERE user_id = ?
  // ============================================================
  static Future<void> addPointsForScan({
    required String userId,
    required int points,
    required String wasteType,
    required String scanId,
  }) async {
    final data = _getOrCreate(userId);

    // Update all the stats
    data.totalPoints += points;
    data.recycledKg += 1; // ~1kg per scan for demo
    data.recycledTimes += 1;

    // Add to transaction history lists
    data.rewardTypes.add('$wasteType Scan');
    data.pointAmounts.add(points);
    data.transactionDates.add(DateTime.now());

    // Save the updated object back to Hive
    await data.save(); // HiveObject.save() updates in place

    // Also update the User's total_points field to keep them in sync
    await AuthService.addPointsToUser(userId, points);
  }

  // ============================================================
  // RESET POINTS (for testing)
  // ============================================================
  // Useful during development to reset a user's points to zero.
  static Future<void> resetPoints(String userId) async {
    final data = _getOrCreate(userId);
    data.totalPoints = 0;
    data.recycledKg = 0;
    data.recycledTimes = 0;
    data.rewardTypes.clear();
    data.pointAmounts.clear();
    data.transactionDates.clear();
    await data.save();
  }
}
