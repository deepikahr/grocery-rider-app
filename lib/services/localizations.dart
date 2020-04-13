import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'constants.dart' show languages;

class MyLocalizations {
  final Map<String, Map<String, String>> localizedValues;
  MyLocalizations(this.locale, this.localizedValues);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  String get home {
    return localizedValues[locale.languageCode]['home'];
  }
  String get profile {
    return localizedValues[locale.languageCode]['profile'];
  }
  String get history {
    return localizedValues[locale.languageCode]['history'];
  }
  String get activeRequests {
    return localizedValues[locale.languageCode]['activeRequests'];
  }
  String get noActiveRequests {
    return localizedValues[locale.languageCode]['noActiveRequests'];
  }
  String get customer {
    return localizedValues[locale.languageCode]['customer'];
  }
  String get timeDate {
    return localizedValues[locale.languageCode]['timeDate'];
  }
  String get orderId {
    return localizedValues[locale.languageCode]['orderId'];
  }
  String get address {
    return localizedValues[locale.languageCode]['address'];
  }
  String get REJECT {
    return localizedValues[locale.languageCode]['REJECT'];
  }
  String get TRACK {
    return localizedValues[locale.languageCode]['TRACK'];
  }
  String get ACCEPTTRACK {
    return localizedValues[locale.languageCode]['ACCEPT&TRACK'];
  }
  String get completedRequests {
    return localizedValues[locale.languageCode]['completedRequests'];
  }
  String get noDeliveredOrders {
    return localizedValues[locale.languageCode]['noDeliveredOrders'];
  }
  String get userName {
    return localizedValues[locale.languageCode]['userName'];
  }
  String get emailId {
    return localizedValues[locale.languageCode]['emailId'];
  }
  String get mobileNumber {
    return localizedValues[locale.languageCode]['mobileNumber'];
  }
  String get ordersCompleted {
    return localizedValues[locale.languageCode]['ordersCompleted'];
  }
  String get selectLanguages {
    return localizedValues[locale.languageCode]['selectLanguages'];
  }
  String get password {
    return localizedValues[locale.languageCode]['password'];
  }
  String get LOGIN {
    return localizedValues[locale.languageCode]['LOGIN'];
  }
  String get LOGOUT {
    return localizedValues[locale.languageCode]['LOGOUT'];
  }
  String get errorPassword {
    return localizedValues[locale.languageCode]['errorPassword'];
  }
  String get errorEmail {
    return localizedValues[locale.languageCode]['errorEmail'];
  }
  String get authorizationError {
    return localizedValues[locale.languageCode]['authorizationError'];
  }
  String get wrongFormat {
    return localizedValues[locale.languageCode]['wrongFormat'];
  }
  String get groceryDelivery {
    return localizedValues[locale.languageCode]['groceryDelivery'];
  }
  String get orderDetails {
    return localizedValues[locale.languageCode]['orderDetails'];
  }
  String get items {
    return localizedValues[locale.languageCode]['items'];
  }
  String get total {
    return localizedValues[locale.languageCode]['total'];
  }
  String get date {
    return localizedValues[locale.languageCode]['date'];
  }
  String get timeSlot {
    return localizedValues[locale.languageCode]['timeSlot'];
  }
  String get directions {
    return localizedValues[locale.languageCode]['directions'];
  }
  String get toStore {
    return localizedValues[locale.languageCode]['toStore'];
  }
  String get toCustomer {
    return localizedValues[locale.languageCode]['toCustomer'];
  }
  String get payment {
    return localizedValues[locale.languageCode]['payment'];
  }
  String get orderDelivered {
    return localizedValues[locale.languageCode]['orderDelivered'];
  }


  greetTo(name) {
    return localizedValues[locale.languageCode]['greetTo']
        .replaceAll('{{name}}', name);
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  Map<String, Map<String, String>> localizedValues;

  MyLocalizationsDelegate(this.localizedValues);

  @override
  bool isSupported(Locale locale) => languages.contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(
        MyLocalizations(locale, localizedValues));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
