import 'package:flutter/material.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:getflutter/getflutter.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          'Profile',
          style: titleWPS(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Center(
                  child: GFAvatar(
                    backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2020/03/12/19/55/northern-gannet-4926108__340.jpg'),
//                    backgroundColor: primary,
                    radius: 60,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Username',
                  style: titleSmallBPR(),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  cursorColor: primary,
                  initialValue: 'Steve Rogers',
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: greyA,
                    contentPadding: EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyA, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyA, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Mobile Number',
                  style: titleSmallBPR(),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  cursorColor: primary,
                  initialValue: '9876556532',
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: greyA,
                    contentPadding: EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyA, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyA, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Orders completed',
                  style: titleSmallBPR(),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  cursorColor: primary,
                  initialValue: '57',
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: greyA,
                    contentPadding: EdgeInsets.all(15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyA, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: greyA, width: 1.0),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  height: 51,
                  child: GFButton(
                    onPressed: () {
//                        Navigator.push( context, MaterialPageRoute(builder: (context) => Entry()), );
                    },
                    size: GFSize.LARGE,
                    text: 'LOGOUT',
                    textStyle: titleXLargeWPB(),
                    color: secondary,
                    blockButton: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
