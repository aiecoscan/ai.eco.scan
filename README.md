# 🌍 EcoScan - Smart Recycling Companion

**EcoScan** is a modern, beautiful, and fully functional Flutter mobile app that makes recycling **easy, rewarding, and impactful**. Whether you're a regular user or an occasional visitor, the app helps you scan waste, find the nearest recycling bins, learn about proper recycling, and track your environmental contribution through a **Green Points** system.

Built with **Flutter** for Android, featuring **local AI** (no internet required for classification) and **Hive** for fast offline-first local storage.

---

## ✨ Key Features

### 🔍 **For Users**
- **AI Waste Scanner**  
  Take a photo or upload an image → **local TensorFlow Lite model** instantly classifies the waste (Plastic, Metal.
- **Smart Bin Locator**  
  Search by city/district or use **GPS**. View nearby bins with status (Active/Inactive), distance, and one-tap **Google Maps** directions.
- **Learn About Recycling**  
  Detailed educational cards for **Plastic, Paper, Glass, and Biological** waste including:
  - Advantages
  - Real-world usage
  - Common recyclable items
- **Green Points System**  
  Earn points for every recycled item. Track your monthly impact (kg recycled + times recycled) and view full history.
- **Beautiful & Intuitive UI**  
  Dark green eco-themed design with smooth navigation and animations.

### 👷‍♂️ **For Admins**
- **Admin Dashboard** with welcome card and quick stats:
  - Points Redeemed
  - Total Users
  - Recycle Rate
- **Manage Bins** (Cairo → Districts → Specific bins)
- Full control over bin status and locations (Obour, Maadi, Zamalek, etc.)

### 🔐 **Authentication**
- Login / Sign Up
- Forgot Password + OTP Verification Screen
- Change Password

---

## 🛠️ Tech Stack

- **Framework**: Flutter (Dart)
- **AI Model**: TensorFlow Lite (`tflite_flutter`) – **fully offline**
- **Local Storage**: **Hive** (lightweight, fast NoSQL database for offline persistence of points, history, user data, etc.)
- **Location & Maps**: `geolocator` + `url_launcher` (Google Maps integration)
- **Image Handling**: `image_picker` + `image` package
- **State Management**: `setState` (simple & clean – ready for Riverpod/Bloc upgrade)
- **Icons & Assets**: Custom eco-themed icons and fonts (Economica)

---

## 🧩 Project Structure Highlights

```
lib/
|   main.dart
|   splash_screen.dart
|
+---constants
|       colors.dart
|
+---login
|       change_password_screen.dart
|       forgot_password_screen.dart
|       login.dart
|       signup.dart
|       verify_screen.dart
|
+---models
+---screens
|   +---admin
|   |   |   admin_screen.dart
|   |   |   manage_bins_screen.dart
|   |   |
|   |   \---gov
|   |       |   cairo.dart
|   |       |
|   |       \---cities
|   |           |   obour.dart
|   |           |
|   |           \---bin_locations
|   |                   golf_city_mall.dart
|   |
|   \---user
|       |   bins_result_screen.dart
|       |   green_points_screen.dart
|       |   home_screen.dart
|       |   learn_recycle_screen.dart
|       |   locate_bin_screen.dart
|       |   scan_waste_screen.dart
|       |
|       +---bin_details
|       |       elsalam_screen.dart
|       |       elshrok_screen.dart
|       |       golf_city_screen.dart
|       |       sun_city_screen.dart
|       |
|       \---waste_info
|               biological_info.dart
|               glass_info.dart
|               paper_info.dart
|               plastic_info.dart
|
\---services
        classifier.dart
```

---

## 🔮 Future Enhancements (Planned)

- Hive-based user profiles & saved bins
- Cloud sync (Firebase/Supabase)
- Reward redemption system
- Multi-language support
- Leaderboard & community challenges
- Dark/Light theme toggle

---

## 📄 License

This project is licensed under the **MIT License** – feel free to use, modify, and contribute!

---

## ❤️ Made with Love for the Planet

**EcoScan** – Turning trash into impact, one scan at a time.

If you like the project, please **⭐ star** the repo and share it with friends who care about the environment!

---

**Happy Recycling!** ♻️🌱
