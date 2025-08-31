import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:up_nav_module/models/building.dart';
import 'package:up_nav_module/models/navigation_step.dart';
import 'package:up_nav_module/services/location_service.dart';
import 'package:up_nav_module/services/route_service.dart';
import 'package:up_nav_module/utils/navigation_helper.dart';
import 'package:up_nav_module/utils/geo_utils.dart' as geo_utils;

class NavigationState {
  final bool navigating;
  final List<NavigationStep> steps;
  final int currentIndex;
  final double distanceKm;
  final double durationMin;

  const NavigationState({
    required this.navigating,
    required this.steps,
    required this.currentIndex,
    required this.distanceKm,
    required this.durationMin,
  });

  NavigationState copyWith({
    bool? navigating,
    List<NavigationStep>? steps,
    int? currentIndex,
    double? distanceKm,
    double? durationMin,
  }) {
    return NavigationState(
      navigating: navigating ?? this.navigating,
      steps: steps ?? this.steps,
      currentIndex: currentIndex ?? this.currentIndex,
      distanceKm: distanceKm ?? this.distanceKm,
      durationMin: durationMin ?? this.durationMin,
    );
  }

  static const empty = NavigationState(
    navigating: false,
    steps: <NavigationStep>[],
    currentIndex: 0,
    distanceKm: 0,
    durationMin: 0,
  );
}

class NavigationService {
  final _stateCtrl = StreamController<NavigationState>.broadcast();
  NavigationState _state = NavigationState.empty;

  Stream<NavigationState> get state$ => _stateCtrl.stream;
  NavigationState get state => _state;

  final RouteService _routeService = RouteService();
  StreamSubscription? _posSub;

  Future<void> ensureDestinationMarker({
    required MapController mapController,
    required Building building,
  }) async {
    final dest = GeoPoint(latitude: building.latitude, longitude: building.longitude);
    await mapController.addMarker(
      dest,
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.location_on, color: Colors.red, size: 48),
      ),
    );
    await mapController.moveTo(dest);
  }

  Future<void> start({
    required MapController mapController,
    required Building destination,
    required RoadType mode,
  }) async {
    final current = await LocationService().getCurrentPosition();
    if (current == null) return;

    final startPoint = GeoPoint(latitude: current.latitude, longitude: current.longitude);
    final endPoint = GeoPoint(latitude: destination.latitude, longitude: destination.longitude);

    final road = await _routeService.drawRoad(
      controller: mapController,
      start: startPoint,
      end: endPoint,
      mode: mode,
    );

    final steps = NavigationHelper.parseInstructionsList(road);

    final distanceKm = road.distance ?? 0;
    final raw = road.duration ?? 0;
    final durationMin = raw > 1440 ? raw / 60.0 : raw;

    _state = NavigationState(
      navigating: steps.isNotEmpty,
      steps: steps,
      currentIndex: 0,
      distanceKm: distanceKm,
      durationMin: durationMin,
    );
    _stateCtrl.add(_state);

    await _runStartCameraAnimation(
      mapController: mapController,
      start: startPoint,
      end: endPoint,
    );

    _posSub?.cancel();
    _posSub = LocationService().getPositionStream().listen((pos) async {
      if (_state.steps.isEmpty) return;

      final user = GeoPoint(latitude: pos.latitude, longitude: pos.longitude);
      final currentStep = _state.steps[_state.currentIndex];

      final d = geo_utils.haversine(
        user.latitude,
        user.longitude,
        currentStep.latitude,
        currentStep.longitude,
      );

      if (d < 25 && _state.currentIndex < _state.steps.length - 1) {
        _state = _state.copyWith(currentIndex: _state.currentIndex + 1);
        _stateCtrl.add(_state);
      }
    });
  }

  Future<void> stop({required MapController mapController}) async {
    await mapController.clearAllRoads();
    await _posSub?.cancel();
    _posSub = null;
    _state = NavigationState.empty;
    _stateCtrl.add(_state);
  }

  Future<void> centerOnUser({required MapController mapController}) async {
    final pos = await LocationService().getCurrentPosition();
    if (pos != null) {
      await mapController.moveTo(GeoPoint(latitude: pos.latitude, longitude: pos.longitude));
      await mapController.enableTracking();
    }
  }

  Future<void> setTrackingEnabled({
    required MapController mapController,
    required bool enabled,
  }) async {
    if (enabled) {
      await mapController.enableTracking();
    } else {
      await mapController.disabledTracking();
    }
  }

  void dispose() {
    _posSub?.cancel();
    _stateCtrl.close();
  }

  Future<void> _runStartCameraAnimation({
    required MapController mapController,
    required GeoPoint start,
    required GeoPoint end,
  }) async {
    await mapController.disabledTracking();

    await mapController.moveTo(end);
    await mapController.setZoom(zoomLevel: 16);
    await Future.delayed(const Duration(milliseconds: 900));

    final mid = GeoPoint(
      latitude: (start.latitude + end.latitude) / 2.0,
      longitude: (start.longitude + end.longitude) / 2.0,
    );
    await mapController.moveTo(mid);

    final approxKm = geo_utils.haversine(
      start.latitude, start.longitude, end.latitude, end.longitude,
    ) /
        1000.0;
    final zoomForRoute = approxKm < 2
        ? 15.0
        : approxKm < 5
        ? 14.0
        : approxKm < 10
        ? 13.0
        : approxKm < 20
        ? 12.0
        : 11.0;
    await mapController.setZoom(zoomLevel: zoomForRoute);
    await Future.delayed(const Duration(milliseconds: 900));

    await mapController.moveTo(start);
    await mapController.setZoom(zoomLevel: 16);
    await Future.delayed(const Duration(milliseconds: 900));

    await mapController.enableTracking();
  }
}
