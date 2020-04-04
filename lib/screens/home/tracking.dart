import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Tracking extends StatefulWidget {
  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  SolidController _controller = SolidController();
  GoogleMapController controller;
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  Widget build(BuildContext context) {

    void _modalBottomSheetMenu(){
      showModalBottomSheet(
          context: context,
          builder: (builder){
            return new Container(
              height: 350.0,
              color: Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))),
                  child: new Center(
                    child: new Text("This is a modal sheet"),
                  )),
            );
          }
      );
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(12.916674, 77.5900977),
            zoom: 10.0,
          ),
        ),
      ),
      bottomSheet: SolidBottomSheet(
        headerBar: Container(
            height: 216,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                  topLeft:  const  Radius.circular(50),
                  topRight: const  Radius.circular(50)
              ),
              color: primary,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(width: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Date: 02/04/2020', style: titleWPM(),),
                          Text('Time slot: 11 am to 12 pm', style: titleWPM(),)
                        ],
                      ),
                    ),
                    GFButton(
                      onPressed: (){},
                      text: '00:30:59',
                      textStyle: titleRPM(),
                      icon: Icon(Icons.timer, color: Colors.red,),
                      color: Colors.white,
                      size: GFSize.LARGE,
                      borderShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 142,
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.only(
                        topLeft:  const  Radius.circular(50),
                        topRight: const  Radius.circular(50)
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 18, bottom: 6),
                        child: Text('Order ID: 242424', style: titleXSmallBPR(),),
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
                                  Text('John Doe', style: titleXLargeBPSB(),),
                                  Text('9765883412', style:  titleSmallBPR(),)
                                ],
                              ),
                              InkWell(
                                onTap: (){},
                                child: Container(
                                  height: 56,
                                  width: 76,
                                  decoration: BoxDecoration(
                                    color: secondary,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
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
            )
        ),
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
                    child: Text('Address', style: titleXSmallBPR(),),
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
                      child: Text("176/18 , 22nd main road, Agara, HSR layout, Bangalore", style: titleLargeBPM(),)
                    ),
                  )
                ],
              ),
              SizedBox(height: 16,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 18, bottom: 6),
                    child: Text('Items', style: titleXSmallBPR(),),
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
                            Text("Broccoli (250 gms) X1", style: titleLargeBPM(),),
                            Text("Cheese (200gm) X1", style: titleLargeBPM(),)
                          ],
                        )
                    ),
                  )
                ],
              ),
              SizedBox(height: 16,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 18, bottom: 6),
                    child: Text('Payment', style: titleXSmallBPR(),),
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
                            Text("\$65", style: titleXLargeGPB(),),
                            Container(height: 50, child: VerticalDivider(color: Colors.black.withOpacity(0.1))),
                            Text("Cash on delivery", style: titleLargeBPB(),)
                          ],
                        )
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
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
