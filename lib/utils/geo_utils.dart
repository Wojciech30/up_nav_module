import 'dart:math';
import 'package:geolocator/geolocator.dart';
import '../models/navigation_step.dart';

double calcStepDistance(Position pos, List<NavigationStep> steps, int currentIndex) {
  if (currentIndex < 0 || currentIndex >= steps.length) {
    return double.maxFinite / 2;
  }
  final step = steps[currentIndex];
  return haversine(pos.latitude, pos.longitude, step.latitude, step.longitude);
}

const _maxCacheSize = 128;
final _distanceCache = <String, double>{};

double haversine(double lat1, double lon1, double lat2, double lon2) {
  String k(double v) => v.toStringAsFixed(5);
  final cacheKey = '${k(lat1)}_${k(lon1)}_${k(lat2)}_${k(lon2)}';

  final cached = _distanceCache[cacheKey];
  if (cached != null) return cached;

  const R = 6371000.0; // m
  final dLat = _deg2rad(lat2 - lat1);
  final dLon = _deg2rad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
          sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  final result = R * c;

  if (_distanceCache.length >= _maxCacheSize) {
    _distanceCache.remove(_distanceCache.keys.first);
  }
  _distanceCache[cacheKey] = result;
  return result;
}

double _deg2rad(double deg) => deg * (pi / 180.0);
