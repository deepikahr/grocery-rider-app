import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocerydelivery/models/admin_info.dart';
import 'package:grocerydelivery/models/location.dart';
import 'package:grocerydelivery/models/order.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

class Tracking extends StatefulWidget {
  final String orderID;
  Tracking({Key key, this.orderID}) : super(key: key);
  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  static BitmapDescriptor agentIcon, customerIcon, storeIcon;
  final String googleAPIKey = 'AIzaSyDXxt_aIn5HWQZg3gFYOqcuf8hjUuzmvKg';
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

  @override
  void initState() {
    setSourceAndDestinationIcons();
    location = Provider.of<LocationModel>(context, listen: false).getLocation;
    if (location != null) print('----------------------${location.latitude}');
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
        'lib/assets/icons/current.png');
    storeIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'lib/assets/icons/current.png');
    customerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'lib/assets/icons/locate.png');
    setLatLng();
  }

  void setLatLng() {
    agentLocation = LatLng(12.8718, 77.6022);
    storeLocation = LatLng(adminLocation['lat'], adminLocation['long']);
    storeLocation = LatLng(10.8718, 77.6022);
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
      googleAPIKey,
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
      googleAPIKey,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AdminModel>(builder: (context, admin, child) {
        adminLocation = admin.adminLocation;
        return Consumer<OrderModel>(builder: (context, data, child) {
          order = findOrderByID(data.orders, widget.orderID);
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: data == null
                ? GFLoader(
                    type: GFLoaderType.ios,
                  )
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
                      target: agentLocation ?? LatLng(11.8718, 77.6022),
                    ),
                  ),
          );
        });
      }),
      bottomSheet: SolidBottomSheet(
        headerBar: Container(
            height: 216,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(50),
                  topRight: const Radius.circular(50)),
              color: primary,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(width: 8),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Date: 02/04/2020',
                            style: titleWPM(),
                          ),
                          Text(
                            'Time slot: 11 am to 12 pm',
                            style: titleWPM(),
                          )
                        ],
                      ),
                    ),
                    GFButton(
                      onPressed: () {},
                      text: '00:30:59',
                      textStyle: titleRPM(),
                      icon: Icon(
                        Icons.timer,
                        color: Colors.red,
                      ),
                      color: Colors.white,
                      size: GFSize.LARGE,
                      borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ],
                ),
                Container(
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
                          'Order ID: 242424',
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
                                    'John Doe',
                                    style: titleXLargeBPSB(),
                                  ),
                                  Text(
                                    '9765883412',
                                    style: titleSmallBPR(),
                                  )
                                ],
                              ),
                              InkWell(
                                onTap: () {},
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
                ),
              ],
            )),
        body: Container(
          color: Colors.white,
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 18, bottom: 6),
                    child: Text(
                      'Address',
                      style: titleXSmallBPR(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: greyB),
                      color: greyA,
                    ),
                    alignment: AlignmentDirectional.center,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "176/18 , 22nd main road, Agara, HSR layout, Bangalore",
                          style: titleLargeBPM(),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 18, bottom: 6),
                    child: Text(
                      'Items',
                      style: titleXSmallBPR(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 90,
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
                            Text(
                              "Broccoli (250 gms) X1",
                              style: titleLargeBPM(),
                            ),
                            Text(
                              "Cheese (200gm) X1",
                              style: titleLargeBPM(),
                            )
                          ],
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 18, bottom: 6),
                    child: Text(
                      'Payment',
                      style: titleXSmallBPR(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 80,
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
                              "\$65",
                              style: titleXLargeGPB(),
                            ),
                            Container(
                                height: 50,
                                child: VerticalDivider(
                                    color: Colors.black.withOpacity(0.1))),
                            Text(
                              "Cash on delivery",
                              style: titleLargeBPB(),
                            )
                          ],
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                height: 51,
                child: GFButton(
                  onPressed: () {
//                    Navigator.push( context, MaterialPageRoute(builder: (context) => Entry()), );
                  },
                  size: GFSize.LARGE,
                  text: 'ORDER DELIVERED',
                  textStyle: titleXLargeWPB(),
                  color: secondary,
                  blockButton: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
