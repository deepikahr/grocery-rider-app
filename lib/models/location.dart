import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/locationService.dart';

class LocationModel extends ChangeNotifier {
  LatLng? _locationData;

  void requestLocation() async {
    String permission = await LocationUtils().locationPermission();
    if (permission != 'ALLOW') {
      Common.getLocation().then((value) {
        _locationData = LatLng(value?['latitude'], value?['longitude']);
      });
    } else {
      Position? position = await LocationUtils().currentLocation();
      _locationData = LatLng(position.latitude, position.longitude);
    }
    onLocationChange();
    notifyListeners();
  }

  Future<void> onLocationChange() async {
    String permission = await LocationUtils().locationPermission();
    if (permission != 'ALLOW') {
      Common.getLocation().then((value) {
        _locationData = LatLng(value?['latitude'], value?['longitude']);
      });
    } else {
      Position? position = await LocationUtils().currentLocation();
      _locationData = LatLng(position.latitude, position.longitude);
    }
    notifyListeners();
  }

  LatLng? get getLocation => _locationData;
}
