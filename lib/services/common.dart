import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common {
  /// Email pattern to validate email field
  static const String emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  /// save token on storage
  static Future<bool> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', token);
  }

  /// retrive token from storage
  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('token'));
  }

  /// remove token from storage
  static Future<bool> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('token');
  }

  /// save account id on storage
  static Future<bool> setAccountID(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('accountID', id);
  }

  /// retrive account id from storage
  static Future<String> getAccountID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('accountID'));
  }

  /// remove account id from storage
  static Future<bool> removeAccountID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove('accountID');
  }

  // save playerId on storage
  static Future<bool> setPlayerID(String playerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('playerId', playerId);
  }

  // retrive playerId from storage
  static Future<String> getPlayerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('playerId'));
  }

  static Future<bool> setSelectedLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('selectedLanguage', lang);
  }

  static Future<String> getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('selectedLanguage'));
  }

  static Future<bool> setAllLanguageNames(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('alllanguageNames', json.encode(data));
  }

  static Future getAllLanguageNames() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString('alllanguageNames');
    try {
      return json.decode(info);
    } catch (err) {
      return Future(() => null);
    }
  }

  static Future<bool> setAllLanguageCodes(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('alllanguageCodes', json.encode(data));
  }

  static Future getAllLanguageCodes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString('alllanguageCodes');
    try {
      return json.decode(info);
    } catch (err) {
      return Future(() => null);
    }
  }

  // Show toaster by passing message and scaffoldkey
  static void showSnackbar(scaffoldKey, message) {
    final snackBar = SnackBar(
      content: Text(message.toString()),
      duration: Duration(milliseconds: 3000),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
