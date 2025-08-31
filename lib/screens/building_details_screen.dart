import 'package:flutter/material.dart';
import 'package:up_nav_module/models/building.dart';
import 'package:up_nav_module/models/office.dart';
import 'package:up_nav_module/screens/map_screen.dart';
import 'package:up_nav_module/utils/contact_launcher.dart';
import 'package:up_nav_module/widgets/building_image.dart';

class BuildingDetailsScreen extends StatelessWidget {
  final Building building;

  const BuildingDetailsScreen({super.key, required this.building});

  @override
  Widget build(BuildContext context) {
    final hasImage =
    (building.imageUrl != null && building.imageUrl!.isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: Text(building.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.place),
            tooltip: 'Pokaż na mapie',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapScreen(building: building),
                ),
              );
            },
          )
        ],
      ),
      body: ListView(
        children: [
          if (hasImage)
            BuildingImage(
              imageUrl: building.imageUrl,
              width: double.infinity,
              height: 220,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(16)),
              fit: BoxFit.cover,
            )
          else
            BuildingImage(
              imageUrl: null,
              width: double.infinity,
              height: 220,
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(16)),
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(building.name,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        building.address,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                if (building.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    building.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                if ((building.accessibility ?? []).isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Dostępność',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  for (final feature in building.accessibility!)
                    Row(
                      children: [
                        const Icon(Icons.check, size: 20),
                        const SizedBox(width: 6),
                        Text(feature),
                      ],
                    ),
                ],
                if ((building.offices ?? []).isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Biura', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  for (final Office office in building.offices!)
                    ExpansionTile(
                      title: Text(office.name),
                      children: [
                        if ((office.contactPerson ?? '').isNotEmpty)
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(office.contactPerson!),
                          ),
                        if ((office.phones ?? []).isNotEmpty)
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: Text(office.phones!.first),
                            onTap: () => ContactLauncher.phone(
                              office.phones!.first,
                            ),
                          ),
                        if ((office.emails ?? []).isNotEmpty)
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: Text(office.emails!.first),
                            onTap: () => ContactLauncher.email(
                              office.emails!.first,
                            ),
                          ),
                        if (office.openingHours.isNotEmpty)
                          ListTile(
                            leading: const Icon(Icons.access_time),
                            title: Text(office.openingHours),
                          ),
                      ],
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
