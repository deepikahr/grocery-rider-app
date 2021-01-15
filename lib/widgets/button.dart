import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:grocerydelivery/widgets/loader.dart';

Widget buttonPrimary(BuildContext context, title, bool isloading) {
  return Container(
    height: 55,
    color: primary,
    margin: EdgeInsets.only(top: 30, bottom: 20, right: 20, left: 20),
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 5)
    ]),
    child: Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: GFButton(
          color: primary,
          blockButton: true,
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(MyLocalizations.of(context).getLocalizations(title ?? ""),
                  style: titleXLargeWPB()),
              SizedBox(height: 10),
              isloading ? GFLoader(type: GFLoaderType.ios) : Text("")
            ],
          ),
          textStyle: textBarlowRegularrBlack()),
    ),
  );
}

Widget buttonSecondry(BuildContext context, title, bool isloading) {
  return Container(
    height: 55,
    color: secondary,
    margin: EdgeInsets.only(top: 30, bottom: 20, right: 20, left: 20),
    // decoration: BoxDecoration(boxShadow: [
    //   BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 5)
    // ]),
    child: Padding(
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: GFButton(
          color: secondary,
          blockButton: true,
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(MyLocalizations.of(context).getLocalizations(title ?? ""),
                  style: titleXLargeWPB()),
              SizedBox(height: 10),
              isloading ? GFLoader(type: GFLoaderType.ios) : Text("")
            ],
          ),
          textStyle: textBarlowRegularrBlack()),
    ),
  );
}

Widget loginButton(BuildContext context, title, bool isLoading) {
  return Container(
    color: secondary,
    height: 51,
    child: GFButton(
        onPressed: null,
        size: GFSize.LARGE,
        child: isLoading
            ? GFLoader(type: GFLoaderType.ios)
            : Text(MyLocalizations.of(context).getLocalizations(title ?? ""),
                style: titleXLargeWPB()),
        color: secondary,
        blockButton: true),
  );
}

Widget logoutButton(BuildContext context, title) {
  return Container(
    height: 51,
    child: GFButton(
        onPressed: null,
        size: GFSize.LARGE,
        child: Text(MyLocalizations.of(context).getLocalizations(title ?? ""),
            style: titleGPBSec()),
        type: GFButtonType.outline2x,
        color: secondary,
        blockButton: true),
  );
}

Widget tostoreCustomerButton(BuildContext context, title) {
  return GFButton(
    onPressed: null,
    text: MyLocalizations.of(context).getLocalizations(title ?? ""),
    textStyle: titleRPM(red),
    icon: Icon(Icons.directions, color: Colors.red),
    color: Colors.white,
    size: GFSize.MEDIUM,
    borderShape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}

Widget acceptRejectButton(
    BuildContext context, title, bool isloading, orderIndex, index) {
  return Container(
    height: 51,
    child: GFButton(
      onPressed: null,
      size: GFSize.LARGE,
      child: isloading && orderIndex == index
          ? SquareLoader()
          : Text(MyLocalizations.of(context).getLocalizations(title ?? ""),
              style: titleGPBB()),
      color: greyB,
      type: GFButtonType.outline2x,
    ),
  );
}

Widget alartAcceptRejectButton(BuildContext context, title, bool isloading) {
  return Container(
    height: 51,
    child: GFButton(
      onPressed: null,
      size: GFSize.LARGE,
      child: isloading
          ? SquareLoader()
          : Text(MyLocalizations.of(context).getLocalizations(title ?? ""),
              style: titleGPBB()),
      color: greyB,
      type: GFButtonType.outline2x,
    ),
  );
}

Widget deliveredButton(
    BuildContext context, title, bool isOrderStatusDeliveredLoading) {
  return Container(
    color: secondary,
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: GFButton(
        onPressed: null,
        size: GFSize.LARGE,
        child: isOrderStatusDeliveredLoading
            ? SquareLoader()
            : Text(MyLocalizations.of(context).getLocalizations(title)),
        textStyle: titleXLargeWPB(),
        color: secondary,
        blockButton: true),
  );
}

Widget trackButton(BuildContext context, title) {
  return Container(
    height: 51,
    child: GFButton(
        onPressed: null,
        size: GFSize.LARGE,
        child: Text(MyLocalizations.of(context).getLocalizations(title ?? ""),
            style: titleGPBB()),
        textStyle: titleGPBB(),
        type: GFButtonType.outline2x,
        color: primary,
        blockButton: true),
  );
}

Widget mapButton(BuildContext context, title) {
  return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GFButton(
        onPressed: null,
        text: MyLocalizations.of(context).getLocalizations(title ?? ""),
        textStyle: titleRPM(red),
        icon: Icon(Icons.directions, color: red),
        color: Colors.white,
        size: GFSize.MEDIUM,
        borderShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
}

Widget startAndStartedButton(BuildContext context, String startButtonText,
    bool isOrderStatusOutForDeliveryLoading) {
  return Container(
    height: 30,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: GFButton(
      onPressed: null,
      child: isOrderStatusOutForDeliveryLoading
          ? GFLoader(type: GFLoaderType.ios)
          : Text(MyLocalizations.of(context)
              .getLocalizations(startButtonText ?? "")),
      textStyle: titleRPM(startButtonText == 'START' ? red : primary),
      icon: Icon(
        startButtonText == 'START' ? Icons.play_arrow : Icons.check,
        color: startButtonText == 'START' ? red : primary,
      ),
      color: Colors.white,
      size: GFSize.MEDIUM,
      borderShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
