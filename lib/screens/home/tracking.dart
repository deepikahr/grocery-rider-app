import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocerydelivery/services/alert-service.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/button.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:grocerydelivery/widgets/normalText.dart';
import 'package:provider/provider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/location.dart';
import '../../models/socket.dart';
import '../../services/common.dart';
import '../../services/socket.dart';
import '../../styles/styles.dart';

class Tracking extends StatefulWidget {
  final String? orderID;
  final adminData, customerInfo;

  Tracking({Key? key, this.orderID, this.adminData, this.customerInfo})
      : super(key: key);

  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static BitmapDescriptor? agentIcon, customerIcon, storeIcon;
  static const double CAMERA_ZOOM = 12;
  static const double CAMERA_TILT = 0;
  static const double CAMERA_BEARING = 30;
  static LatLng? agentLocation, customerLocation, storeLocation;
  static Map? order;
  final PolylinePoints polylinePoints = PolylinePoints();
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> polylineCoordinatesForAgentToStore = [];
  final List<LatLng> polylineCoordinatesForStoreToCustomer = [];
  LatLng? location;
  String? fullName = '', deliveryAddress = '', currency, mobileNumber;
  SocketService? socket;
  String startButtonText = 'START';

  SolidController _soldController = SolidController();
  bool orderDataLoading = false,
      isOrderStatusOutForDeliveryLoading = false,
      isOrderStatusDeliveredLoading = false;

  get cf6a849bad0428d4860deca01a29048fc4a0 => null;

