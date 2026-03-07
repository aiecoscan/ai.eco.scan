import 'package:flutter/material.dart';

class ObourBinsScreen extends StatelessWidget {
  const ObourBinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF013C2E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [

              const SizedBox(height: 15),

              /// Back Button
              Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
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
  ],
),

              const SizedBox(height: 10),

              /// Title
              const Text(
                "Cairo, Obour - Bins",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 5),

              const Text(
                "Found 3 Recycling Bins",
                style: TextStyle(color: Colors.greenAccent),
              ),

              const SizedBox(height: 25),

              /// Statistics Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFAED1B3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    const Text(
                      "The Bins of Obour have an approximate total of waste equivalent to",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.recycling, size: 30),
                        SizedBox(width: 10),
                        Text(
                          "15kg Plastic",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const Divider(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.eco, size: 30),
                        SizedBox(width: 10),
                        Text(
                          "10kg Organic",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// Locations
              binLocation(
                title: "Future City LRT",
                subtitle: "El Shorouk",
                distance: "0.8 km away",
                active: true,
              ),

              const SizedBox(height: 15),

              binLocation(
                title: "Golf City Mall",
                subtitle: "Entrance to Obour City",
                distance: "1.2 km away",
                active: true,
              ),

              const SizedBox(height: 15),

              binLocation(
                title: "El-Salam Bus Stop",
                subtitle: "Masaken Al Amireyah Al Ganoubeyah",
                distance: "1.8 km away",
                active: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bin Location Card
  Widget binLocation({
    required String title,
    required String subtitle,
    required String distance,
    required bool active,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B6A52),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          const Icon(Icons.location_on, color: Colors.greenAccent),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                Text(subtitle,
                    style: const TextStyle(color: Colors.white70)),
                Text(distance,
                    style: const TextStyle(color: Colors.greenAccent)),
              ],
            ),
          ),

          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: active ? Colors.greenAccent : Colors.red,
              ),
              const SizedBox(width: 5),
              Text(
                active ? "Active" : "Inactive",
                style: TextStyle(
                  color: active ? Colors.greenAccent : Colors.red,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}