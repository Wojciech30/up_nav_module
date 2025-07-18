import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class UniversityMap extends StatelessWidget {
  final MapController controller;
  final bool enableTracking;

  const UniversityMap({
    super.key,
    required this.controller,
    this.enableTracking = true,
  });

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        userTrackingOption: UserTrackingOption(
          enableTracking: enableTracking,
        ),
        zoomOption: const ZoomOption(initZoom: 16),
      ),
    );
  }
}
