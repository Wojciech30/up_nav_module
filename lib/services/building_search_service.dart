import 'package:up_nav_module/models/building.dart';

class BuildingSearchService {
  static List<Building> filter(List<Building> all, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;

    return all.where((b) {
      final inName = b.name.toLowerCase().contains(q);
      final inAddress = b.address.toLowerCase().contains(q);
      final inOffices = (b.offices ?? [])
          .any((o) => o.name.toLowerCase().contains(q));
      return inName || inAddress || inOffices;
    }).toList();
  }
}
