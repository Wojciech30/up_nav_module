import 'dart:math';

import 'package:geolocator/geolocator.dart';
import '../models/navigation_step.dart';

double calcStepDistance(Position pos, List<NavigationStep> steps, int currentIndex) {
  final step = steps[currentIndex];
  return haversine(pos.latitude, pos.longitude, step.latitude, step.longitude);
}

double haversine(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371000.0; // promień Ziemi w metrach
  final dLat = _deg2rad(lat2 - lat1);
  final dLon = _deg2rad(lon2 - lon1);
  final a =
      (sin(dLat / 2) * sin(dLat / 2)) +
          cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
              (sin(dLon / 2) * sin(dLon / 2));
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _deg2rad(double deg) => deg * (3.141592653589793 / 180.0);
