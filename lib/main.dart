import 'package:flutter/material.dart';
import 'package:grocerydelivery/models/admin_info.dart';
import 'package:grocerydelivery/models/location.dart';
import 'package:grocerydelivery/models/order.dart';
import 'package:grocerydelivery/models/socket.dart';
import 'package:provider/provider.dart';
import './styles/styles.dart';
import './screens/auth/login.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OrderModel()),
        ChangeNotifierProvider(create: (context) => AdminModel()),
        ChangeNotifierProvider(create: (context) => SocketModel()),
        ChangeNotifierProvider(create: (context) => LocationModel()),
      ],
      child: DeliveryApp(),
    ),
  );
}

class DeliveryApp extends StatefulWidget {
  @override
  _DeliveryAppState createState() => _DeliveryAppState();
}

class _DeliveryAppState extends State<DeliveryApp> {
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
