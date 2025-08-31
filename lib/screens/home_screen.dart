import 'package:flutter/material.dart';
import 'package:up_nav_module/models/building.dart';
import 'package:up_nav_module/screens/building_details_screen.dart';
import 'package:up_nav_module/data/buildings_repository.dart';
import 'package:up_nav_module/widgets/building_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BuildingsRepository _repo = FirebaseBuildingsRepository();

  List<Building> _all = [];
  List<Building> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await _repo.getAll();
      setState(() {
        _all = data;
        _filtered = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd ładowania danych: $e')),
      );
    }
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _filtered = _all);
      return;
    }
    setState(() {
      _filtered = _all.where((b) {
        final inName = b.name.toLowerCase().contains(q);
        final inAddress = b.address.toLowerCase().contains(q);
        final inOffices = (b.offices ?? [])
            .any((o) => o.name.toLowerCase().contains(q));
        return inName || inAddress || inOffices;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nawigacja UP')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Szukaj budynku, adresu, biura…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                ? const Center(child: Text('Brak wyników'))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final b = _filtered[index];
                return BuildingListItem(
                  building: b,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            BuildingDetailsScreen(building: b),
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
