import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:up_nav_module/models/building.dart';
import 'package:up_nav_module/models/navigation_step.dart';
import 'package:up_nav_module/services/navigation_service.dart';
import 'package:up_nav_module/widgets/navigation_hud.dart';
import 'package:up_nav_module/widgets/navigation_bottom_bar.dart';
import 'package:up_nav_module/widgets/university_map.dart';

class MapScreen extends StatefulWidget {
  final Building building;
  const MapScreen({super.key, required this.building});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
  );

  final NavigationService _nav = NavigationService();
  StreamSubscription<NavigationState>? _navSub;

  List<NavigationStep> _steps = [];
  int _currentIndex = 0;
  double _distance = 0; // km
  double _duration = 0; // min
  bool _navigating = false;
  bool _showBottomBar = false;
  bool _showHud = false;

  bool _followHeading = false; // false=North-up, true=Follow heading
  StreamSubscription<CompassEvent>? _compassSub;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _nav.ensureDestinationMarker(
        mapController: _mapController,
        building: widget.building,
      );
      await _mapController.rotateMapCamera(0);
    });

    _navSub = _nav.state$.listen((s) {
      setState(() {
        _navigating = s.navigating;
        _steps = s.steps;
        _currentIndex = s.currentIndex;
        _distance = s.distanceKm;
        _duration = s.durationMin;
        _showHud = _navigating && _steps.isNotEmpty;
        _showBottomBar = _navigating;
      });
    });
  }

  @override
  void dispose() {
    _navSub?.cancel();
    _compassSub?.cancel();
    _nav.dispose();
    super.dispose();
  }

  void _chooseNavigationMode() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.directions_walk),
                title: const Text("Pieszo"),
                onTap: () {
                  Navigator.pop(context);
                  _nav.start(
                    mapController: _mapController,
                    destination: widget.building,
                    mode: RoadType.foot,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_bike),
                title: const Text("Rower"),
                onTap: () {
                  Navigator.pop(context);
                  _nav.start(
                    mapController: _mapController,
                    destination: widget.building,
                    mode: RoadType.bike,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.directions_car),
                title: const Text("Samochód"),
                onTap: () {
                  Navigator.pop(context);
                  _nav.start(
                    mapController: _mapController,
                    destination: widget.building,
                    mode: RoadType.car,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _stopNavigation() => _nav.stop(mapController: _mapController);

  Future<void> _centerOnUser() => _nav.centerOnUser(mapController: _mapController);

  Future<void> _toggleOrientation() async {
    setState(() => _followHeading = !_followHeading);

    if (_followHeading) {
      _compassSub?.cancel();
      _compassSub = FlutterCompass.events?.listen((event) async {
        final h = event.heading;
        if (h != null) {
          await _mapController.rotateMapCamera(h);
        }
      });
    } else {
      await _compassSub?.cancel();
      _compassSub = null;
      await _mapController.rotateMapCamera(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    const double bottomBarHeight = 72;
    final double safeBottom = MediaQuery.of(context).padding.bottom;

    final double fabBottomOffset =
    _showBottomBar ? (bottomBarHeight + 24) : (24 + safeBottom);

    return Scaffold(
      body: Stack(
        children: [
          UniversityMap(controller: _mapController),

          if (_showHud && _steps.isNotEmpty)
            Positioned(
              top: 16 + MediaQuery.of(context).padding.top,
              left: 16,
              right: 16,
              child: NavigationHud(
                instruction: _steps[_currentIndex].instruction,
              ),
            ),

          Positioned(
            top: (16 + MediaQuery.of(context).padding.top) + 64 + 12,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              heroTag: "orientation",
              onPressed: _toggleOrientation,
              tooltip: _followHeading
                  ? 'Orientacja: kierunek jazdy'
                  : 'Orientacja: na północ',
              child: Icon(_followHeading ? Icons.explore_off : Icons.explore),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _showBottomBar
                    ? NavigationBottomBar(
                  distance: _distance,
                  duration: _duration,
                )
                    : const SizedBox.shrink(),
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: fabBottomOffset,
            child: _navigating
                ? FloatingActionButton.extended(
              icon: const Icon(Icons.close),
              label: const Text("Zakończ"),
              onPressed: _stopNavigation,
            )
                : FloatingActionButton.extended(
              icon: const Icon(Icons.navigation),
              label: const Text("Nawiguj"),
              onPressed: _chooseNavigationMode,
            ),
          ),

          Positioned(
            left: 16,
            bottom: fabBottomOffset,
            child: FloatingActionButton(
              mini: true,
              heroTag: "center",
              onPressed: _centerOnUser,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
