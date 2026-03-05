// استيراد مكتبة Flutter لبناء الواجهة
import 'package:flutter/material.dart';

// إنشاء شاشة معلومات الزجاج
class GlassInfo extends StatelessWidget {
  const GlassInfo({super.key});

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
                  "Glass",
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
                  "Preserves Raw Materials e.g. sand, ash, soda",
                  "Saves Energy",
                  "Infinitely Recyclable",
                  "Reduces Landfill Waste",
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
                  "New Glass Bottles and Jars",
                  "Glass Wool Insulation e.g. insulation for buildings",
                  "Construction Aggregate e.g. road surfacing",
                  "Decorative Tiles and Counter-tops",
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
                  "Glass Beverage Bottles e.g. Water, soda",
                  "Food Jars (jam, pickles, sauces)",
                  "Wine and Liquor Bottles",
                  "Perfume and Cosmetic Bottles",
                  "Glass Medicine Bottles",
                  "Clear and Colored Glass Containers",
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget خاص بصندوق المعلومات الأخضر
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
