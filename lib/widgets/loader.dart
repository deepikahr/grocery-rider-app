import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocerydelivery/styles/styles.dart';

class SquareLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GFLoader(
        type: GFLoaderType.square,
        loaderColorOne: primary,
        loaderColorTwo: secondary,
        loaderColorThree: primary.withOpacity(0.5),
        size: 45,
      ),
    );
  }
}
