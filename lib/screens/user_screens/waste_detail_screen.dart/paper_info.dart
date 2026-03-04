// استيراد مكتبة Flutter لبناء الواجهة
import 'package:flutter/material.dart';

// إنشاء شاشة معلومات الورق
class PaperInfo extends StatelessWidget {
  const PaperInfo({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold هو الهيكل الأساسي لأي شاشة
    return Scaffold(
      // لون خلفية الشاشة
      backgroundColor: const Color(0xFF002C20),

      body: SafeArea(
        // يسمح بعمل scroll إذا كان المحتوى كبير
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

                  // عند الضغط يرجع للصفحة السابقة
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 10),

                // عنوان الصفحة
                const Text(
                  "Paper",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),

                const SizedBox(height: 25),

                // عنوان القسم الأول
                const Text(
                  "Recycle Advantages",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),

                const SizedBox(height: 15),

                // صندوق يحتوي على المميزات
                infoBox([
                  "Saves Trees and Forests",
                  "Conserves Water and Energy",
                  "Reduces Landfill Waste",
                  "Supports Circular Economy",
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
                  "New Paper Products",
                  "Packaging Materials",
                  "Tissue and Hygiene Products",
                  "Insulation and Construction Fillers",
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
                  "Office Paper and Envelopes",
                  "Newspapers and Magazines",
                  "Cardboard Boxes and Cartons",
                  "Paper Bags and Wrapping Paper",
                  "Books and Notebooks",
                  "Paper Packaging from Food and Products",
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget مخصص لصندوق المعلومات الأخضر
  Widget infoBox(List<String> items) {
    return Container(
      // المسافة داخل الصندوق
      padding: const EdgeInsets.all(20),

      // تصميم الصندوق
      decoration: BoxDecoration(
        color: const Color(0xFF005A45),
        borderRadius: BorderRadius.circular(20),
      ),

      // عرض النصوص داخل الصندوق
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: items.map((text) {
          // كل عنصر من القائمة يتحول إلى Text
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),

            child: Text(
              text,

              // لون النص داخل الصندوق
              style: const TextStyle(color: Color(0xFF00D492), fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
