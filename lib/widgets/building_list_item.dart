import 'package:flutter/material.dart';
import '../models/building.dart';

class BuildingListItem extends StatelessWidget {
  final Building building;
  final VoidCallback onMapTap;
  final VoidCallback onInfoTap;

  const BuildingListItem({super.key, required this.building, required this.onMapTap, required this.onInfoTap,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(building.name),
      subtitle: Text(building.address),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.map, color: Colors.blue),
            onPressed: onMapTap,
            tooltip: 'Pokaż na mapie',
          ),
          IconButton(
            icon: const Icon(Icons.info, color: Colors.black87),
            onPressed: onInfoTap,
            tooltip: 'Szczegóły',
          ),
        ],
      ),
    );
  }
}
