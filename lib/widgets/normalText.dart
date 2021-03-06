import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';

import '../services/localizations.dart';

Widget buildTextField(BuildContext context, title) {
  return TextFormField(
    enabled: false,
    controller: title,
    cursorColor: primary,
    decoration: InputDecoration(
      filled: true,
      fillColor: greyA,
      contentPadding: EdgeInsets.all(15),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: greyA, width: 1.0)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: greyA, width: 1.0)),
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
              MyLocalizations.of(context)!.getLocalizations(title ?? ""),
              style: titleSmallBPR()),
        ),
      ],
    ),
  );
}

Widget buildContainerFieldRow(BuildContext context, title, subTitle) {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      color: Color(0xFFF7F7F7),
    ),
    child: Padding(
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
              style: titleSmallBPR()),
          Text(MyLocalizations.of(context)!.getLocalizations(subTitle ?? ""),
              style: titleSmallBPR()),
        ],
      ),
    ),
  );
}

Widget alertText(BuildContext context, title, Icon? icon) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(MyLocalizations.of(context)!.getLocalizations(title ?? ""),
          style: hintSfboldBig()),
      icon != null ? icon : Container()
    ],
  );
}

Widget orderSummary(BuildContext context, title, value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(MyLocalizations.of(context)!.getLocalizations(title, true),
          style: keyText()),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(MyLocalizations.of(context)!.getLocalizations(value ?? ""),
                style: titleLargeBPM()),
          ],
        ),
      )
    ],
  );
}

Widget buildOrder(
    BuildContext context, Widget icon, title, value, bool container) {
  return Row(
    children: [
      icon,
      Text(MyLocalizations.of(context)!.getLocalizations(title, true),
          style: keyText()),
      container
          ? value
          : Expanded(
              child: Text(
                  MyLocalizations.of(context)!.getLocalizations(value ?? ""),
                  style: keyValue()),
            )
    ],
  );
}

Widget buildGFTypography(BuildContext context, title, isStar, isColon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5.0),
    child: GFTypography(
      showDivider: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 2.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context)!
                      .getLocalizations(title, isColon),
                  style: textBarlowRegularBlack()),
              TextSpan(
                text: isStar ? " * " : ' ',
                style: TextStyle(color: red),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget locationTile(BuildContext context, String address) {
  return Column(
    children: [
      ListTile(
        title: Text(address, style: hintSmallSfMediumblack(context)),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
      Divider(color: Colors.black)
    ],
  );
}
