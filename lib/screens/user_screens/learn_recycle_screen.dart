// استيراد مكتبة Flutter لبناء الواجهة
import 'package:flutter/material.dart';

// لاسترداد صفحة plastic info
import './waste_detail_screen.dart/plastic_info.dart';

// لاسترداد صفحة paper info
import './waste_detail_screen.dart/paper_info.dart';

// لاسترداد صفحة glass info
import './waste_detail_screen.dart/glass_info.dart';

// لاسترداد صفحة biological info
import './waste_detail_screen.dart/biological_info.dart';

// تعريف شاشة معلومات إعادة التدوير
class LearnRecycleScreen extends StatelessWidget {
  const LearnRecycleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون الخلفية الأساسي للشاشة
      backgroundColor: const Color(0xFF002C20),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // زر الرجوع للشاشة السابقة
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF9AE600)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),

              // عنوان الصفحة
              const Text(
                "Recycle Info",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),

              const SizedBox(height: 25),

              // بطاقة الفيديو (حاليًا مجرد شكل)
              Container(
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: const Color(0xFFB8D7A3),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Why to Recycle?",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),

                    const SizedBox(height: 12),

                    // مكان الفيديو
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: const Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // عنوان القسم
              const Text(
                "Waste Types",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),

              const SizedBox(height: 20),

              // شبكة أنواع النفايات
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,

                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PlasticInfo(),
                          ),
                        );
                      },

                      child: const WasteTypeBox(
                        icon: Icons.local_drink,
                        title: "Plastics",
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaperInfo(),
                          ),
                        );
                      },

                      child: const WasteTypeBox(
                        icon: Icons.description,
                        title: "Paper",
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GlassInfo(),
                          ),
                        );
                      },

                      child: const WasteTypeBox(
                        icon: Icons.wine_bar,
                        title: "Glass",
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BiologicalInfo(),
                          ),
                        );
                      },

                      child: const WasteTypeBox(
                        icon: Icons.biotech,
                        title: "Biological",
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

// Widget مخصص لمربعات أنواع النفايات
class WasteTypeBox extends StatelessWidget {
  final IconData icon;
  final String title;

  const WasteTypeBox({super.key, required this.icon, required this.title});

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
          Icon(icon, size: 45, color: const Color(0xFF9AE600)),

          const SizedBox(height: 10),

          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
