import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../models/building.dart';
import '../models/navigation_step.dart';
import '../services/location_service.dart';
import '../services/navigation_service.dart';
import '../utils/navigation_helper.dart';
import '../utils/geo_utils.dart';
import '../widgets/navigation_hud.dart';
import '../widgets/navigation_bottom_bar.dart';

class MapScreen extends StatefulWidget {
  final Building building;

  const MapScreen({super.key, required this.building});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  List<NavigationStep> _steps = [];
  bool _navigating = false;
  double _distance = 0, _duration = 0;
  int _currentIndex = 0;
  double? _stepDistance;
  bool _followDirection = true;

  bool get _showBottomBar => _navigating;

  @override
  void initState() {
    super.initState();
    _mapController = MapController(
      initPosition: GeoPoint(
        latitude: widget.building.latitude,
        longitude: widget.building.longitude,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _addDestinationMarker());
  }

  Future<void> _addDestinationMarker() async {
    await _mapController.addMarker(
      GeoPoint(
        latitude: widget.building.latitude,
        longitude: widget.building.longitude,
      ),
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.location_on, color: Colors.red, size: 64),
      ),
    );
  }

  Future<void> _startNavigation(RoadType type) async {
    final pos = await LocationService().getCurrentPosition();
    if (pos == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brak dostępu do lokalizacji.')),
      );
      return;
    }

    await _mapController.removeLastRoad();

    final start = GeoPoint(latitude: pos.latitude, longitude: pos.longitude);
    final end = GeoPoint(
      latitude: widget.building.latitude,
      longitude: widget.building.longitude,
    );

    final road = await _mapController.drawRoad(
      start,
      end,
      roadType: type,
      roadOption: const RoadOption(
        roadColor: Colors.blue,
        roadWidth: 8,
        zoomInto: false,
      ),
    );

    _steps = NavigationHelper.parseInstructionsList(road);
    _distance = road.distance?.toDouble() ?? 0;
    _duration = road.duration?.toDouble() ?? 0;
    _currentIndex = 0;
    _stepDistance = calcStepDistance(pos, _steps, _currentIndex);

    if (!mounted) return;
    setState(() => _navigating = true);

    await _mapController.zoomToBoundingBox(
      BoundingBox.fromGeoPoints([start, end]),
      paddinInPixel: 50,
    );

    await Future.delayed(const Duration(seconds: 2));
    await _mapController.moveTo(start);
    await Future.delayed(const Duration(milliseconds: 500));
    await _mapController.setZoom(zoomLevel: 17);

    NavigationService().startNavigation(_steps);
    NavigationService().onInstructionChange = (_) {
      NavigationService.updateStep(
        steps: _steps,
        currentIndex: _currentIndex,
        onUpdate: (stepDistance, index) {
          setState(() {
            _stepDistance = stepDistance;
            _currentIndex = index;
          });
        },
      );
    };
  }

  Future<void> _stopNavigation() async {
    NavigationService().stopNavigation();
    await _mapController.removeLastRoad();
    setState(() {
      _navigating = false;
      _steps.clear();
      _distance = _duration = 0;
      _stepDistance = null;
      _currentIndex = 0;
    });
  }

  Future<void> _centerOnUser() async {
    final pos = await LocationService().getCurrentPosition();
    if (pos != null) {
      await _mapController.moveTo(
        GeoPoint(latitude: pos.latitude, longitude: pos.longitude),
      );
    }
  }

  Future<void> _toggleOrientationMode() async {
    if (_followDirection) {
      await _mapController.rotateMapCamera(0);
      await _mapController.enableTracking(enableStopFollow: false);
    } else {
      await _mapController.enableTracking(enableStopFollow: false);
    }

    if (!mounted) return;
    setState(() => _followDirection = !_followDirection);
  }

  void _showTransportDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.directions_walk),
            title: const Text('Pieszo'),
            onTap: () {
              Navigator.pop(context);
              _startNavigation(RoadType.foot);
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_bike),
            title: const Text('Rowerem'),
            onTap: () {
              Navigator.pop(context);
              _startNavigation(RoadType.bike);
            },
          ),
          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('Samochodem'),
            onTap: () {
              Navigator.pop(context);
              _startNavigation(RoadType.car);
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    NavigationService().stopNavigation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currStep = (_steps.isNotEmpty && _currentIndex < _steps.length)
        ? _steps[_currentIndex]
        : null;
    final bottomOffset = _showBottomBar ? 60.0 : 0.0;

    return Scaffold(
      appBar: AppBar(title: Text(widget.building.name)),
      body: Stack(
        children: [
          OSMFlutter(
            controller: _mapController,
            osmOption: const OSMOption(
              userTrackingOption: UserTrackingOption(enableTracking: true),
              zoomOption: ZoomOption(initZoom: 20),
            ),
          ),
          if (_navigating && currStep != null)
            NavigationHud(
              instruction: currStep.instruction,
              distance: _stepDistance,
            ),
          Positioned(top: 70, right: 10, child: _buildOrientationBtn()),
          if (_showBottomBar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: NavigationBottomBar(
                distance: _distance,
                duration: _duration,
              ),
            ),
          Positioned(
            bottom: bottomOffset + 10,
            left: 10,
            child: _buildCenterBtn(),
          ),
          Positioned(
            bottom: bottomOffset + 10,
            right: 10,
            child: _buildNavBtn(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrientationBtn() => FloatingActionButton(
    mini: true,
    heroTag: 'orientBtn',
    onPressed: _toggleOrientationMode,
    tooltip: _followDirection ? 'Tryb: Kierunek jazdy' : 'Tryb: Północ na górze',
    child: Icon(_followDirection ? Icons.explore : Icons.navigation),
  );

  Widget _buildCenterBtn() => FloatingActionButton(
    heroTag: 'centerBtn',
    onPressed: _centerOnUser,
    child: const Icon(Icons.my_location),
  );

  Widget _buildNavBtn() => FloatingActionButton.extended(
    heroTag: 'navBtn',
    onPressed: _navigating ? _stopNavigation : _showTransportDialog,
    label: Text(_navigating ? 'Zatrzymaj' : 'Nawiguj'),
    icon: Icon(_navigating ? Icons.close : Icons.navigation),
  );
}
