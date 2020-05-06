import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import '../../models/admin_info.dart';
import '../../models/location.dart';
import '../../models/order.dart';
import '../../models/socket.dart';
import '../../services/common.dart';
import '../../services/socket.dart';
import '../../styles/styles.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class Tracking extends StatefulWidget {
  final String orderID;
  Tracking({Key key, this.orderID}) : super(key: key);
  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static BitmapDescriptor agentIcon, customerIcon, storeIcon;
  static const double CAMERA_ZOOM = 12;
  static const double CAMERA_TILT = 0;
  static const double CAMERA_BEARING = 30;
  static LatLng agentLocation, customerLocation, storeLocation;
  static Map<String, dynamic> order, adminLocation;
  final PolylinePoints polylinePoints = PolylinePoints();
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> polylineCoordinatesForAgentToStore = [];
  final List<LatLng> polylineCoordinatesForStoreToCustomer = [];
  LocationData location;
  String fullName = '', deliveryAddress = '', currency;
  SocketService socket;
  String startButtonText = 'START';

  @override
  void initState() {
    setSourceAndDestinationIcons();
    location = Provider.of<LocationModel>(context, listen: false).getLocation;
    if (location != null) {
      agentLocation = LatLng(location.latitude, location.longitude);
    } else {
      agentLocation = LatLng(12.8718, 77.6022);
    }
    super.initState();
  }

  void _onMapCreated(GoogleMapController ctr) {
    _controller.complete(ctr);
  }

  Map<String, dynamic> findOrderByID(List orders, String orderID) =>
      orders.firstWhere((element) => element['_id'] == orderID);

  void setSourceAndDestinationIcons() async {
    agentIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'lib/assets/icons/agentpin.png');
    storeIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'lib/assets/icons/storepin.png');
    customerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'lib/assets/icons/homepin.png');
    setLatLng();
  }

  void setLatLng() {
    storeLocation = LatLng(adminLocation['lat'], adminLocation['long']);
    customerLocation = LatLng(order['deliveryAddress']['location']['lat'],
        order['deliveryAddress']['location']['long']);
    setMapPins();
  }

  void setMapPins() {
    if (mounted) {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId('agentPin'),
          position: agentLocation,
          icon: agentIcon,
        ));
        _markers.add(Marker(
          markerId: MarkerId('customerPin'),
          position: customerLocation,
          icon: customerIcon,
        ));
        _markers.add(Marker(
          markerId: MarkerId('storePin'),
          position: storeLocation,
          icon: storeIcon,
        ));
      });
    }
    setPolylines();
  }

  void setPolylines() async {
    List<PointLatLng> agentToStore =
        await polylinePoints?.getRouteBetweenCoordinates(
      Constants.GOOGLE_API_KEY,
      agentLocation.latitude,
      agentLocation.longitude,
      storeLocation.latitude,
      storeLocation.longitude,
    );
    if (agentToStore.isNotEmpty) {
      agentToStore.forEach((PointLatLng point) {
        polylineCoordinatesForAgentToStore
            .add(LatLng(point.latitude, point.longitude));
      });
    }
    List<PointLatLng> storeToCustomer =
        await polylinePoints?.getRouteBetweenCoordinates(
      Constants.GOOGLE_API_KEY,
      storeLocation.latitude,
      storeLocation.longitude,
      customerLocation.latitude,
      customerLocation.longitude,
    );
    if (storeToCustomer.isNotEmpty) {
      storeToCustomer.forEach((PointLatLng point) {
        polylineCoordinatesForStoreToCustomer
            .add(LatLng(point.latitude, point.longitude));
      });
    }
    if (mounted) {
      setState(() {
        Polyline polyline = Polyline(
            polylineId: PolylineId('polylineCoordinatesForAgentToStore'),
            color: secondary,
            width: 3,
            points: polylineCoordinatesForAgentToStore);
        _polylines.add(polyline);
      });
    }
    if (mounted) {
      setState(() {
        Polyline polyline = Polyline(
            polylineId: PolylineId('polylineCoordinatesForStoreToCustomer'),
            color: primary,
            width: 3,
            points: polylineCoordinatesForStoreToCustomer);
        _polylines.add(polyline);
      });
    }
  }

  void _initCall(number) async {
    await canLaunch('tel:$number')
        ? launch('tel:$number')
        : Common.showSnackbar(_scaffoldKey, '$number dialing failed');
  }

  void _launchURL(url) async {
    await canLaunch(url)
        ? launch(url)
        : Common.showSnackbar(_scaffoldKey, '$url lauch failed');
  }

  void _launchMap(LatLng location) async {
    var mapSchema = 'geo:${location.latitude},${location.longitude}';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      _launchURL(
          'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');
    }
  }

  @override
  Widget build(BuildContext context) {
    socket = Provider.of<SocketModel>(context, listen: false).getSocketInstance;
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<AdminModel>(builder: (context, admin, child) {
        adminLocation = admin.storeLocation;
        return Consumer<OrderModel>(builder: (context, data, child) {
          order = findOrderByID(data.orders, widget.orderID);
          currency = data.currency;
          if (order['orderStatus'] == 'Out for delivery') {
            startButtonText = 'STARTED';
          }
          String firstName = '', lastName = '';
          if (order['user'] != null && order['user']['firstName'] != null) {
            firstName = order['user']['firstName'];
          }
          if (order['user'] != null && order['user']['lastName'] != null) {
            lastName = order['user']['lastName'];
          }
          fullName = '$firstName $lastName';
          if (order['deliveryAddress'] != null) {
            deliveryAddress =
                '${order['deliveryAddress']['flatNo']}, ${order['deliveryAddress']['apartmentName']}, ${order['deliveryAddress']['address']}';
          }
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: data == null
                ? SquareLoader()
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    padding: EdgeInsets.all(0),
                    markers: _markers,
                    polylines: _polylines,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      zoom: CAMERA_ZOOM,
                      bearing: CAMERA_BEARING,
                      tilt: CAMERA_TILT,
                      target: agentLocation ?? LatLng(12.8718, 77.6022),
                    ),
                  ),
          );
        });
      }),
      bottomSheet: Consumer<OrderModel>(builder: (context, data, child) {
        return SolidBottomSheet(
          headerBar: Container(
              height: 299,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(50),
                    topRight: const Radius.circular(50)),
                color: primary,
              ),
              child: Column(
                children: <Widget>[
                  buildTimingInfoBlock(),
                  buildDirectionBlock(),
                  buildUserDetailsBlock(),
                ],
              )),
          body: Container(
            color: Colors.white,
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: <Widget>[
                buildAddressBox(),
                SizedBox(height: 16),
                buildItemsBlock(),
                SizedBox(height: 16),
                buildPaymentInfoBlock(),
                SizedBox(height: 20),
                buildDeliveredButton(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildTimingInfoBlock() {
    return Row(
      children: <Widget>[
        Container(width: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${MyLocalizations.of(context).date} ${order['deliveryDate']}',
                style: titleWPM(),
              ),
              Text(
                '${MyLocalizations.of(context).timeSlot} ${order['deliveryTime']}',
                style: titleWPM(),
              )
            ],
          ),
        ),
        GFButton(
          onPressed: () {
            if (order['orderStatus'] == 'Confirmed') {
              startButtonText = 'STARTED';
              Common.showSnackbar(
                  _scaffoldKey, 'You have updated status to: Out for delivery');
              socket.updateOrderStatus(
                  socket.getSocket(), 'Out for delivery', widget.orderID);
            }
          },
          text: startButtonText,
          textStyle: titleRPM(startButtonText == 'START' ? red : primary),
          icon: Icon(
            startButtonText == 'START' ? Icons.play_arrow : Icons.check,
            color: startButtonText == 'START' ? red : primary,
          ),
          color: Colors.white,
          size: GFSize.LARGE,
          borderShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ],
    );
  }

  Widget buildDirectionBlock() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25, top: 0),
            child: Text(
              MyLocalizations.of(context).directions,
              style: titleWPM(),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GFButton(
                  onPressed: () {
                    _launchMap(storeLocation);
                  },
                  text: MyLocalizations.of(context).toStore,
                  textStyle: titleRPM(red),
                  icon: Icon(
                    Icons.directions,
                    color: red,
                  ),
                  color: Colors.white,
                  size: GFSize.LARGE,
                  borderShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                GFButton(
                  onPressed: () {
                    _launchMap(customerLocation);
                  },
                  text: MyLocalizations.of(context).toCustomer,
                  textStyle: titleRPM(red),
                  icon: Icon(
                    Icons.directions,
                    color: Colors.red,
                  ),
                  color: Colors.white,
                  size: GFSize.LARGE,
                  borderShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ]),
          SizedBox(height: 10),
        ]);
  }

  Widget buildUserDetailsBlock() {
    return Container(
      height: 142,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(50),
            topRight: const Radius.circular(50)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 6),
            child: Text(
              '${MyLocalizations.of(context).orderId} ${order['orderID']}',
              style: titleXSmallBPR(),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: 78,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: greyB),
              color: greyA,
            ),
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$fullName',
                        style: titleXLargeBPSB(),
                      ),
                      Text(
                        order['user']['mobileNumber'] ?? '',
                        style: titleSmallBPR(),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _initCall(order['user']['mobileNumber'] ?? 0);
                    },
                    child: Container(
                      height: 56,
                      width: 76,
                      decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'lib/assets/icons/phone.png',
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAddressBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 6),
          child: Text(
            MyLocalizations.of(context).address,
            style: titleXSmallBPR(),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          // height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: greyB),
            color: greyA,
          ),
          alignment: AlignmentDirectional.center,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "$deliveryAddress",
                style: titleLargeBPM(),
              )),
        )
      ],
    );
  }

  Widget buildItemsBlock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 6),
          child: Text(
            MyLocalizations.of(context).items,
            style: titleXSmallBPR(),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: greyB),
            color: greyA,
          ),
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: order['cart']['cart'].length,
                      itemBuilder: (BuildContext context, int index) {
                        List products = order['cart']['cart'];
                        return Text(
                          "${products[index]['productName']} (${products[index]['unit']}) X ${products[index]['quantity']}",
                          style: titleLargeBPM(),
                        );
                      }),
                ],
              )),
        )
      ],
    );
  }

  Widget buildPaymentInfoBlock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 18, bottom: 6),
          child: Text(
            MyLocalizations.of(context).payment,
            style: titleXSmallBPR(),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          // height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: greyB),
            color: greyA,
          ),
          alignment: AlignmentDirectional.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "$currency${order['grandTotal']}",
                  style: titleXLargeGPB(),
                ),
                Container(
                    // height: 50,
                    child:
                        VerticalDivider(color: Colors.black.withOpacity(0.1))),
                Text(
                  order['paymentType'] == 'COD' ? 'Cash on delivery' : 'Stripe',
                  style: titleLargeBPB(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildDeliveredButton() {
    return order['orderStatus'] == 'Out for delivery'
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            // height: 51,
            child: GFButton(
              onPressed: () {
                socket.updateOrderStatus(
                    socket.getSocket(), 'DELIVERED', widget.orderID);
                Navigator.of(context).pop();
              },
              size: GFSize.LARGE,
              text: MyLocalizations.of(context).orderDelivered,
              textStyle: titleXLargeWPB(),
              color: secondary,
              blockButton: true,
            ),
          )
        : Container();
  }
}
