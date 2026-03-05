// استيراد مكتبة Flutter الأساسية لبناء الواجهة
import 'package:flutter/material.dart';

// استيراد مكتبة اختيار الصور (كاميرا أو معرض)
import 'package:image_picker/image_picker.dart';

// استيراد مكتبة التعامل مع الملفات لأن الصورة ستُحفظ كملف
import 'dart:io';

// تعريف شاشة Scan Waste
// StatefulWidget لأننا سنغيّر الواجهة عند اختيار صورة
class ScanWasteScreen extends StatefulWidget {
  const ScanWasteScreen({super.key});

  @override
  State<ScanWasteScreen> createState() => _ScanWasteScreenState();
}

class _ScanWasteScreenState extends State<ScanWasteScreen> {
  // متغير سيحمل الصورة المختارة من الكاميرا أو المعرض
  File? image;

  // كائن من مكتبة image_picker لفتح الكاميرا أو المعرض
  final ImagePicker picker = ImagePicker();

  // دالة لفتح الكاميرا والتقاط صورة
  Future pickCamera() async {
    // فتح الكاميرا
    final XFile? picked = await picker.pickImage(source: ImageSource.camera);

    // إذا التقط المستخدم صورة
    if (picked != null) {
      // تحديث الواجهة بالصورة الجديدة
      setState(() {
        image = File(picked.path);
      });
    }
  }

  // دالة لاختيار صورة من المعرض
  Future pickGallery() async {
    // فتح معرض الصور
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    // إذا اختار المستخدم صورة
    if (picked != null) {
      // تحديث الواجهة بالصورة
      setState(() {
        image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // لون خلفية الشاشة
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
                "Scan Your Waste",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),

              const SizedBox(height: 10),

              // نص توضيحي للمستخدم
              const Text(
                "Please take a picture or upload one",
                style: TextStyle(color: Color(0xFF00D492)),
              ),

              const SizedBox(height: 40),

              // إطار عرض الصورة
              Center(
                child: Container(
                  width: 260,
                  height: 260,

                  decoration: BoxDecoration(
                    // إطار أخضر حول مكان الصورة
                    border: Border.all(
                      color: const Color(0xFF9AE600),
                      width: 3,
                    ),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  // إذا لم يتم اختيار صورة
                  child: image == null
                      // عرض أيقونة افتراضية
                      ? const Icon(
                          Icons.image,
                          size: 120,
                          color: Color(0xFF9AE600),
                        )
                      // إذا وُجدت صورة نعرضها داخل الإطار
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(image!, fit: BoxFit.cover),
                        ),
                ),
              ),

              const SizedBox(height: 40),

              // زر الكاميرا
              Center(
                child: GestureDetector(
                  // عند الضغط يتم تشغيل الكاميرا
                  onTap: pickCamera,

                  child: Container(
                    width: 80,
                    height: 80,

                    decoration: const BoxDecoration(
                      color: Color(0xFF9AE600),
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // كلمة or بين الخيارين
              const Center(
                child: Text("or", style: TextStyle(color: Colors.white)),
              ),

              const SizedBox(height: 20),

              // زر اختيار صورة من المعرض
              SizedBox(
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  // تصميم الزر
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AE600),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  // عند الضغط يفتح المعرض
                  onPressed: pickGallery,

                  child: const Text(
                    "Upload a Picture",
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
