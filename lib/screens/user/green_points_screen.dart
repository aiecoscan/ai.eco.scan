import 'package:flutter/material.dart'; // استيراد مكتبة Flutter

// NEW: Import model and services
import 'package:eco_scan/models/user_model.dart';
import 'package:eco_scan/services/points_service.dart';

class GreenPointsScreen extends StatefulWidget {
  // شاشة النقاط الخضراء
  // NEW: Accept user to know whose points to load
  final UserModel user;

  const GreenPointsScreen({super.key, required this.user});

  @override
  State<GreenPointsScreen> createState() => _GreenPointsScreenState();
}

class _GreenPointsScreenState extends State<GreenPointsScreen> {
  // These will be loaded from PointsService — no more hardcoded values
  int _greenPoints = 0;
  int _recycledKg = 0;
  int _recycledTimes = 0;
  List<Map<String, String>> _history = [];

  @override
  void initState() {
    super.initState();
    // Load data when screen opens
    _loadData();
  }

  void _loadData() {
    // All these calls read from Hive via PointsService.
    // No Hive code in the screen — that's the abstraction working.
    final stats = PointsService.getStats(widget.user.id);

    setState(() {
      _greenPoints = PointsService.getTotal(widget.user.id);
      _recycledKg = stats['recycledKg'] ?? 0;
      _recycledTimes = stats['recycledTimes'] ?? 0;
      _history = PointsService.getHistory(widget.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C20),

      // NEW: RefreshIndicator lets users pull down to refresh data
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        color: const Color(0xFF9AE600),

        child: SafeArea(
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // physics needed for RefreshIndicator to work
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    // زر الرجوع
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF9AE600),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 10),

                  // عنوان الصفحة
                  const Text(
                    "Your Green Points",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),

                  const SizedBox(height: 25),

                  Container(
                    // صندوق النقاط الكبير
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8D7A3),
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "You recycled waste equivalent to",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),

                        const SizedBox(height: 10),

                        // CHANGED: was hardcoded 1340, now reads from Hive
                        Text(
                          "$_greenPoints points",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    // الإحصائيات
                    children: [
                      Expanded(
                        child: statBox(
                          "Recycled in a month about",
                          // CHANGED: was hardcoded "60 Kg", now from Hive
                          "$_recycledKg Kg",
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: statBox(
                          "Recycled in a month about",
                          // CHANGED: was hardcoded "25 Times", now from Hive
                          "$_recycledTimes Times",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "History",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),

                  const SizedBox(height: 15),

                  // CHANGED: History now comes from PointsService, not hardcoded list
                  // If no scans yet, show an empty state message
                  _history.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              "No scans yet.\nScan something to earn points! 🌱",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: _history.map((item) {
                            return historyItem(
                              item["item"]!,
                              item["time"]!,
                              item["points"]!,
                            );
                          }).toList(),
                        ),

                  // REMOVED: "Add Points (Test)" button
                  // Real scans now add points automatically
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // statBox and historyItem widgets unchanged from original
  Widget statBox(String title, String value) {
    // صندوق الإحصائيات
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF005A45),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF00D492),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget historyItem(String title, String time, String points) {
    // عنصر من عناصر التاريخ
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF005A45),
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xFF00D492), fontSize: 16),
              ),

              Text(
                time,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),

          Text(
            points,
            style: const TextStyle(
              color: Color(0xFF9AE600),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
