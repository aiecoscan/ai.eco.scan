import 'package:flutter/material.dart';
import 'bins_result_screen.dart';

// We removed the global TextEditingControllers and geolocator/url_launcher imports.

class LocateBinScreen extends StatefulWidget {
  const LocateBinScreen({super.key});

  @override
  State<LocateBinScreen> createState() => _LocateBinScreenState();
}

class _LocateBinScreenState extends State<LocateBinScreen> {
  // 1. State variables to hold the user's current selection
  String? selectedCity;
  String? selectedDistrict;

  // 2. The mock data mapping cities to their available districts
  final Map<String, List<String>> locations = {
    'Cairo': [
      'El Shorouk',
      'Obour',
      'Masaken',
      'Heliopolis',
      'Maadi',
      'Zamalek',
    ],
    'Giza': ['Dokki', 'Mohandiseen'],
    'Alexandria': ['Shatby', 'San Stefano', 'Sporting'],
    'New Cairo': ['Al Rehab', '5th Settlement', 'Madinaty'],
  };

  // 3. Simulated GPS Function
  void openGPS() {
    // Shows a message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("GPS Located you in New Cairo, 5th Settlement"),
        backgroundColor: Color(0xFF00B97B),
      ),
    );
    // Updates the dropdowns automatically
    setState(() {
      selectedCity = 'New Cairo';
      selectedDistrict = '5th Settlement';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C20),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF9AE600)),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              const Text(
                "Locate Recycling Bin",
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              const SizedBox(height: 30),

              // Main Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF004D38),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Where are you?",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 15),

                    // =========================
                    // CITY DROPDOWN
                    // =========================
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF004D38),
                      value: selectedCity,
                      hint: const Text(
                        "Select City",
                        style: TextStyle(color: Color(0xFF00D492)),
                      ),
                      // Generate items from the keys of our map
                      items: locations.keys.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(
                            city,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCity = val;
                          // CRITICAL: Reset district when city changes so we don't have a mismatch
                          selectedDistrict = null;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF002C20),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF00B97B),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF9AE600),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // =========================
                    // DISTRICT DROPDOWN
                    // =========================
                    DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF004D38),
                      value: selectedDistrict,
                      hint: const Text(
                        "Select District",
                        style: TextStyle(color: Color(0xFF00D492)),
                      ),
                      // Generate items based on the selected city. If no city is selected, show empty list.
                      items: selectedCity == null
                          ? []
                          : locations[selectedCity]!.map((dist) {
                              return DropdownMenuItem(
                                value: dist,
                                child: Text(
                                  dist,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedDistrict = val;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF002C20),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF00B97B),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF9AE600),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.white24)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "or",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.white24)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // GPS BUTTON
                    // =========================
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9AE600),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: openGPS,
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                        label: const Text(
                          "Use GPS (Mock)",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // =========================
              // FIND BINS BUTTON
              // =========================
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9AE600),
                  ),
                  onPressed: () {
                    // Prevent navigation if dropdowns are empty
                    if (selectedCity == null || selectedDistrict == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please select a City and District first",
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BinsResultScreen(
                          // Wrapping strings in TextEditingController to keep compatibility with BinsResultScreen
                          city: TextEditingController(text: selectedCity),
                          district: TextEditingController(
                            text: selectedDistrict,
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Find Bins",
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
