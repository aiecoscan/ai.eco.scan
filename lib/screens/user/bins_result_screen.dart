import 'package:eco_scan/screens/user/bin_detail_screen.dart';
import 'package:flutter/material.dart';
import '/services/bin_service.dart';
import '/models/bin_model.dart';

class BinsResultScreen extends StatefulWidget {
  final TextEditingController city;
  final TextEditingController district;

  const BinsResultScreen({
    super.key,
    required this.city,
    required this.district,
  });

  @override
  State<BinsResultScreen> createState() => _BinsResultScreenState();
}

class _BinsResultScreenState extends State<BinsResultScreen> {
  List<BinModel> foundBins = [];

  @override
  void initState() {
    super.initState();
    _loadBins();
  }

  void _loadBins() {
    // This calls your BinService and filters by the controllers passed
    setState(() {
      foundBins = BinService.getBinsByLocation(
        widget.city.text,
        widget.district.text,
      );
    });
  }

  void _handleReport(String id) async {
    await BinService.reportBin(id);
    _loadBins(); // Refresh list to show if bin became inactive
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Problem Reported!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002C20),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF9AE600)),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
              Text(
                "${widget.city.text}, ${widget.district.text}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Found ${foundBins.length} Bins",
                style: const TextStyle(color: Color(0xFF00D492), fontSize: 16),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: foundBins.isEmpty
                    ? const Center(
                        child: Text(
                          "No Bins found in this area",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: foundBins.length,
                        itemBuilder: (context, index) {
                          final bin = foundBins[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BinDetailScreen(
                                    bin: bin,
                                  ), // Pass the bin object here
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF005A45),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Color(0xFF9AE600),
                                    size: 30,
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bin.name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          bin.isActive
                                              ? "Status: Active"
                                              : "Status: Out of Service",
                                          style: TextStyle(
                                            color: bin.isActive
                                                ? Colors.greenAccent
                                                : Colors.redAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.report_problem,
                                      color: Colors.orange,
                                    ),
                                    onPressed: () => _handleReport(bin.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
