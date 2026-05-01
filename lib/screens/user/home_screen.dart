import 'package:eco_scan/screens/user/locate_bin_screen.dart'; // استيراد مكتبة Flutter الأساسية لبناء الواجهة
import 'package:eco_scan/screens/user/profile_screen.dart';
import 'package:flutter/material.dart';
import 'scan_waste_screen.dart'; // استيراد شاشة المسح حتى نتمكن من الانتقال إليها
import 'learn_recycle_screen.dart'; // استيراد شاشة Learn About Recycle حتى نتمكن من الانتقال إليها
import 'green_points_screen.dart'; // استيراد شاشة green points حتى نتمكن من الانتقال إليها

// NEW: Import model and services
import 'package:eco_scan/models/user_model.dart';
import 'package:eco_scan/services/points_service.dart';

class HomeScreen extends StatefulWidget {
  // استخدمنا StatefulWidget لأن القيم (النقاط والأشجار) ستتغير لاحقًا
  // NEW: Accept user from login — replaces hardcoded "Welcome Back, User"
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /*// متغير يمثل عدد النقاط التي حصل عليها المستخدم
  int points = 1320;
  // متغير يمثل عدد الأشجار التي تم إنقاذها
  int treesSaved = 50;*/

  // These are now loaded from PointsService instead of being hardcoded
  int _points = 0;
  int _treesSaved = 0;

  @override
  void initState() {
    super.initState();
    // Load live data from services when screen opens
    _loadData();
  }

  void _loadData() {
    // PointsService.getTotal() reads from Hive — no Hive code in the screen
    setState(() {
      _points = PointsService.getTotal(widget.user.id);
      _treesSaved = PointsService.getTreesSaved(widget.user.id);
    });
  }

  // NEW: Called when returning from ScanScreen so points refresh
  // Without this, the HomeScreen would show stale data after a scan
  void _onReturnFromScan() {
    _loadData(); // Reload from Hive
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون خلفية الصفحة
      backgroundColor: const Color(0xFF002C20),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // الصف العلوي (اسم المستخدم + صورة الحساب)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CHANGED: Shows real user name from UserModel
                  Text(
                    "Welcome Back, ${widget.user.name.split(' ').first}",
                    style: const TextStyle(color: Colors.white, fontSize: 28),
                  ),

                  // صورة المستخدم
                  // In the top Row of your HomeScreen build method:
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(user: widget.user),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF005A45),
                      child: Icon(Icons.person, color: Color(0xFF9AE600)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // صندوق الإحصائيات (النقاط + الأشجار)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF9AE600),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // الجزء الخاص بالنقاط
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recyclable Green",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),

                        // عرض قيمة النقاط باستخدام المتغير
                        // CHANGED: _points is now live from PointsService
                        Text(
                          "Points: $_points",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // الجزء الخاص بعدد الأشجار
                    Column(
                      children: [
                        // CHANGED: _treesSaved is now live from PointsService
                        Text(
                          "Over $_treesSaved Trees",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
                          "Are Saved",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // شبكة الأزرار الرئيسية للتطبيق
              Expanded(
                child: GridView.count(
                  // عدد الأعمدة في الشبكة
                  crossAxisCount: 2,
                  // المسافة بين العناصر
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,

                  children: [
                    // زر Scan Waste
                    GestureDetector(
                      onTap: () async {
                        // CHANGED: await the navigation so we can refresh on return
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScanWasteScreen(user: widget.user),
                          ),
                        );
                        // Refresh points when user comes back from scan
                        _onReturnFromScan();
                      },
                      child: const FeatureBox(
                        icon: Icons.camera_alt,
                        title: "Scan Waste",
                      ),
                    ),

                    // زر Locate bin screen
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocateBinScreen(),
                          ),
                        );
                      },
                      child: // زر Locate Bin
                      const FeatureBox(
                        icon: Icons.location_on,
                        title: "Locate Bin",
                      ),
                    ),

                    // زر Learn About Recycle
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LearnRecycleScreen(),
                          ),
                        );
                      },

                      child: const FeatureBox(
                        icon: Icons.menu_book,
                        title: "Learn About Recycle",
                      ),
                    ),

                    // زر Check Green Points
                    GestureDetector(
                      onTap: () async {
                        // CHANGED: await so points refresh when coming back
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GreenPointsScreen(user: widget.user),
                          ),
                        );
                        _onReturnFromScan(); // Refresh after visiting points screen
                      },
                      child: const FeatureBox(
                        icon: Icons.eco,
                        title: "Check Your Green Points",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget خاص بمربعات الميزات لتقليل تكرار الكود
class FeatureBox extends StatelessWidget {
  final IconData icon;
  final String title;

  const FeatureBox({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF005A45),
        borderRadius: BorderRadius.circular(25),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة الميزة
          Icon(icon, size: 45, color: const Color(0xFF9AE600)),

          const SizedBox(height: 10),

          // اسم الميزة
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
