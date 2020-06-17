import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class MyLocalizations {
  final Map localizedValues;
  MyLocalizations(this.locale, this.localizedValues);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  String get home {
    return localizedValues[locale.languageCode]['home'] ?? "Home";
  }

  String get profile {
    return localizedValues[locale.languageCode]['profile'] ?? "Profile";
  }

  String get history {
    return localizedValues[locale.languageCode]['history'] ?? "History";
  }

  String get activeRequests {
    return localizedValues[locale.languageCode]['activeRequests'] ??
        "Active requests";
  }

  String get noActiveRequests {
    return localizedValues[locale.languageCode]['noActiveRequests'] ??
        "No active requests found!";
  }

  String get customer {
    return localizedValues[locale.languageCode]['customer'] ?? "Customer:";
  }

  String get timeDate {
    return localizedValues[locale.languageCode]['timeDate'] ?? "Time/Date:";
  }

  String get orderId {
    return localizedValues[locale.languageCode]['orderId'] ?? "Order ID:";
  }

  String get address {
    return localizedValues[locale.languageCode]['address'] ?? "Address:";
  }

  String get rEJECT {
    return localizedValues[locale.languageCode]['rEJECT'] ?? "REJECT";
  }

  String get tRACK {
    return localizedValues[locale.languageCode]['tRACK'] ?? "TRACK";
  }

  String get aCCEPTtRACK {
    return localizedValues[locale.languageCode]['ACCEPT&tRACK'] ??
        "ACCEPT & tRACK";
  }

  String get accptRejest {
    return localizedValues[locale.languageCode]['accptRejest'] ??
        "ACCEPT & tRACK";
  }

  String get completedRequests {
    return localizedValues[locale.languageCode]['completedRequests'] ??
        "Completed requests";
  }

  String get noDeliveredOrders {
    return localizedValues[locale.languageCode]['noDeliveredOrders'] ??
        "No delivered orders found!";
  }

  String get userName {
    return localizedValues[locale.languageCode]['userName'] ?? "Username";
  }

  String get emailId {
    return localizedValues[locale.languageCode]['emailId'] ?? "Email ID";
  }

  String get mobileNumber {
    return localizedValues[locale.languageCode]['mobileNumber'] ??
        "Mobile Number";
  }

  String get ordersCompleted {
    return localizedValues[locale.languageCode]['ordersCompleted'] ??
        "Orders completed";
  }

  String get selectLanguages {
    return localizedValues[locale.languageCode]['selectLanguages'] ??
        "Select Languages:";
  }

  String get password {
    return localizedValues[locale.languageCode]['password'] ?? "Password";
  }

  String get lOGIN {
    return localizedValues[locale.languageCode]['lOGIN'] ?? "LOGIN";
  }

  String get lOGOUT {
    return localizedValues[locale.languageCode]['lOGOUT'] ?? "LOGOUT";
  }

  String get errorPassword {
    return localizedValues[locale.languageCode]['errorPassword'] ??
        "Password should be atleast 6 char long";
  }

  String get errorEmail {
    return localizedValues[locale.languageCode]['errorEmail'] ??
        "Please enter a valid email";
  }

  String get authorizationError {
    return localizedValues[locale.languageCode]['authorizationError'] ??
        "is not authorised to lOGIN to Delivery App.";
  }

  String get wrongFormat {
    return localizedValues[locale.languageCode]['wrongFormat'] ??
        "Something went wrong!, Received Data was in wrong format!";
  }

  String get groceryDelivery {
    return localizedValues[locale.languageCode]['groceryDelivery'] ??
        "Grocery Delivery";
  }

  String get orderDetails {
    return localizedValues[locale.languageCode]['orderDetails'] ??
        "Order Details";
  }

  String get items {
    return localizedValues[locale.languageCode]['items'] ?? "Items:";
  }

  String get total {
    return localizedValues[locale.languageCode]['total'] ?? "Total:";
  }

  String get date {
    return localizedValues[locale.languageCode]['date'] ?? "Date:";
  }

  String get timeSlot {
    return localizedValues[locale.languageCode]['timeSlot'] ?? "Time slot:";
  }

  String get directions {
    return localizedValues[locale.languageCode]['directions'] ?? "Directions:";
  }

  String get toStore {
    return localizedValues[locale.languageCode]['toStore'] ?? "TO STORE";
  }

  String get toCustomer {
    return localizedValues[locale.languageCode]['toCustomer'] ?? "TO CUSTOMER";
  }

  String get payment {
    return localizedValues[locale.languageCode]['payment'] ?? "Payment";
  }

  String get orderDelivered {
    return localizedValues[locale.languageCode]['orderDelivered'] ??
        "ORDER DELIVERED";
  }

  String get cashOnDelivery {
    return localizedValues[locale.languageCode]['cashOnDelivery'] ??
        "Cash on Delivery";
  }

  String get tap {
    return localizedValues[locale.languageCode]['tap'] ?? "TAP";
  }

  String get youhaveupdatedstatustoOutfordelivery {
    return localizedValues[locale.languageCode]
            ['youhaveupdatedstatustoOutfordelivery'] ??
        "You have updated status to: Out for delivery";
  }

  greetTo(name) {
    return localizedValues[locale.languageCode]['greetTo']
        .replaceAll('{{name}}', name);
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  Map localizedValues;
  List languageList;
  MyLocalizationsDelegate(this.localizedValues, this.languageList);

  @override
  bool isSupported(Locale locale) => languageList.contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    return SynchronousFuture<MyLocalizations>(
        MyLocalizations(locale, localizedValues));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
