import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<bool> _ensurePermission() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.location.request();
    }
    return status.isGranted;
  }

  Future<Position?> getCurrentPosition() async {
    final granted = await _ensurePermission();
    if (!granted) return null;

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  Stream<Position> getPositionStream({int distanceFilter = 10}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: distanceFilter,
      ),
    );
  }
}
