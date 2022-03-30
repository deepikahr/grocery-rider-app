import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'constants.dart';

class LocationUtils {
  final geoCoding = GoogleMapsGeocoding(apiKey: Constants.googleMapApiKey);

  final places = GoogleMapsPlaces(apiKey: Constants.googleMapApiKey);

  Future<List<Prediction>> getSuggestions(suggestion) async {
    final res = await places.autocomplete(suggestion);
    var result = res.predictions.map((r) => r).toList();
    return result;
  }

  Future<String?> getAddressFromPlaceId(String placeId) async {
    final res = await places.getDetailsByPlaceId(placeId);
    return res.result.formattedAddress;
  }

  Future<Location?> getLatLngFromPlaceId(String placeId) async {
    final res = await places.getDetailsByPlaceId(placeId);
    return res.result.geometry?.location;
  }

  Future<GeocodingResult> getAddressFromLatLng(LatLng? latlng) async {
    final res = await geoCoding.searchByLocation(
      Location(lat: latlng!.latitude, lng: latlng.longitude),
    );
    return res.results.first;
  }

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
