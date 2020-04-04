import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'historyDetails.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override

  Widget build(BuildContext context) {

    Widget card = InkWell(
      onTap:(){
        Navigator.push( context, MaterialPageRoute(builder: (context) => HistoryDetails()), );
      },
      child: GFCard(
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
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('History', style: titleWPS(),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, ),
            child: Text('Completed requests', style: titleBPS(),),
          ),
          card,
          card
        ],
      ),
    );
  }
}
