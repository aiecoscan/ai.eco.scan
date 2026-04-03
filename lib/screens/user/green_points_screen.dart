// استيراد مكتبة Flutter
import 'package:flutter/material.dart';

// شاشة النقاط الخضراء
class GreenPointsScreen extends StatefulWidget {
  const GreenPointsScreen({super.key});

  @override
  State<GreenPointsScreen> createState() => _GreenPointsScreenState();
}

class _GreenPointsScreenState extends State<GreenPointsScreen> {
  // متغير النقاط
  int greenPoints = 1340;

  // متغيرات الإحصائيات
  int recycledKg = 60;
  int recycledTimes = 25;

  // قائمة التاريخ
  List<Map<String, String>> history = [
    {"item": "Plastic Bottle", "time": "Today", "points": "+10 pts"},
    {"item": "Paper Cup", "time": "Yesterday", "points": "+7 pts"},
    {"item": "Glass Jar", "time": "2 days ago", "points": "+15 pts"},
    {"item": "Metal Can", "time": "4 days ago", "points": "+12 pts"},
  ];

  // دالة لإضافة نقاط جديدة (للتجربة)
  void addPoints() {
    setState(() {
      greenPoints += 10;
      recycledKg += 1;
      recycledTimes += 1;

      history.insert(0, {
        "item": "New Recycled Item",
        "time": "Now",
        "points": "+10 pts",
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C20),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // زر الرجوع
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF9AE600)),
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

                // صندوق النقاط الكبير
                Container(
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

                      // عرض النقاط المتغيرة
                      Text(
                        "$greenPoints points",
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

                // الإحصائيات
                Row(
                  children: [
                    Expanded(
                      child: statBox(
                        "Recycled in a month about",
                        "$recycledKg Kg",
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: statBox(
                        "Recycled in a month about",
                        "$recycledTimes Times",
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

                // عرض التاريخ باستخدام ListView
                Column(
                  children: history.map((item) {
                    return historyItem(
                      item["item"]!,
                      item["time"]!,
                      item["points"]!,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // زر اختبار لزيادة النقاط
                Center(
                  child: ElevatedButton(
                    onPressed: addPoints,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9AE600),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),

                    child: const Text(
                      "Add Points (Test)",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // صندوق الإحصائيات
  Widget statBox(String title, String value) {
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

  // عنصر من عناصر التاريخ
  Widget historyItem(String title, String time, String points) {
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
