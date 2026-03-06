import 'package:flutter/material.dart';

// ===============================
// استيراد شاشات التفاصيل
// ===============================

// شاشة Future City LRT
import './bin location details screens/elshrok.dart';

// شاشة Golf City Mall
import './bin location details screens/golf_city.dart';

// شاشة El-Salam Bus Stop
import './bin location details screens/elsalam_bus_stop.dart';

// شاشة Sun City Mall
import './bin location details screens/sun_city.dart';

class BinsResultScreen extends StatelessWidget {
  const BinsResultScreen({super.key});

  // ===============================
  // قائمة بيانات الصناديق
  // عدلت النوع ليكون واضح ومنظم
  // Map<String,dynamic> يعني البيانات عبارة عن
  // نصوص + قيم true/false
  // ===============================

  final List<Map<String, dynamic>> bins = const [
    {
      "name": "Future City LRT",
      "place": "El Shorouk",
      "distance": "0.8 km away",
      "active": true,
    },
    {
      "name": "Golf City Mall",
      "place": "Entrance to Obour City",
      "distance": "1.2 km away",
      "active": true,
    },
    {
      "name": "El-Salam Bus Stop",
      "place": "Masaken Al Amireyah",
      "distance": "1.8 km away",
      "active": false,
    },
    {
      "name": "Sun City Mall",
      "place": "El-Nasr Rd",
      "distance": "2.5 km away",
      "active": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C20),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===============================
              // زر الرجوع
              // ===============================
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF9AE600)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),

              // ===============================
              // عنوان الصفحة
              // ===============================
              const Text(
                "City, District - Bins",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),

              const SizedBox(height: 5),

              const Text(
                "Found 4 Recycling Bins",
                style: TextStyle(color: Color(0xFF00D492)),
              ),

              const SizedBox(height: 20),

              // ===============================
              // قائمة الصناديق
              // ListView.builder ينشئ الكروت
              // تلقائياً حسب عدد العناصر
              // ===============================
              Expanded(
                child: ListView.builder(
                  itemCount: bins.length,

                  itemBuilder: (context, index) {
                    // الحصول على بيانات الصندوق الحالي
                    final bin = bins[index];

                    return GestureDetector(
                      // ===============================
                      // عند الضغط على الكارت
                      // يتم فتح شاشة التفاصيل
                      // ===============================
                      onTap: () {
                        // Future City
                        if (bin["name"] == "Future City LRT") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ElshrokScreen(),
                            ),
                          );
                        }
                        // Golf City
                        else if (bin["name"] == "Golf City Mall") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GolfCityScreen(),
                            ),
                          );
                        }
                        // El-Salam Bus Stop
                        else if (bin["name"] == "El-Salam Bus Stop") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ElSalamBusStopScreen(),
                            ),
                          );
                        }
                        // Sun City
                        else if (bin["name"] == "Sun City Mall") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SunCityScreen(),
                            ),
                          );
                        }
                      },

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: const Color(0xFF005A45),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Row(
                          children: [
                            // ===============================
                            // أيقونة الموقع
                            // ===============================
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFF9AE600),
                            ),

                            const SizedBox(width: 10),

                            // ===============================
                            // بيانات الصندوق
                            // ===============================
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // اسم المكان
                                  Text(
                                    bin["name"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),

                                  // العنوان
                                  Text(
                                    bin["place"],
                                    style: const TextStyle(
                                      color: Color(0xFF00D492),
                                    ),
                                  ),

                                  // المسافة
                                  Text(
                                    bin["distance"],
                                    style: const TextStyle(
                                      color: Color(0xFF00D492),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ===============================
                            // حالة الصندوق
                            // Active أو Inactive
                            // ===============================
                            Row(
                              children: [
                                Icon(
                                  bin["active"]
                                      ? Icons.check_circle
                                      : Icons.cancel,

                                  color: bin["active"]
                                      ? Colors.green
                                      : Colors.red,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  bin["active"] ? "Active" : "Inactive",

                                  style: TextStyle(
                                    color: bin["active"]
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
