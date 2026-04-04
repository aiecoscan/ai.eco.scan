import 'package:flutter/material.dart';
import 'package:eco_scan/splash_screen.dart';

// NEW: Import Hive initialization
import 'package:eco_scan/models/hive_init.dart';

void main() async {
  // NEW: These two lines are required before any async work in main()
  // WidgetsFlutterBinding ensures Flutter is ready before we do async ops
  WidgetsFlutterBinding.ensureInitialized();

  // NEW: Initialize Hive — opens all boxes, registers all adapters
  // This must happen before runApp() so services work immediately
  await HiveInit.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Economica'),
      home: const Homescreen(),
    );
  }
}
