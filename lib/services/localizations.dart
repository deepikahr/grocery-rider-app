import 'dart:async' show Future;
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class MyLocalizations {
  final Map? localizedValues;
  MyLocalizations(this.locale, this.localizedValues);

  final Locale locale;

  static MyLocalizations? of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  getLocalizations(keyName, [bool isKeyValue = false]) {
    String? keyValue = localizedValues![locale.languageCode][keyName];
    keyValue ??= keyName;

    if (isKeyValue) keyValue = keyValue! + " : ";
    return keyValue;
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  Map? localizedValues;
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
