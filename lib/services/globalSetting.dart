import 'package:grocerydelivery/services/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> getGlobalSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.get(Constants.BASE_URL + 'setting/currency',
      headers: {'Content-Type': 'application/json'});
  print('Data.............${response.body}');
  prefs.setString('globalSettings', response.body);
  return json.decode(response.body);
}

// get Globlsettings from storage
Future<String> getSavedSettingsData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return Future(() => prefs.getString('globalSettings'));
}
