import 'package:flutter/material.dart';
import 'package:eco_scan/constants/colors.dart';
import 'package:eco_scan/screens/admin/gov/cities/obour.dart';

class CairoBinsScreen extends StatelessWidget {
  const CairoBinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF013C2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// Back Button
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.greenAccent,
                  size: 28,
                ),
              ),

              const SizedBox(height: 10),

              /// Title
              const Text(
                "Manage Cairo Bins",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                "Total bins : 15",
                style: TextStyle(
                  fontSize: 26,
                  fontStyle: FontStyle.italic,
                  color: AppColors.font_color,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 35),

              /// Subtitle
              const Center(
                child: Text(
                  "Choose Your Dirstrict",
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              /// Cities
              cityCard(
                context: context,
                city: "Maadi",
                bins: "Bins: 8",
                page: const CairoBinsScreen(),
              ),
              const SizedBox(height: 18),

              cityCard(
                context: context,
                city: "Zamalek",
                bins: "Bins: 4",
                page: const CairoBinsScreen(),
              ),
              const SizedBox(height: 18),

              cityCard(
                context: context,
                city: "Obour",
                bins: "Bins: 3",
                page: const ObourBinsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// City Card
  Widget cityCard({
    required BuildContext context,
    required String city,
    required String bins,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF0B6A52),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              city,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              bins,
              style: const TextStyle(fontSize: 16, color: Colors.greenAccent),
            ),
          ],
        ),
      ),
    );
  }
}
