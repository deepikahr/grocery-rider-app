import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocerydelivery/screens/home/entry.dart';
import 'package:grocerydelivery/styles/styles.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Login', style: titleWPS(),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 90),
                        Center(
                            child:
                                Image.asset('lib/assets/icons/logo_outline.png', height: 60,)),
                        Center(
                            child:
                                Text('Delivery boy app', style: titleLargePPB())),
                        SizedBox(height: 50),
                        Text(
                          'User ID', style: titleSmallBPR(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          cursorColor: primary,
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
                        Text('Password', style: titleSmallBPR(),),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          cursorColor: primary,
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
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10.0,
                    child: Container(
                      height: 51,
                      child: GFButton(
                        onPressed: () {
                          Navigator.push( context, MaterialPageRoute(builder: (context) => Entry()), );
                        },
                        size: GFSize.LARGE,
                        text: 'LOGIN',
                        textStyle: titleXLargeWPB(),
                        color: secondary,
                        blockButton: true,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
    );
  }
}
