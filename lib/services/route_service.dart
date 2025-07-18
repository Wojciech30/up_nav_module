import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class RouteService {
  Future<RoadInfo> getRoute({
    required MapController mapController,
    required GeoPoint start,
    required GeoPoint end,
    required RoadType roadType,
  }) {
    return mapController.drawRoad(
      start,
      end,
      roadType: roadType,
      roadOption: const RoadOption(
        roadColor: Colors.indigo,
        roadWidth: 8,
        zoomInto: true,
      ),
    );
  }
}
