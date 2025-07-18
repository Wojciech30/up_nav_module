import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/building.dart';

class BuildingDetailsScreen extends StatelessWidget {
  final Building building;
  const BuildingDetailsScreen({super.key, required this.building});

  void _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void _launchEmail(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(building.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(building.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),

          // Telefony
          if (building.phones != null && building.phones!.isNotEmpty) ...[
            Text('Telefon:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...building.phones!.map(
                  (p) => GestureDetector(
                onTap: () => _launchPhone(p),
                child: Text(p, style: TextStyle(color: Colors.blue)),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // E-maile
          if (building.emails != null && building.emails!.isNotEmpty) ...[
            Text('E-mail:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...building.emails!.map(
                  (e) => GestureDetector(
                onTap: () => _launchEmail(e),
                child: Text(e, style: TextStyle(color: Colors.blue)),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Dostępność
          if (building.accessibility != null && building.accessibility!.isNotEmpty) ...[
            Text('Dostępność:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...building.accessibility!.map((a) => Text("• $a")),
            const SizedBox(height: 16),
          ],

          // Biura
          if (building.offices != null && building.offices!.isNotEmpty) ...[
            Text('Biura:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...building.offices!.map(
                  (office) => ExpansionTile(
                title: Text(office.name),
                children: [
                  if (office.roomNumber != null)
                    ListTile(
                      title: const Text('Numer pokoju'),
                      subtitle: Text(office.roomNumber!.toString()),
                    ),
                  if (office.contactPerson != null)
                    ListTile(
                      title: const Text('Osoba odpowiedzialna'),
                      subtitle: Text(office.contactPerson!),
                    ),
                  if (office.phones != null && office.phones!.isNotEmpty)
                    ListTile(
                      title: const Text('Telefon'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: office.phones!
                            .map((p) => GestureDetector(
                          onTap: () => _launchPhone(p),
                          child: Text(p, style: TextStyle(color: Colors.blue)),
                        ))
                            .toList(),
                      ),
                    ),
                  if (office.emails != null && office.emails!.isNotEmpty)
                    ListTile(
                      title: const Text('E-mail'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: office.emails!
                            .map((e) => GestureDetector(
                          onTap: () => _launchEmail(e),
                          child: Text(e, style: TextStyle(color: Colors.blue)),
                        ))
                            .toList(),
                      ),
                    ),
                  ListTile(
                    title: const Text('Godziny otwarcia'),
                    subtitle: Text(office.openingHours),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
