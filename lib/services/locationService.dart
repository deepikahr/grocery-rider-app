import 'package:geolocator/geolocator.dart';

class LocationUtils {
  Future locationPermission() async {
    bool serviceEnabled;
    String? permissionValue;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permissionValue = 'LOCATION_ALLOW_ERROR_MSG';
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permissionValue = 'LOCATION_ALLOW_ERROR_MSG';
      } else {
        permissionValue = 'ALLOW';
      }
    } else {
      permissionValue = 'ALLOW';
    }

    if (permission == LocationPermission.deniedForever) {
      permissionValue = 'LOCATION_ALLOW_ERROR_MSG_PERMANTLY';
    }
    return permissionValue;
  }

  Future<Position> currentLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}
