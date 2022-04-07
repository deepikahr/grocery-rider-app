import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocerydelivery/screens/auth/login.dart';
import 'package:grocerydelivery/screens/enter_location.dart';
import 'package:grocerydelivery/screens/home/tabs.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/locationService.dart';
import 'package:grocerydelivery/styles/styles.dart';

class AddressPickPage extends StatefulWidget {
  final LatLng? initialLocation;
  final Map? localizedValues;
  final String? locale;
  const AddressPickPage({
    Key? key,
    this.initialLocation,
    this.locale,
    this.localizedValues,
  }) : super(key: key);
  @override
  _AddressPickPageState createState() => _AddressPickPageState();
}

class _AddressPickPageState extends State<AddressPickPage> {
  LatLng? initialLocation;
  TextEditingController addressController = TextEditingController();
  late GoogleMapController _controller;
  final locationUtils = LocationUtils();
  @override
  void initState() {
    if (mounted) {
      setState(() {
        initialLocation = widget.initialLocation;
      });
    }
    if (initialLocation != null) {
      fatchLocation(initialLocation);
    }
    super.initState();
  }

  Future<void> fatchLocation(LatLng? location) async {
    final address = await locationUtils.getAddressFromLatLng(location);
    if (mounted) {
      setState(() {
        addressController.text = address.formattedAddress!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(children: [
        Column(children: [
          Expanded(
            child: Container(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(initialLocation?.latitude ?? 12.9716,
                      initialLocation?.longitude ?? 77.5946),
                  zoom: 13.5,
                ),
                markers: {
                  if (initialLocation != null)
                    Marker(
                      markerId: MarkerId('0'),
                      icon: BitmapDescriptor.defaultMarker,
                      position: LatLng(initialLocation!.latitude,
                          initialLocation!.longitude),
                    )
                },
                onMapCreated: (controller) async {
                  _controller = controller;
                },
                onTap: (coordinates) {
                  _controller
                      .animateCamera(CameraUpdate.newLatLng(coordinates));
                  if (mounted) {
                    setState(() {
                      initialLocation = coordinates;
                      fatchLocation(initialLocation);
                    });
                  }
                },
              ),
            ),
          ),
          if (initialLocation != null)
            GFListTile(
              title: Text(
                addressController.text,
                style: textBarlowRegularBlack(),
              ),
              icon: InkWell(
                onTap: () async {
                  await Common.setLocation({
                    'latitude': initialLocation?.latitude,
                    'longitude': initialLocation?.longitude,
                  });
                  await Common.getToken().then((isLoggedIn) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => isLoggedIn != null
                              ? Tabs(
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                )
                              : LoginPage(
                                  locale: widget.locale,
                                  localizedValues: widget.localizedValues,
                                ),
                        ),
                        (Route<dynamic> route) => false);
                  });
                },
                child: Container(
                  decoration:
                      BoxDecoration(color: primary, shape: BoxShape.circle),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ),
            ),
        ]),
        Positioned(
          top: 30,
          right: 20,
          child: InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnterLocationPage(
                    locale: widget.locale,
                    localizedValues: widget.localizedValues,
                  ),
                ),
              ).then((value) {
                if (value != null && mounted) {
                  setState(() {
                    initialLocation = value;
                    fatchLocation(initialLocation);
                  });
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
        ),
      ])),
    );
  }
}
