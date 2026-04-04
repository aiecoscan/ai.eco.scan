import 'package:flutter/material.dart'; // استيراد مكتبة Flutter الأساسية لبناء الواجهة
import 'package:image_picker/image_picker.dart'; // استيراد مكتبة اختيار الصور (كاميرا أو معرض)
import 'dart:io'; // استيراد مكتبة التعامل مع الملفات لأن الصورة ستُحفظ كملف
import '../../services/classifier.dart'; // 1. Import your classifier file

// NEW: Import model and service
import 'package:eco_scan/models/user_model.dart';
import 'package:eco_scan/services/scan_service.dart';

// ============================================================
// SCAN_WASTE_SCREEN.DART — Updated
// ============================================================
// Change: 65% confidence threshold enforced.
//
// The classifier returns a score between 0.0 and 1.0.
// ScanService.saveScan() now returns NULL if score < 0.65,
// meaning the detection was not confident enough to count.
//
// UI states:
//   "Analyzing..."         → while model runs
//   "PLASTIC" / "METAL"   → confident detection (≥65%), saved, points awarded
//   "Not Confident Enough" → score exists but < 65%, not saved
//   "No Waste Detected"    → model found nothing (score near 0)
//   "Error"                → classifier failed
// ============================================================

class ScanWasteScreen extends StatefulWidget {
  // StatefulWidget لأننا سنغيّر الواجهة عند اختيار صورة
  // NEW: Accept user so we can attach scans to them
  final UserModel user;
  const ScanWasteScreen({super.key, required this.user});

  @override
  State<ScanWasteScreen> createState() => _ScanWasteScreenState();
}

class _ScanWasteScreenState extends State<ScanWasteScreen> {
  File? image; // متغير سيحمل الصورة المختارة من الكاميرا أو المعرض
  final ImagePicker picker =
      ImagePicker(); // كائن من مكتبة image_picker لفتح الكاميرا أو المعرض

  //Here start the local AI model
  final Classifier _classifier =
      Classifier(); // 2. Create an instance of the Classifier and a variable for the result text
  String _resultText = "Please take a picture or upload one";

  // NEW: Track points earned from this scan to show in UI
  int? _pointsEarned;
  bool _isLowConf = false; // true when detected but < 65%
  double? _lastScore; // stored to show the actual % in UI

  @override
  void initState() {
    super.initState();
    _classifier.init(); // 3. Initialize the model when the screen loads
  }

  // CHANGED: Now saves to Hive via ScanService after classification
  Future<void> _runClassification(File imageFile) async {
    // Helper function to run classification and update UI
    setState(() {
      _resultText = "Analyzing...";
      _pointsEarned = null; // Clear previous points display
      _isLowConf = false;
      _lastScore = null;
    });

    // Step 1: Run the AI classifier — same as before
    final result = await _classifier.classify(imageFile);
    final label = result['label'] as String;
    final score = result['score'] as double;

    // Step 2: // Case 1: classifier itself returned "no detection" or error
    if (label == 'No Waste Detected' || label == 'Error') {
      setState(() {
        _resultText = label;
        _pointsEarned = null;
        _isLowConf = false;
      });
      return;
    }

    // Case 2: something was detected — now check confidence threshold
    // ScanService.saveScan() returns null if score < 0.65
    final savedScan = await ScanService.saveScan(
      userId: widget.user.id,
      wasteType: label,
      confidence: score,
      imagePath: imageFile.path,
    );

    if (savedScan == null) {
      // Score was below 65% — detected something but not confident enough
      setState(() {
        _resultText = label; // still show what it THINKS it is
        _pointsEarned = null;
        _isLowConf = true;
        _lastScore = score;
      });
    } else {
      // Clean confident detection — saved and points awarded
      setState(() {
        _resultText = label;
        _pointsEarned = savedScan.pointsEarned;
        _isLowConf = false;
        _lastScore = score;
      });
    }
  } //Here end the Local AI

  Future<void> pickCamera() async {
    // دالة لفتح الكاميرا والتقاط صورة
    final XFile? picked = await picker.pickImage(
      source: ImageSource.camera,
    ); // فتح الكاميرا
    if (picked != null) {
      // إذا التقط المستخدم صورة
      setState(() {
        // تحديث الواجهة بالصورة الجديدة
        image = File(picked.path);
      });
      await _runClassification(image!); // 4. Run classification after picking
    }
  }

  Future<void> pickGallery() async {
    // دالة لاختيار صورة من المعرض
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
    ); // فتح معرض الصور
    if (picked != null) {
      // إذا اختار المستخدم صورة
      setState(() {
        // تحديث الواجهة بالصورة
        image = File(picked.path);
      });
      await _runClassification(image!); // 5. Run classification after picking
    }
  }

  @override
  void dispose() {
    _classifier
        .dispose(); // 6. Clean up the interpreter when leaving the screen
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C20), // لون خلفية الشاشة
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                // زر الرجوع للشاشة السابقة
                icon: const Icon(Icons.arrow_back, color: Color(0xFF9AE600)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),

              const Text(
                // عنوان الصفحة
                "Scan Your Waste",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),

              const SizedBox(height: 30),

              Center(
                // نص توضيحي للمستخدم
                child: Text(
                  _isLowConf
                      ? "It may be $_resultText"
                      : _resultText, //"Please take a picture or upload one",
                  style: TextStyle(color: Color(0xFF00D492), fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),

              // ── Low confidence warning ───────────────────
              // Shows when something was detected but score < 65%
              if (_isLowConf && _lastScore != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        //'Low confidence: ${(_lastScore! * 100).toStringAsFixed(0)}%\n'
                        //'Minimum required: 65% — not saved.',
                        "The picture is not clear so the result might be wrong\n"
                        "If so, Please try again with a more clear picture.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),

              // NEW: Points earned display — only shows after a successful scan
              // ── Points earned badge ──────────────────────
              if (_pointsEarned != null && !_isLowConf)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+$_pointsEarned pts earned!',
                          style: const TextStyle(
                            color: Color(0xFF9AE600),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('🌱', style: TextStyle(fontSize: 18)),
                        if (_lastScore != null) ...[
                          const SizedBox(width: 10),
                          Text(
                            "", //'${(_lastScore! * 100).toStringAsFixed(0)}% confident',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              Center(
                // إطار عرض الصورة
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(
                      // إطار أخضر حول مكان الصورة
                      color: _isLowConf
                          ? Colors.orange
                          : const Color(0xFF9AE600),
                      width: 3,
                    ),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child:
                      image ==
                          null // إذا لم يتم اختيار صورة
                      ? const Icon(
                          // عرض أيقونة افتراضية
                          Icons.image,
                          size: 120,
                          color: Color(0xFF9AE600),
                        )
                      : ClipRRect(
                          // إذا وُجدت صورة نعرضها داخل الإطار
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(image!, fit: BoxFit.cover),
                        ),
                ),
              ),

              const SizedBox(height: 40),

              Center(
                // زر الكاميرا
                child: GestureDetector(
                  onTap: pickCamera, // عند الضغط يتم تشغيل الكاميرا
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

              const SizedBox(height: 15),

              const Center(
                // كلمة or بين الخيارين
                child: Text(
                  "or",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                // زر اختيار صورة من المعرض
                width: double.infinity,
                height: 60,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // تصميم الزر
                    backgroundColor: const Color(0xFF9AE600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: pickGallery, // عند الضغط يفتح المعرض
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
