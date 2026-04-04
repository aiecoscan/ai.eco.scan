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
// ============================================================
// POINTS SERVICE — Updated
// ============================================================
// Changes:
// 1. addPointsForScan now accepts weightGrams and updates
//    recycledGrams (the new float field) instead of recycledKg.
//
// 2. NEW: removeScanPoints() — called by ScanService.deleteScan()
//    when an admin deletes a scan from the Hive Inspector.
//    Subtracts points, weight, and recycledTimes from the user's
//    PointsDataModel and from UserModel.totalPoints.
//    Also removes the matching entry from the history lists.
//
// 3. NEW: Admin stat methods:
//    - getTotalEarnedPointsAllUsers()
//    - getRecycleRate()
//
// 4. getHistory() now uses ScanLogModel.timeDisplay (the fixed
//    calendar-date version) instead of duplicating the logic here.
//    Since history is built from the PointsDataModel's own
//    transactionDates, we apply the same fix inline.
// ============================================================

import 'package:eco_scan/models/scan_log_model.dart';
import 'package:hive/hive.dart';
import '../models/points_data_model.dart';
import '../models/user_model.dart';
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

  // ── Fixed date helper — same logic as ScanLogModel.timeDisplay
  static String _timeDisplay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '$diff days ago';
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
  // GET STATS returns weight display string, not int kg
  // ============================================================
  // Called by GreenPointsScreen for the two stat boxes.
  // Returns kg recycled and number of times recycled.
  // ============================================================
  static Map<String, dynamic> getStats(String userId) {
    final data = _getOrCreate(userId);
    return {
      'recycledWeight': data.recycledWeightDisplay, // e.g. "754g" or "1.23 kg"
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
      history.add({
        'item': data.rewardTypes[i],
        'time': _timeDisplay(data.transactionDates[i]), // FIX: calendar-based
        'points': '+${data.pointAmounts[i]} pts',
      });
    }
    return history;
  }

  // ============================================================
  // ADD POINTS FOR SCAN — Updated to accept weightGrams
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
    required double weightGrams, // NEW parameter
  }) async {
    final data = _getOrCreate(userId);

    // Update all the stats
    data.totalPoints += points;
    // data.recycledKg += 1; // ~1kg per scan for demo
    data.recycledTimes += 1;
    data.recycledGrams += weightGrams; // NEW: update grams, not kg int

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
  // REMOVE SCAN POINTS — NEW
  // ============================================================
  // Called when an admin deletes a scan record in the inspector.
  // Reverses all effects of addPointsForScan for that scan.
  //
  // The tricky part: history is stored as parallel lists
  // (rewardTypes, pointAmounts, transactionDates). We can't
  // match by scanId because the lists don't store it.
  // Strategy: find the most recent entry in the history that
  // matches the points amount — this is the best we can do
  // without storing scanIds in the history lists.
  // For a graduation project this is perfectly fine.
  // ============================================================
  static Future<void> removeScanPoints({
    required String userId,
    required int points,
    required double weightGrams,
  }) async {
    final data = _getOrCreate(userId);

    // 1. Subtract from totals — clamp to 0 so we never go negative
    data.totalPoints = (data.totalPoints - points).clamp(0, 999999);
    data.recycledTimes = (data.recycledTimes - 1).clamp(0, 999999);
    data.recycledGrams = (data.recycledGrams - weightGrams).clamp(
      0.0,
      999999.0,
    );

    // 2. Remove ONE matching entry from the history lists.
    //    Search from the end (newest first) for a matching point amount.
    for (int i = data.pointAmounts.length - 1; i >= 0; i--) {
      if (data.pointAmounts[i] == points) {
        data.rewardTypes.removeAt(i);
        data.pointAmounts.removeAt(i);
        data.transactionDates.removeAt(i);
        break; // only remove ONE entry per deletion
      }
    }

    await data.save();

    // 3. Also subtract from UserModel.totalPoints
    await AuthService.addPointsToUser(userId, -points); // negative = subtract
  }

  // ============================================================
  // ADMIN STAT: TOTAL EARNED POINTS ACROSS ALL USERS
  // ============================================================
  // Sums totalPoints from every PointsDataModel in the box.
  // Excludes admin accounts (admins don't earn points).
  static int getTotalEarnedPointsAllUsers() {
    int total = 0;
    final userBox = Hive.box<UserModel>(HiveInit.userBox);

    for (final data in _box.values) {
      // Only count non-admin users
      final user = userBox.get(data.userId);
      if (user != null && !user.isAdmin) {
        total += data.totalPoints;
      }
    }
    return total;
  }

  // ============================================================
  // ADMIN STAT: RECYCLE RATE
  // ============================================================
  // Formula:
  //   Total scans across all users
  //   ─────────────────────────────────────────────────────────
  //   (Max scans by any single user) × (Total number of users)
  //
  // Example from your spec:
  //   Users: 3, Scans: [3, 1, 2] → total=6, max=3
  //   Rate = 6 / (3 × 3) = 6/9 = 66.6%
  //
  // Returns a value 0.0–1.0. Multiply by 100 for percentage.
  // Returns 0.0 if there are no users or no scans.
  static double getRecycleRate() {
    // 1. Safety check: Ensure boxes are open before accessing
    if (!Hive.isBoxOpen(HiveInit.userBox) || !Hive.isBoxOpen(HiveInit.scanBox))
      return 0.0;

    final userBox = Hive.box<UserModel>(HiveInit.userBox);
    final scanBox = Hive.box<ScanLogModel>(HiveInit.scanBox);

    // 2. Map non-admin users to a Set for O(1) performance lookups
    final validUserIds = userBox.values
        .where((u) => !u.isAdmin)
        .map((u) => u.id)
        .toSet();

    final int totalUsers = validUserIds.length;
    if (totalUsers == 0) return 0.0;

    // 3. Tally scans (using whereType to auto-filter nulls and cast types)
    final Map<String, int> scanCounts = {for (var id in validUserIds) id: 0};
    int totalScans = 0;

    for (var scan in scanBox.values.whereType<ScanLogModel>()) {
      if (validUserIds.contains(scan.userId)) {
        scanCounts[scan.userId] = (scanCounts[scan.userId] ?? 0) + 1;
        totalScans++;
      }
    }

    if (totalScans == 0) return 0.0;

    // 4. Calculate Max Scans safely
    final int maxScans = scanCounts.values.fold(
      0,
      (max, count) => count > max ? count : max,
    );

    if (maxScans == 0) return 0.0;

    // 5. Final Formula
    return totalScans / (maxScans * totalUsers);
  }

  // ============================================================
  // RESET POINTS (for testing)
  // ============================================================
  // Useful during development to reset a user's points to zero.
  static Future<void> resetPoints(String userId) async {
    final data = _getOrCreate(userId);
    data.totalPoints = 0;
    data.recycledKg = 0;
    data.recycledGrams = 0.0;
    data.recycledTimes = 0;
    data.rewardTypes.clear();
    data.pointAmounts.clear();
    data.transactionDates.clear();
    await data.save();
  }
}
