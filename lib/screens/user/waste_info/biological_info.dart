// استيراد مكتبة Flutter لبناء الواجهة
import 'package:flutter/material.dart';

// إنشاء شاشة معلومات النفايات البيولوجية
class BiologicalInfo extends StatelessWidget {
  const BiologicalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold هو الهيكل الأساسي للشاشة
    return Scaffold(
      // لون خلفية الصفحة
      backgroundColor: const Color(0xFF002C20),

      body: SafeArea(
        // يسمح بالتمرير إذا كان المحتوى طويل
        child: SingleChildScrollView(
          child: Padding(
            // مسافة حول المحتوى
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
                  "Biological",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),

                const SizedBox(height: 25),

                // عنوان القسم الأول
                const Text(
                  "Recycle Advantages",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),

                const SizedBox(height: 15),

                // صندوق المميزات
                infoBox([
                  "Creates Compost for Soil Enrichment",
                  "Reduces Greenhouse Gas Emissions",
                  "Prevents Environmental Contamination",
                  "Recovers Valuable Materials",
                ]),

                const SizedBox(height: 30),

                // عنوان القسم الثاني
                const Text(
                  "Usage",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),

                const SizedBox(height: 15),

                // صندوق الاستخدامات
                infoBox([
                  "Bio-gas Generation",
                  "Eco-Packaging Materials",
                  "Safe Disposal and Energy Recovery",
                  "Reprocessing of Containers",
                ]),

                const SizedBox(height: 30),

                // عنوان القسم الثالث
                const Text(
                  "Items",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),

                const SizedBox(height: 15),

                // صندوق العناصر
                infoBox([
                  "Fruit and Vegetable Peels",
                  "Grass clippings and leaves",
                  "Coffee grounds and eggshells",
                  "Empty glass reagent bottles",
                  "Plastic pipette tips (after sterilization)",
                  "Expired medications (via pharmaceutical take-back programs)",
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget لصندوق المعلومات الأخضر
  Widget infoBox(List<String> items) {
    return Container(
      // المسافة داخل الصندوق
      padding: const EdgeInsets.all(20),

      // تصميم الصندوق
      decoration: BoxDecoration(
        color: const Color(0xFF005A45),
        borderRadius: BorderRadius.circular(20),
      ),

      // عرض العناصر داخل الصندوق
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: items.map((text) {
          // تحويل كل عنصر إلى نص
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),

            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF00D492), fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
