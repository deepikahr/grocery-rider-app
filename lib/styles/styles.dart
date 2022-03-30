import 'package:flutter/material.dart';

final primary = const Color(0xFF363062);
final secondary = const Color(0xFFFE9801);
final greyA = const Color(0xFFF9F9F9);
final greyB = const Color(0xFFC2C0C0);
final red = const Color(0xFFDF1616);
final green = const Color(0xFF20C978);

double screenHeight(context) {
  return MediaQuery.of(context).size.height;
}

double screenWidth(context) {
  return MediaQuery.of(context).size.width;
}

//..................................poppins semi bold....................................

TextStyle titleWPS() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 17.0,
    color: Colors.white,
    fontFamily: 'PoppinsSemiBold',
  );
}

TextStyle titleBPS() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: 'PoppinsSemiBold',
  );
}

TextStyle titleXLargeBPSB() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 25.0,
    color: Colors.black,
    fontFamily: 'PoppinsSemiBold',
  );
}

//..................................poppins bold....................................

TextStyle titleVerySamllPPB() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.0,
    color: secondary,
    fontFamily: 'PoppinsBold',
  );
}

TextStyle titleLargePPB() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20.0,
    color: primary,
    fontFamily: 'PoppinsBold',
  );
}

TextStyle titleLargeBPB() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: 'PoppinsBold',
  );
}

TextStyle titleXLargeWPB() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 25.0,
    color: Colors.white,
    fontFamily: 'PoppinsBold',
  );
}

TextStyle titleSPB() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: secondary,
    fontFamily: 'PoppinsBold',
  );
}

TextStyle titleGPB() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: greyB,
    fontFamily: 'PoppinsBold',
  );
}

TextStyle titleGPBB() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: Colors.black,
    fontFamily: 'PoppinsBold',
  );
}

TextStyle titleGPBSec() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: secondary,
    fontFamily: 'PoppinsBold',
  );
}

//..................................poppins regular....................................

TextStyle titleSmallBPR() {
  return new TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15.0,
    color: Colors.black.withOpacity(0.6),
    fontFamily: 'PoppinsRegular',
  );
}

TextStyle titleXSmallBPR() {
  return new TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: Colors.black.withOpacity(0.6),
    fontFamily: 'PoppinsRegular',
  );
}

TextStyle titleXSmallBBPR() {
  return new TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: Colors.black,
    fontFamily: 'PoppinsRegular',
  );
}

//..................................poppins medium....................................

TextStyle titleBPM() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: Colors.black,
    fontFamily: 'PoppinsMedium',
  );
}

TextStyle titleWPM() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.0,
    color: Colors.white,
    fontFamily: 'PoppinsMedium',
  );
}

TextStyle titleRPM(color) {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: color,
    fontFamily: 'PoppinsMedium',
  );
}

TextStyle titlePPM() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: primary,
    fontFamily: 'PoppinsMedium',
  );
}

TextStyle titleLargeBPM() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 15.0,
    color: Colors.black,
    fontFamily: 'PoppinsMedium',
  );
}

TextStyle subTitleSmallBPM() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.0,
    color: Colors.black,
    fontFamily: 'PoppinsMedium',
  );
}

TextStyle subTitleLargeBPM() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: 'PoppinsMedium',
  );
}

TextStyle textbarlowRegularBlack() {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black,
  );
}

TextStyle textBarlowRegularBlack() {
  return TextStyle(
      fontSize: 16.0,
      fontFamily: 'BarlowRegular',
      color: Colors.black,
      fontWeight: FontWeight.w500);
}

TextStyle textbarlowRegularaPrimary() {
  return TextStyle(
    fontSize: 16.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w600,
    color: primary,
  );
}

TextStyle textbarlowSemiBoldBlack() {
  return TextStyle(
    fontSize: 17.0,
    fontFamily: 'BarlowSemiBold',
    color: Colors.black,
    fontWeight: FontWeight.w700,
  );
}

TextStyle textBarlowSemiBoldBlack() {
  return TextStyle(
//////barlowBold//////
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: Colors.black,
  );
}

TextStyle textBarlowSemiBoldBlackbigg() {
  return TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: Colors.black,
  );
}

TextStyle textbarlowMediumBlack() {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.black,
  );
}

TextStyle textbarlowMediumPrimary() {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: primary,
  );
}

TextStyle textbarlowMediumBlackm() {
  return TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Colors.black,
  );
}

TextStyle textBarlowRegularrBlack() {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
}

TextStyle hintSfMediumredsmall() {
  return TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    color: red,
    fontFamily: 'SfUiDMedium',
  );
}

TextStyle textBarlowMediumGreen() {
  return TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    fontFamily: 'BarlowMedium',
    color: Color(0xFF20C978),
  );
}

TextStyle textbarlowRegularBlackb() {
  return TextStyle(
    fontSize: 13.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black,
  );
}

TextStyle textbarlowRegularBlackd() {
  return TextStyle(
    fontSize: 12.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black.withOpacity(0.60),
  );
}

TextStyle textbarlowRegulardull() {
  return TextStyle(
      fontSize: 13.0, fontFamily: 'BarlowRegular', color: Color(0xFFBBBBBB));
}

TextStyle textbarlowRegularBlackdull() {
  return TextStyle(
    fontSize: 15.0,
    fontFamily: 'BarlowRegular',
    color: Colors.black.withOpacity(0.60),
  );
}

TextStyle textBarlowMediumBlack() {
  return TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w500,
    fontFamily: 'BarlowMedium',
    color: Colors.black,
  );
}

TextStyle pageHeader() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18.0,
    color: Colors.black,
    fontFamily: 'PoppinsSemiBold',
  );
}

TextStyle keyText() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.black,
    fontFamily: 'PoppinsBold',
  );
}

TextStyle keyTextWhite() {
  return new TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'PoppinsBold',
  );
}

TextStyle keyValue() {
  return new TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    color: Colors.black,
    fontFamily: 'PoppinsRegular',
  );
}

TextStyle hintSfboldBig() {
  return TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    color: Colors.black,
    fontFamily: 'SfUiDBold',
  );
}

TextStyle textAddressLocation() {
  return TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'BarlowSemiBold',
    color: Colors.black,
  );
}

TextStyle textAddressLocationLow() {
  return TextStyle(
    fontSize: 20.0,
    fontFamily: 'BarlowRegular',
    fontWeight: FontWeight.w400,
    color: Colors.black.withOpacity(0.6),
  );
}

TextStyle textmediumblack() {
  return TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
    color: Colors.black,
    fontFamily: 'MontserratMedium',
  );
}

TextStyle hintSmallSfMediumblack(context) {
  return TextStyle(
    fontWeight: FontWeight.w100,
    fontSize: 13.0,
    color: Colors.black,
    fontFamily: 'MontserratMedium',
  );
}
