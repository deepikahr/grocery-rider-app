import 'package:flutter/foundation.dart';
import 'package:location/location.dart';

class LocationModel extends ChangeNotifier {
  Location location = new Location();
  LocationData _locationData;

  void requestLocation() async {
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
    }
    _locationData = await location.getLocation();
    onLocationChange();
    notifyListeners();
  }

  void onLocationChange() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationData = currentLocation;
      print('i am here');
      notifyListeners();
    });
  }

  LocationData get getLocation => _locationData;
}
