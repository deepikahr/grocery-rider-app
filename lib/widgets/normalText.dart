import 'package:flutter/material.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';

Widget buildTextField(BuildContext context, title) {
  return TextFormField(
    enabled: false,
    controller: title,
    cursorColor: primary,
    decoration: InputDecoration(
      filled: true,
      fillColor: greyA,
      contentPadding: EdgeInsets.all(15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: greyA, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: greyA, width: 1.0),
      ),
    ),
  );
}

Widget buildContainerField(BuildContext context, title) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      color: Color(0xFFF7F7F7),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
          child: Text(
            MyLocalizations.of(context).getLocalizations(title),
            style: titleSmallBPR(),
          ),
        ),
      ],
    ),
  );
}
