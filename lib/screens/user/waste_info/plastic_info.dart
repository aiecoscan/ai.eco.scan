import 'package:flutter/material.dart';

class PlasticInfo extends StatelessWidget {
  const PlasticInfo({super.key});

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
                  "Plastic",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),

                const SizedBox(height: 25),

                // عنوان القسم
                const Text(
                  "Recycle Advantages",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),

                const SizedBox(height: 15),

                // صندوق المميزات
                infoBox([
                  "Cuts Down on Plastic Production",
                  "Protects Oceans from Plastic Pollution",
                  "Enables Circular Use of Durable Material",
                  "Supports Innovation in Sustainable Materials",
                ]),

                const SizedBox(height: 30),

                const Text(
                  "Usage",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),

                const SizedBox(height: 15),

                // صندوق الاستخدامات
                infoBox([
                  "New Packaging Products",
                  "Textiles and Clothing",
                  "Outdoor Furniture and Construction Materials",
                  "Eco-Bricks and Building Blocks",
                ]),

                const SizedBox(height: 30),

                const Text(
                  "Items",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),

                const SizedBox(height: 15),

                // صندوق العناصر
                infoBox([
                  "Plastic Bottles e.g. Water, soda, & juice bottles",
                  "Detergent and Shampoo Containers",
                  "Yogurt Cups and Food Tubs",
                  "Plastic Packaging Trays",
                  "Plastic Shopping Bags",
                  "Disposable Cutlery and Plates",
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget لصندوق المعلومات
  Widget infoBox(List<String> items) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFF005A45),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: items.map((text) {
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
