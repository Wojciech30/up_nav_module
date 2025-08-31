import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class RouteService {
  Future<RoadInfo> drawRoad({
    required MapController controller,
    required GeoPoint start,
    required GeoPoint end,
    required RoadType mode,
  }) async {
    final road = await controller.drawRoad(
      start,
      end,
      roadType: mode,
      roadOption: const RoadOption(
        roadColor: Colors.blue,
        roadWidth: 8,
      ),
    );
    return road;
  }
}
