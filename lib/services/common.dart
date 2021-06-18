import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  /// save token on storage
  static Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  /// retrive token from storage
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('token'));
  }

  /// save currency on storage
  static Future<bool> setCurrency(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('currency', token);
  }

  /// retrive currency from storage
  static Future<String?> getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('currency'));
  }

  /// save account id on storage
  static Future<bool> setAccountID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('accountID', id);
  }

  /// retrive account id from storage
  static Future<String?> getAccountID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('accountID'));
  }

  // save playerId on storage
  static Future<bool> setPlayerID(String playerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('playerId', playerId);
  }

  // retrive playerId from storage
  static Future<String?> getPlayerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('playerId'));
  }

  static Future<bool> setSelectedLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('selectedLanguage', lang);
  }

  static Future<String?> getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('selectedLanguage'));
  }

  static Future<bool> setNoConnection(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('connection', json.encode(data));
  }

  static Future<Map> getNoConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString('connection')!;
    try {
      return json.decode(info) as Map;
    } catch (err) {
      return Future(() => {});
    }
  }
}
