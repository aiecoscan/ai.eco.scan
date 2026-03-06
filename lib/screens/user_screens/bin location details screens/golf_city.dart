import 'package:flutter/material.dart';

// مكتبة للحصول على موقع الجهاز
import 'package:geolocator/geolocator.dart';

// مكتبة لفتح Google Maps
import 'package:url_launcher/url_launcher.dart';

class GolfCityScreen extends StatelessWidget {
  const GolfCityScreen({super.key});

  // ==============================
  // دالة فتح Google Maps بالموقع الحالي
  // ==============================
  Future<void> openMap() async {
    // التحقق من إذن الموقع
    LocationPermission permission = await Geolocator.checkPermission();

    // طلب الإذن إذا لم يكن مُعطى
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // الحصول على الموقع الحالي
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // إنشاء رابط Google Maps باستخدام الإحداثيات
    final Uri googleUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}",
    );

    // فتح Google Maps
    await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C20),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // زر الرجوع
              // =========================
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF9AE600)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),

              // عنوان الصفحة
              const Text(
                "Golf City Mall",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),

              const SizedBox(height: 25),

              // =========================
              // صندوق الحالة
              // =========================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF005A45),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Status",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFF9AE600),
                          child: Icon(Icons.check, color: Colors.black),
                        ),

                        const SizedBox(width: 12),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Active",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),

                            Text(
                              "This bin is currently operational",
                              style: TextStyle(color: Color(0xFF00D492)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // صندوق الموقع
              // =========================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF005A45),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Location",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),

                    const SizedBox(height: 15),

                    // مربع الخريطة
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF002C20),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Center(
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: Color(0xFF9AE600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: const [
                        Icon(Icons.location_on, color: Color(0xFF9AE600)),

                        SizedBox(width: 8),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(color: Color(0xFF00D492)),
                            ),

                            Text(
                              "Entrance to Obour City",
                              style: TextStyle(color: Colors.white),
                            ),

                            Text(
                              "1.2 km away from your location",
                              style: TextStyle(color: Color(0xFF00D492)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // زر الاتجاهات
              // =========================
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AE600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  // فتح Google Maps
                  onPressed: () {
                    openMap();
                  },

                  child: const Text(
                    "Get Directions",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // =========================
              // زر الإبلاغ عن مشكلة
              // =========================
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005A45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  onPressed: () {},

                  child: const Text(
                    "Report a Problem",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
