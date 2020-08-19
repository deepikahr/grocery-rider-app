import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/button.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/location.dart';
import '../../models/socket.dart';
import '../../services/common.dart';
import '../../services/socket.dart';
import '../../styles/styles.dart';

class Tracking extends StatefulWidget {
  final String orderID;
  final adminData, customerInfo;

  Tracking({Key key, this.orderID, this.adminData, this.customerInfo})
      : super(key: key);

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
  static Map order;
  final PolylinePoints polylinePoints = PolylinePoints();
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> polylineCoordinatesForAgentToStore = [];
  final List<LatLng> polylineCoordinatesForStoreToCustomer = [];
  LocationData location;
  String fullName = '', deliveryAddress = '', currency, mobileNumber;
  SocketService socket;
  String startButtonText = 'START';

  SolidController _soldController = SolidController();
  bool orderDataLoading = false,
      isOrderStatusOutForDeliveryLoading = false,
      isOrderStatusDeliveredLoading = false;

  get cf6a849bad0428d4860deca01a29048fc4a0 => null;

  @override
  void initState() {
    getOrderDetails();
    Common.getCurrency().then((value) {
      currency = value;
    });

    location = Provider.of<LocationModel>(context, listen: false).getLocation;
    if (location != null) {
      agentLocation = LatLng(location.latitude, location.longitude);
    } else {
      agentLocation = LatLng(12.8718, 77.6022);
    }
    super.initState();
  }

  Future<void> getOrderDetails() async {
    if (mounted) {
      setState(() {
        orderDataLoading = true;
      });
    }
    setSourceAndDestinationIcons();
    await APIService.getOrderHistory(widget.orderID).then((value) {
      if (value['response_data'] != null && mounted) {
        setState(() {
          if (mounted) {
            setState(() {
              order = value['response_data'];
              if (order['order']['orderStatus'] == 'OUT_FOR_DELIVERY')
                startButtonText = 'STARTED';

              String firstName = '', lastName = '';
              if (order['order']['user'] != null &&
                  order['order']['user']['firstName'] != null)
                firstName = order['order']['user']['firstName'];
              if (order['order']['user'] != null &&
                  order['order']['user']['lastName'] != null)
                lastName = order['order']['user']['lastName'];
              mobileNumber =
                  order['order']['user']['mobileNumber'].toString() ?? "";
              fullName = '$firstName $lastName';
              if (order['order']['address'] != null) {
                deliveryAddress =
                    '${order['order']['address']['flatNo']}, ${order['order']['address']['apartmentName']}, ${order['order']['address']['address']}';
              }
              orderDataLoading = false;
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            orderDataLoading = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          orderDataLoading = false;
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController ctr) {
    _controller.complete(ctr);
  }

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
    setState(() {
      storeLocation = LatLng(widget.adminData['location']['latitude'],
          widget.adminData['location']['longitude']);
      customerLocation = LatLng(widget.customerInfo['location']['latitude'],
          widget.customerInfo['location']['longitude']);
      setMapPins();
    });
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
      Constants.googleMapApiKey,
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
      Constants.googleMapApiKey,
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
    var mapSchema =
        'google.navigation:q=${location.latitude},${location.longitude}';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      _launchURL(
          'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');
    }
  }

  orderStatusChange(status) {
    Map body = {"status": status};
    APIService.orderStausChange(body, order['order']['_id'].toString())
        .then((value) {
      showSnackbar(value['response_data']);
      if (value['response_data'] != null && mounted) {
        setState(() {
          if (status == "DELIVERED") {
            Navigator.of(context).pop(true);
          } else {
            startButtonText = 'STARTED';
            order['order']['orderStatus'] = "OUT_FOR_DELIVERY";
          }
          isOrderStatusDeliveredLoading = false;
          isOrderStatusOutForDeliveryLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            isOrderStatusDeliveredLoading = false;
            isOrderStatusOutForDeliveryLoading = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          isOrderStatusDeliveredLoading = false;
          isOrderStatusOutForDeliveryLoading = false;
        });
      }
    });
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    socket = Provider.of<SocketModel>(context, listen: false).getSocketInstance;
    return Scaffold(
      key: _scaffoldKey,
      body: orderDataLoading
          ? SquareLoader()
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
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
            ),
      bottomSheet: orderDataLoading
          ? SquareLoader()
          : SolidBottomSheet(
              controller: _soldController,
              draggableBody: true,
              headerBar: Container(
                height: 275,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20)),
                  color: primary,
                ),
                child: Column(
                  children: <Widget>[
                    buildTimingInfoBlock(),
                    buildDirectionBlock(),
                    buildUserDetailsBlock(),
                  ],
                ),
              ),
              body: Container(
                color: Colors.white,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    buildAddressBox(),
                    SizedBox(height: 20),
                    buildItemsBlock(),
                    SizedBox(height: 20),
                    buildPaymentInfoBlock(),
                    SizedBox(height: 20),
                    buildDeliveredButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTimingInfoBlock() {
    return Row(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text(
                        MyLocalizations.of(context)
                            .getLocalizations("DATE", true),
                        style: keyTextWhite()),
                    Text(' ${order['order']['deliveryDate']}',
                        style: titleWPM()),
                  ]),
                  Row(children: <Widget>[
                    Text(
                        MyLocalizations.of(context)
                            .getLocalizations("TIME", true),
                        style: keyTextWhite()),
                    Text(' ${order['order']['deliveryTime']}',
                        style: titleWPM()),
                  ]),
                ])),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: GFButton(
              onPressed: () async {
                if (order['order']['orderStatus'] == "CONFIRMED") {
                  if (mounted) {
                    setState(() {
                      isOrderStatusOutForDeliveryLoading = true;
                      orderStatusChange("OUT_FOR_DELIVERY");
                    });
                  }
                }
              },
              child: isOrderStatusOutForDeliveryLoading
                  ? GFLoader(type: GFLoaderType.ios)
                  : Text(startButtonText == 'START'
                      ? MyLocalizations.of(context).getLocalizations("START")
                      : startButtonText == 'STARTED'
                          ? MyLocalizations.of(context)
                              .getLocalizations("STARTED")
                          : startButtonText),
              textStyle: titleRPM(startButtonText == 'START' ? red : primary),
              icon: Icon(
                startButtonText == 'START' ? Icons.play_arrow : Icons.check,
                color: startButtonText == 'START' ? red : primary,
              ),
              color: Colors.white,
              size: GFSize.MEDIUM,
              borderShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),
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
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Text(
                MyLocalizations.of(context)
                    .getLocalizations("DIRECTIONS", true),
                style: keyTextWhite()),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: GFButton(
                      onPressed: () {
                        _launchMap(storeLocation);
                      },
                      text: MyLocalizations.of(context)
                          .getLocalizations("TO_STORE"),
                      textStyle: titleRPM(red),
                      icon: Icon(Icons.directions, color: red),
                      color: Colors.white,
                      size: GFSize.MEDIUM,
                      borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: GFButton(
                      onPressed: () {
                        _launchMap(customerLocation);
                      },
                      text: MyLocalizations.of(context)
                          .getLocalizations("TO_CUSTOMER"),
                      textStyle: titleRPM(red),
                      icon: Icon(Icons.directions, color: Colors.red),
                      color: Colors.white,
                      size: GFSize.MEDIUM,
                      borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ]),
          SizedBox(height: 5),
        ]);
  }

