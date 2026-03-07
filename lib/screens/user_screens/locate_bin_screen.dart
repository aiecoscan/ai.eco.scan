// استيراد مكتبة Flutter لبناء الواجهة
import 'package:flutter/material.dart';

// مكتبة تحديد الموقع
import 'package:geolocator/geolocator.dart';

// مكتبة فتح التطبيقات الخارجية مثل Google Maps
import 'package:url_launcher/url_launcher.dart';

// استرداد صفحة bins_result
import 'bins_result_screen.dart';

class LocateBinScreen extends StatelessWidget {
  const LocateBinScreen({super.key});

  // دالة الحصول على الموقع وفتح Google Maps
  Future<void> openGPS() async {
    // التأكد أن خدمة الموقع تعمل
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    // طلب إذن الموقع
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // الحصول على الموقع الحالي
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // إنشاء رابط Google Maps بالموقع الحالي
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
                "Locate Recycling Bin",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),

              const SizedBox(height: 30),

              // الصندوق الرئيسي
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF004D38),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Where are you?",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),

                    const SizedBox(height: 15),

                    // إدخال المدينة
                    TextField(
                      cursorColor: const Color(0xFF9AE600),
                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: "Enter City",
                        hintStyle: const TextStyle(color: Color(0xFF00D492)),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF00B97B),
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF9AE600),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // إدخال المنطقة
                    TextField(
                      cursorColor: const Color(0xFF9AE600),
                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: "Enter District",
                        hintStyle: const TextStyle(color: Color(0xFF00D492)),

                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF00B97B),
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF9AE600),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // خط OR
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.white24)),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "or",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        Expanded(child: Divider(color: Colors.white24)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // زر GPS
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9AE600),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        // تشغيل GPS
                        onPressed: openGPS,

                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),

                        label: const Text(
                          "Use Gps",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // زر البحث
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AE600),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BinsResultScreen(),
                      ),
                    );
                  },

                  child: const Text(
                    "Find Bins",
                    style: TextStyle(color: Colors.black, fontSize: 18),
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
