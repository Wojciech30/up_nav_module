import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentPosition() async {
    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      final req = await Geolocator.requestPermission();
      if (req == LocationPermission.denied || req == LocationPermission.deniedForever) {
        return null;
      }
    }
    if (await Geolocator.isLocationServiceEnabled() == false) {
      return null;
    }
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Stream<Position> getPositionStream() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    );
    return Geolocator.getPositionStream(locationSettings: settings);
  }
}