  Widget buildUserDetailsBlock() {
    return Container(
      height: 123,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 5, right: 10),
            child: Row(children: <Widget>[
              Text(
                  MyLocalizations.of(context)
                      .getLocalizations("ORDER_ID", true),
                  style: keyText()),
              Text('#${order['order']['orderID']}', style: keyValue()),
            ]),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: greyB),
              color: greyA,
            ),
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(fullName, style: keyText()),
                      Text(mobileNumber.toString(), style: titleSmallBPR())
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _initCall(mobileNumber);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(5),
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
          padding: const EdgeInsets.only(left: 20, bottom: 5, right: 15),
          child: Text(
              MyLocalizations.of(context).getLocalizations("ADDRESS", true),
              style: keyText()),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5, right: 15),
          child: Container(
            alignment: AlignmentDirectional.center,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text("$deliveryAddress", style: keyValue())),
          ),
        ),
      ],
    );
  }

  Widget buildItemsBlock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 5, right: 15),
          child: Text(
              MyLocalizations.of(context).getLocalizations("ITEMS", true),
              style: keyText()),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: order['cart']['products'].length,
                itemBuilder: (BuildContext context, int index) {
                  List products = order['cart']['products'];
                  return Text(
                      "${products[index]['productName']} (${products[index]['unit']}) X ${products[index]['quantity']}",
                      style: keyValue());
                }),
          ),
        ),
      ],
    );
  }

  Widget buildPaymentInfoBlock() {
    return Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        MyLocalizations.of(context)
                            .getLocalizations("PAYMENT", true),
                        style: keyText()),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            order['order']['paymentType'] == 'COD'
                                ? MyLocalizations.of(context)
                                    .getLocalizations("CASH_ON_DELIVERY")
                                : order['order']['paymentType'] == 'CARD'
                                    ? MyLocalizations.of(context)
                                        .getLocalizations("PAYBYCARD")
                                    : order['order']['paymentType'],
                            style: titleLargeBPM(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        MyLocalizations.of(context)
                            .getLocalizations("SUB_TOTAL", true),
                        style: keyText()),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            currency +
                                order['cart']['subTotal']
                                    .toDouble()
                                    .toStringAsFixed(2),
                            style: titleLargeBPM(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                order['cart']['tax'] == 0
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("TAX", true),
                              style: keyText()),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  currency +
                                      order['cart']['tax']
                                          .toDouble()
                                          .toStringAsFixed(2),
                                  style: titleLargeBPM(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                order['cart']['deliveryCharges'] == 0
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("DELIVERY_CHARGES", true),
                              style: keyText()),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  currency +
                                      order['cart']['deliveryCharges']
                                          .toDouble()
                                          .toStringAsFixed(2),
                                  style: titleLargeBPM(),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        MyLocalizations.of(context)
                            .getLocalizations("TOTAL", true),
                        style: keyText()),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            currency +
                                order['cart']['grandTotal']
                                    .toDouble()
                                    .toStringAsFixed(2),
                            style: titleLargeBPM(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildDeliveredButton() {
    return order['order']['orderStatus'] == 'OUT_FOR_DELIVERY'
        ? InkWell(
            onTap: () async {
              if (order['order']['orderStatus'] == "OUT_FOR_DELIVERY") {
                if (mounted) {
                  setState(() {
                    isOrderStatusDeliveredLoading = true;
                    orderStatusChange("DELIVERED");
                  });
                }
              }
            },
            child: deliveredButton(
                context, "ORDER_DELIVERED", isOrderStatusDeliveredLoading))
        : Container();
  }
}
