import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'tracking.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override

  Widget build(BuildContext context) {

    Widget card = GFCard(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      content: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 15,
                    child: SvgPicture.asset(
                      'lib/assets/icons/customer.svg',
                    ),
                  ),
                  Text('Customer: ', style: titleXSmallBPR(),),
                  Text('John Deep', style: titleXSmallBBPR(),)
                ],
              ),
              Text('02/04/2020', style: titleXSmallBPR(),)
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              Container(
                height: 15,
                child: SvgPicture.asset(
                  'lib/assets/icons/hash.svg',
                ),
              ),
              Text('Order ID: ', style: titleXSmallBPR(),),
              Text('242424',style: titleXSmallBBPR(),)
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              Container(
                height: 15,
                child: SvgPicture.asset(
                  'lib/assets/icons/location.svg',
                ),
              ),
              Text('Address: ', style: titleXSmallBPR(),),
            ],
          ),
          Container(
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
              border: Border.all(color: greyB, width: 1),
              borderRadius: BorderRadius.circular(5),
              color: greyA,
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            child: Text('176/18 , 22nd main road, Agara, HSR layout, Bangalore', textAlign: TextAlign.center,
              style: titleBPM(),),
          ),
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Container(
                height: 51,
                child: GFButton(
                  onPressed: () {
                        Navigator.push( context, MaterialPageRoute(builder: (context) => Tracking()), );
                  },
                  size: GFSize.LARGE,
                  text: '     REJECT     ',
                  textStyle: titleGPB(),
                  color: greyB,
                  type: GFButtonType.outline2x,
                ),
              ),
              SizedBox(width: 12,),
              Expanded(
                child: Container(
                  height: 51,
                  child: GFButton(
                    onPressed: () {
                        Navigator.push( context, MaterialPageRoute(builder: (context) => Tracking()), );
                    },
                    size: GFSize.LARGE,
                    text: 'ACCEPT & TRACK',
                    textStyle: titleSPB(),
                    type: GFButtonType.outline2x,
                    color: secondary,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Home', style: titleWPS(),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, ),
            child: Text('Active requests', style: titleBPS(),),
          ),
          card,
          card
        ],
      ),
    );
  }
}
