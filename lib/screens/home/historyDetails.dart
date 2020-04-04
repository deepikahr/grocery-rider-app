import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:getflutter/getflutter.dart';

class HistoryDetails extends StatefulWidget {
  @override
  _HistoryDetailsState createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Order Details', style: titleWPS(),),
        centerTitle: true,
      ),
      backgroundColor: greyA,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('# Order ID: ', style: subTitleLargeBPM(),),
                    Text('242424', style: subTitleLargeBPM(),)
                  ],
                ),
                Text('02/04/2020', style: subTitleLargeBPM(),)
              ],
            ),
          ),
          GFCard(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('John Doe', style: titleXLargeBPSB(),),
                SizedBox(height: 20,),
                Text('Address', style: titleXSmallBPR(),),
                Text('176/18 , 22nd main road, Agara, HSR layout, Bangalore', style: titleLargeBPM(),),
                SizedBox(height: 20,),
                Text('Items', style: titleXSmallBPR(),),
                Text('Broccoli (250 gms), Cheese (200gm) X1', style: titleLargeBPM(),),
                SizedBox(height: 40,),
                Row(
                  
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        height: 64,
                        decoration: BoxDecoration(
                          border: Border.all(color: greyB),
                          borderRadius: BorderRadius.circular(10),
                          color: greyA
                        ),
                        child: Text('Order delivered at 11:30'),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Column(
                      children: <Widget>[
                        Text('Total', style: titleXSmallBPR(),),
                        Text('\$65',style: titleXLargeGPB(),)
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
