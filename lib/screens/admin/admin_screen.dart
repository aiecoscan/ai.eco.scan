import 'package:flutter/material.dart';
import 'package:eco_scan/screens/admin/manage_bins_screen.dart';

// ============================================================
// ADMINSCREEN.DART — Updated
// ============================================================
// Change: Added "Hive Inspector" button alongside existing ones.
// The inspector opens HiveInspectorScreen which lets the admin
// browse all stored data across every Hive box.
// ============================================================

import 'package:eco_scan/screens/admin/hive_inspector_screen.dart'; // NEW

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF013C2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Admin Screen",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 15),

              /// Welcome Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF014D3B),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Example: Long press on "Welcome Back, Admin"
                    GestureDetector(
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HiveInspectorScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Welcome Back, Admin",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.greenAccent.shade400,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// Buttons
              Row(
                children: [
                  Expanded(
                    child: adminButton(
                      context: context,
                      icon: Icons.delete,
                      title: "Manage Bins",
                      page: const ManageBinsScreen(), // الصفحة هنا
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: adminButton(
                      context: context,
                      icon: Icons.map,
                      title: "Geo Map",
                      page: const ManageBinsScreen(), // الصفحة هنا
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Statistics Title
              const Text(
                "Statistics",
                style: TextStyle(fontSize: 26, color: Colors.white),
              ),

              const SizedBox(height: 20),

              /// Statistics Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF075642),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: statCard(
                              title: "Points Redeemed",
                              value: "150K",
                              icon: Icons.eco,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: statCard(
                              title: "Total Users",
                              value: "5000",
                              icon: Icons.person,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: statCard(
                              title: "Recycle Rate",
                              value: "70%",
                              icon: Icons.recycling,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Admin Button
  // Updated adminButton with optional subtitle, fullWidth, and color params
  Widget adminButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget page,
    String? subtitle,
    bool fullWidth = false,
    Color color = const Color(0xFF0B6A52),
    Color accentColor = Colors.greenAccent,
  }) {
    final content = GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: Container(
        height: subtitle != null ? 80 : 120,
        width: fullWidth ? double.infinity : null,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: subtitle != null
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            if (subtitle != null) const SizedBox(width: 20),
            Icon(icon, size: 30, color: accentColor),
            if (subtitle != null) ...[
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: accentColor.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(width: 0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
    return content;
  }

  /// Statistics Card
  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFAED4A3),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(height: 5),
          Text("$title\n$value", textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
