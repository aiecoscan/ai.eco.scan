import 'package:flutter/material.dart';
import 'package:eco_scan/screens/admin/manage_bins_screen.dart';
import 'package:eco_scan/screens/admin/hive_inspector_screen.dart'; // NEW

// ============================================================
// ADMINSCREEN.DART — Updated
// ============================================================
// Change: Added "Hive Inspector" button alongside existing ones.
// The inspector opens HiveInspectorScreen which lets the admin
// browse all stored data across every Hive box.
// ============================================================
// ============================================================
// ADMIN_SCREEN.DART — Updated
// ============================================================
// Changes: Statistics card now shows live data from Hive.
//
// 1. Total Users    = count of non-admin UserModels in userBox
// 2. Earned Points  = sum of all users' totalPoints (was "Redeemed")
// 3. Recycle Rate   = totalScans / (maxScansPerUser × totalUsers)
//    Formula from spec: e.g. 3 users scan [3,1,2] → 6/(3×3)=66.6%
//
// Admin screen is StatefulWidget now (was StatelessWidget)
// because stats need to refresh when returning from sub-screens.
// ============================================================

import 'package:hive/hive.dart';
import 'package:eco_scan/models/hive_init.dart';
import 'package:eco_scan/models/user_model.dart';
import 'package:eco_scan/services/points_service.dart';
import 'package:eco_scan/services/scan_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Live stats loaded from Hive
  int _totalUsers = 0;
  int _earnedPoints = 0;
  String _recycleRate = '0%';

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  // Called on init and whenever we return from a sub-screen
  void _loadStats() {
    final userBox = Hive.box<UserModel>(HiveInit.userBox);

    // 1. Total Users — count non-admin users only
    final totalUsers = userBox.values.where((u) => !u.isAdmin).length;

    // 2. Earned Points — sum across all non-admin users
    final earnedPoints = PointsService.getTotalEarnedPointsAllUsers();

    // 3. Recycle Rate — using the formula from spec
    final rate = PointsService.getRecycleRate();
    final rateStr = '${(rate * 100).toStringAsFixed(1)}%';

    setState(() {
      _totalUsers = totalUsers;
      _earnedPoints = earnedPoints;
      _recycleRate = rateStr;
    });
  }

  // Navigate to a page and refresh stats on return
  Future<void> _navAndRefresh(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    _loadStats(); // refresh after returning
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF013C2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Admin Screen",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 15),

              /// Welcome Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF014D3B),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Example: Long press on "Welcome Back, Admin"
                    GestureDetector(
                      onLongPress: () {
                        _navAndRefresh(const HiveInspectorScreen());
                      },
                      child: const Text(
                        "Welcome Back, Admin",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.greenAccent.shade400,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: _adminButton(
                      icon: Icons.delete,
                      title: "Manage Bins",
                      onTap: () => _navAndRefresh(const ManageBinsScreen()),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _adminButton(
                      icon: Icons.map,
                      title: "Geo Map",
                      onTap: () => _navAndRefresh(const ManageBinsScreen()),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Statistics Title
              const Text(
                "Statistics",
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),

              const SizedBox(height: 20),

              /// Statistics Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF075642),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      // Row 1: Earned Points + Total Users
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              title: "Earned Points", // was "Redeemed"
                              value: _earnedPoints > 999
                                  ? '${(_earnedPoints / 1000).toStringAsFixed(1)}K'
                                  : '$_earnedPoints',
                              icon: Icons.eco,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _statCard(
                              title: "Total Users",
                              value: '$_totalUsers', // live from Hive
                              icon: Icons.person,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Row 2: Recycle Rate — full width
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              title: "Recycle Rate",
                              value: _recycleRate, // live formula result
                              icon: Icons.recycling,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Admin Button
  // Updated adminButton with optional subtitle, fullWidth, and color params
  Widget _adminButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF0B6A52),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: Colors.greenAccent),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  /// Statistics Card
  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFAED4A3),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(height: 5),
          Text(
            "$title\n$value",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
