import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';

Widget appBarPrimary(BuildContext context, title) {
  return GFAppBar(
      title: Text(
        MyLocalizations.of(context).getLocalizations(title ?? ""),
        style: titleWPS(),
      ),
      centerTitle: true,
      backgroundColor: primary,
      iconTheme: IconThemeData(color: Colors.white));
}

Widget appBar(BuildContext context, title) {
  return AppBar(
      backgroundColor: primary,
      title: Text(MyLocalizations.of(context).getLocalizations(title ?? ""),
          style: titleWPS()),
      centerTitle: true,
      automaticallyImplyLeading: false);
}
