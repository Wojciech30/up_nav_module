import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:up_nav_module/models/building.dart';
import 'package:up_nav_module/models/office.dart';

abstract class BuildingsRepository {
  Future<List<Building>> getAll();
}

class FirebaseBuildingsRepository implements BuildingsRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Future<List<Building>> getAll() async {
    final snap = await _db.collection('buildings').get();
    return snap.docs.map((d) => _fromMap(d.data())).toList();
  }

  Building _fromMap(Map<String, dynamic> m) {
    final offices = ((m['offices'] ?? []) as List)
        .map((o) => Office(
      name: o['name'] ?? '',
      roomNumber: o['roomNumber'] ?? '',
      contactPerson: o['contactPerson'],
      phones: (o['phones'] as List?)?.cast<String>(),
      emails: (o['emails'] as List?)?.cast<String>(),
      openingHours: o['openingHours'] ?? '',
    ))
        .toList();

    return Building(
      name: m['name'] ?? '',
      address: m['address'] ?? '',
      description: m['description'] ?? '',
      phones: (m['phones'] as List?)?.cast<String>(),
      emails: (m['emails'] as List?)?.cast<String>(),
      accessibility: (m['accessibility'] as List?)?.cast<String>(),
      offices: offices,
      latitude: (m['latitude'] as num).toDouble(),
      longitude: (m['longitude'] as num).toDouble(),
      imageUrl: m['imageUrl'],
    );
  }
}
