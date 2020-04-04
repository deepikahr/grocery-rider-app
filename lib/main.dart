import 'package:flutter/material.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:grocerydelivery/screens/auth/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery-delivery',
      theme: ThemeData(
        primaryColor: primary,
        accentColor: primary,
      ),
      home: Login(),
    );
  }
}
