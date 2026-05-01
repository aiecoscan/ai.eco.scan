import 'package:flutter/material.dart';
import 'package:eco_scan/services/bin_service.dart';
import 'package:eco_scan/models/bin_model.dart';

class BinReportsScreen extends StatefulWidget {
  const BinReportsScreen({super.key});
  @override
  State<BinReportsScreen> createState() => _BinReportsScreenState();
}

class _BinReportsScreenState extends State<BinReportsScreen> {
  List<BinModel> reportedBins = [];

  @override
  void initState() {
    super.initState();
    _loadBins();
  }

  void _loadBins() {
    setState(() {
      reportedBins = BinService.getReportedBins();
    });
  }

  void _changeStatus(String binId, bool makeActive) async {
    await BinService.updateBinStatus(binId, makeActive);
    _loadBins(); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF013C2E),
      appBar: AppBar(
        title: const Text("Bin Reports", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: reportedBins.length,
        itemBuilder: (context, index) {
          final bin = reportedBins[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0B6A52),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bin.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${bin.city}, ${bin.district}",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 5),
                Text(
                  "Reports: ${bin.reportCount}",
                  style: const TextStyle(color: Colors.orangeAccent),
                ),
                Text(
                  "Status: ${bin.isActive ? 'Active' : 'Out of Service'}",
                  style: TextStyle(
                    color: bin.isActive ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () => _changeStatus(bin.id, true),
                      child: const Text(
                        "Return to Service",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () => _changeStatus(bin.id, false),
                      child: const Text(
                        "Take Offline",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
