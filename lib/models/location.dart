import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocerydelivery/services/locationService.dart';

class LocationModel extends ChangeNotifier {
  Position? _locationData;

  void requestLocation() async {
    _locationData = await LocationUtils().currentLocation();
    onLocationChange();
    notifyListeners();
  }

  Future<void> onLocationChange() async {
    _locationData = await LocationUtils().currentLocation();
    notifyListeners();
  }

  Position? get getLocation => _locationData;
}
