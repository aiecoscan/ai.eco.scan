import 'package:hive/hive.dart';
import '../models/bin_model.dart';

class BinService {
  static const String binBoxName = 'binBox';
  static Box<BinModel> get _box => Hive.box<BinModel>(binBoxName);

  static Future<void> initDummyData() async {
    if (!Hive.isBoxOpen(binBoxName)) {
      await Hive.openBox<BinModel>(binBoxName);
    }

    // Generate 15 dummy bins ONLY if the box is empty
    if (_box.isEmpty) {
      final dummyBins = [
        BinModel(
          id: '1',
          name: 'Future City LRT',
          city: 'Cairo',
          district: 'El Shorouk',
        ),
        BinModel(
          id: '2',
          name: 'Golf City Mall',
          city: 'Cairo',
          district: 'Obour',
        ),
        BinModel(
          id: '3',
          name: 'El-Salam Bus Stop',
          city: 'Cairo',
          district: 'Masaken',
          isActive: false,
        ),
        BinModel(
          id: '4',
          name: 'Sun City Mall',
          city: 'Cairo',
          district: 'Heliopolis',
        ),
        BinModel(
          id: '5',
          name: 'Maadi Grand Mall',
          city: 'Cairo',
          district: 'Maadi',
        ),
        BinModel(
          id: '6',
          name: 'Zamalek Club Bin',
          city: 'Cairo',
          district: 'Zamalek',
        ),
        BinModel(
          id: '7',
          name: 'Giza Square Bin',
          city: 'Giza',
          district: 'Dokki',
        ),
        BinModel(
          id: '8',
          name: 'Mohandiseen Hub',
          city: 'Giza',
          district: 'Mohandiseen',
        ),
        BinModel(
          id: '9',
          name: 'Alex Library Bin',
          city: 'Alexandria',
          district: 'Shatby',
        ),
        BinModel(
          id: '10',
          name: 'San Stefano Mall',
          city: 'Alexandria',
          district: 'San Stefano',
        ),
        BinModel(
          id: '11',
          name: 'Sporting Club Bin',
          city: 'Alexandria',
          district: 'Sporting',
        ),
        BinModel(
          id: '12',
          name: 'Rehab City Walk',
          city: 'New Cairo',
          district: 'Al Rehab',
        ),
        BinModel(
          id: '13',
          name: 'CFC Mall Bin',
          city: 'New Cairo',
          district: '5th Settlement',
        ),
        BinModel(
          id: '14',
          name: 'Waterway Bin',
          city: 'New Cairo',
          district: '5th Settlement',
        ),
        BinModel(
          id: '15',
          name: 'Madinaty Open Air',
          city: 'New Cairo',
          district: 'Madinaty',
        ),
      ];
      for (var bin in dummyBins) {
        await _box.put(bin.id, bin);
      }
    }
  }

  // Gets bins by location
  static List<BinModel> getBinsByLocation(String city, String district) {
    return _box.values
        .where((b) => b.city == city && b.district == district)
        .toList();
  }

  // Gets all bins that have reports OR are inactive
  static List<BinModel> getReportedBins() {
    return _box.values.where((b) => b.reportCount > 0 || !b.isActive).toList();
  }

  // Report a bin (Request 1.4)
  static Future<void> reportBin(String binId) async {
    final bin = _box.get(binId);
    if (bin != null) {
      bin.reportCount += 1;
      // If 2 or more users report it, toggle it inactive!
      if (bin.reportCount >= 2) {
        bin.isActive = false;
      }
      await bin.save();
    }
  }

  // Admin resets the bin (Request 4)
  static Future<void> updateBinStatus(String binId, bool makeActive) async {
    final bin = _box.get(binId);
    if (bin != null) {
      bin.isActive = makeActive;
      if (makeActive)
        bin.reportCount = 0; // Reset reports if put back in service
      await bin.save();
    }
  }
}
