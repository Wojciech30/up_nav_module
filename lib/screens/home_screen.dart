import 'package:flutter/material.dart';
import '../data/buildings_data.dart';
import '../models/building.dart';
import '../widgets/building_list_item.dart';
import 'building_details_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Building> _allBuildings = BuildingsData.buildings;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.toLowerCase();

    List<Building> filteredBuildings = _allBuildings.where((building) {
      final matchesName = building.name.toLowerCase().contains(query);
      final matchesDescription = building.description.toLowerCase().contains(query);

      final matchesOffice = building.offices?.any((office) =>
          office.name.toLowerCase().contains(query)) ?? false;

      return matchesName || matchesDescription || matchesOffice;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nawigacja UP'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Wyszukaj budynek lub miejsce...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBuildings.length,
              itemBuilder: (context, index) {
                final building = filteredBuildings[index];
                return BuildingListItem(
                  building: building,
                  onMapTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapScreen(building: building),
                      ),
                    );
                  },
                  onInfoTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BuildingDetailsScreen(building: building),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