  @override
  void initState() {
    getOrderDetails();
    Common.getCurrency().then((value) => setState(() => currency = value));

    location = Provider.of<LocationModel>(context, listen: false).getLocation;
    setState(() {
      if (location != null) {
        agentLocation = LatLng(location!.latitude, location!.longitude);
      } else {
        agentLocation = LatLng(12.8718, 77.6022);
      }
    });
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
              if (order!['order']['orderStatus'] == 'OUT_FOR_DELIVERY')
                startButtonText = 'STARTED';

              String? firstName = '', lastName = '';
              if (order!['order']['user'] != null &&
                  order!['order']['user']['firstName'] != null)
                firstName = order!['order']['user']['firstName'];
              if (order!['order']['user'] != null &&
                  order!['order']['user']['lastName'] != null)
                lastName = order!['order']['user']['lastName'];
              mobileNumber = '${order!['order']['user']['mobileNumber'] ?? ""}';
              fullName = '$firstName $lastName';
              if (order!['order']['address'] != null) {
                deliveryAddress =
                    '${order!['order']['address']['flatNo']}, ${order!['order']['address']['apartmentName']}, ${order!['order']['address']['address']}';
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
    agentIcon = BitmapDescriptor.fromBytes(
      await getBytesFromAsset('lib/assets/icons/agentpin.png', 50),
    );
    storeIcon = BitmapDescriptor.fromBytes(
      await getBytesFromAsset('lib/assets/icons/storepin.png', 50),
    );
    customerIcon = BitmapDescriptor.fromBytes(
      await getBytesFromAsset('lib/assets/icons/homepin.png', 50),
    );
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
          position: agentLocation!,
          icon: agentIcon!,
        ));
        _markers.add(Marker(
          markerId: MarkerId('customerPin'),
          position: customerLocation!,
          icon: customerIcon!,
        ));
        _markers.add(Marker(
          markerId: MarkerId('storePin'),
          position: storeLocation!,
          icon: storeIcon!,
        ));
      });
    }
    setPolylines();
  }

  void setPolylines() async {
    var agentToStore = await polylinePoints.getRouteBetweenCoordinates(
      Constants.googleMapApiKey!,
      PointLatLng(agentLocation!.latitude, agentLocation!.longitude),
      PointLatLng(storeLocation!.latitude, storeLocation!.longitude),
    );

    if (agentToStore.points.isNotEmpty) {
      agentToStore.points.forEach((PointLatLng point) {
        polylineCoordinatesForAgentToStore
            .add(LatLng(point.latitude, point.longitude));
      });
    }
    var storeToCustomer = await polylinePoints.getRouteBetweenCoordinates(
        Constants.googleMapApiKey!,
        PointLatLng(storeLocation!.latitude, storeLocation!.longitude),
        PointLatLng(customerLocation!.latitude, customerLocation!.longitude));
    if (storeToCustomer.points.isNotEmpty) {
      storeToCustomer.points.forEach((PointLatLng point) {
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
        : AlertService()
            .showSnackbar('$number dialing failed', context, _scaffoldKey);
  }

  void _launchURL(url) async {
    await canLaunch(url)
        ? launch(url)
        : AlertService()
            .showSnackbar('$url lauch failed', context, _scaffoldKey);
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
    APIService.orderStausChange(body, order!['order']['_id'].toString())
        .then((value) {
      AlertService()
          .showSnackbar(value['response_data'], context, _scaffoldKey);
      if (value['response_data'] != null && mounted) {
        setState(() {
          if (status == "DELIVERED") {
            Navigator.of(context).pop(true);
          } else {
            startButtonText = 'STARTED';
            order!['order']['orderStatus'] = "OUT_FOR_DELIVERY";
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

  @override
  Widget build(BuildContext context) {
    socket = Provider.of<SocketModel>(context, listen: false).getSocketInstance;
    return Scaffold(
      key: _scaffoldKey,
      body: orderDataLoading
          ? SquareLoader()
          : Stack(
              children: [
                Container(
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
                Positioned(
                  top: 45,
                  left: 20,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.black26,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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
              body: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  buildAddressBox(),
                  SizedBox(height: 20),
                  buildItemsBlock(),
                  SizedBox(height: 20),
                  buildPaymentInfoBlock(),
                  SizedBox(height: 20),
                  buildDeliveredButton(),
                  SizedBox(height: 300),
                ],
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
                        MyLocalizations.of(context)!
                            .getLocalizations("DATE", true),
                        style: keyTextWhite()),
                    Text(' ${order!['order']['deliveryDate']}',
                        style: titleWPM()),
                  ]),
                  Row(children: <Widget>[
                    Text(
                        MyLocalizations.of(context)!
                            .getLocalizations("TIME", true),
                        style: keyTextWhite()),
                    Text(' ${order!['order']['deliveryTime']}',
                        style: titleWPM()),
                  ]),
                ])),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: InkWell(
                onTap: () {
                  if (order!['order']['orderStatus'] == "CONFIRMED") {
                    if (mounted) {
                      setState(() {
                        isOrderStatusOutForDeliveryLoading = true;
                        orderStatusChange("OUT_FOR_DELIVERY");
                      });
                    }
                  }
                },
                child: startAndStartedButton(context, startButtonText,
                    isOrderStatusOutForDeliveryLoading),
              )),
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
                MyLocalizations.of(context)!
                    .getLocalizations("DIRECTIONS", true),
                style: keyTextWhite()),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: InkWell(
                      onTap: () {
                        _launchMap(storeLocation!);
                      },
                      child: mapButton(context, "TO_STORE"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: InkWell(
                      onTap: () {
                        _launchMap(customerLocation!);
                      },
                      child: mapButton(context, "TO_CUSTOMER"),
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
                  MyLocalizations.of(context)!
                      .getLocalizations("ORDER_ID", true),
                  style: keyText()),
              Text('#${order!['order']['orderID']}', style: keyValue()),
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
                      Text(fullName!, style: keyText()),
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
              MyLocalizations.of(context)!.getLocalizations("ADDRESS", true),
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
              MyLocalizations.of(context)!.getLocalizations("ITEMS", true),
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
                itemCount: order!['cart']['products'].length,
                itemBuilder: (BuildContext context, int index) {
                  List products = order!['cart']['products'];
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
                orderSummary(
                    context, "PAYMENT", order!['order']['paymentType']),
                orderSummary(context, "SUB_TOTAL",
                    "$currency${order!['cart']['subTotal'].toDouble().toStringAsFixed(2)}"),
                order!['cart']['tax'] == 0
                    ? Container()
                    : orderSummary(context, "TAX",
                        "$currency${order!['cart']['tax'].toDouble().toStringAsFixed(2)}"),
                order!['cart']['deliveryCharges'] == 0
                    ? Container()
                    : orderSummary(context, "DELIVERY_CHARGES",
                        "$currency${order!['cart']['deliveryCharges'].toDouble().toStringAsFixed(2)}"),
                order!['cart']['couponAmount'] == 0
                    ? Container()
                    : orderSummary(context, "DISCOUNT",
                        "$currency${order!['cart']['couponAmount'].toDouble().toStringAsFixed(2)}"),
                order!['cart']['walletAmount'] == 0
                    ? Container()
                    : orderSummary(context, "WALLET",
                        "$currency${order!['cart']['walletAmount'].toDouble().toStringAsFixed(2)}"),
                Divider(),
                orderSummary(context, "TOTAL",
                    "$currency${order!['cart']['grandTotal'].toDouble().toStringAsFixed(2)}"),
                Divider(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildDeliveredButton() {
    return order!['order']['orderStatus'] == 'OUT_FOR_DELIVERY'
        ? InkWell(
            onTap: () async {
              if (order!['order']['orderStatus'] == "OUT_FOR_DELIVERY") {
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
