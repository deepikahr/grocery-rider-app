import 'package:flutter/material.dart';
import 'package:grocerydelivery/models/order.dart';
import 'package:grocerydelivery/models/socket.dart';
import 'package:grocerydelivery/screens/auth/login.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/socket.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> profileInfo;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  SocketService socket;

  @override
  void initState() {
    socket = Provider.of<SocketModel>(context, listen: false).getSocketInstance;
    getProfileInfo();
    super.initState();
  }

  void getProfileInfo() {
    countController.text = Provider.of<OrderModel>(context, listen: false)
        .lengthOfDeliveredOrders
        .toString();
    APIService.getUserInfo().then((value) {
      if (value['response_code'] == 200 && mounted) {
        setState(() {
          profileInfo = value['response_data']['userInfo'];
          nameController.text =
              '${profileInfo['firstName']} ${profileInfo['lastName']}';
          numberController.text = profileInfo['mobileNumber'] ?? '';
          emailController.text = profileInfo['email'] ?? '';
        });
      }
    });
  }

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
          profileInfo == null
              ? Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: GFLoader(
                    type: GFLoaderType.ios,
                    size: 100,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 30),
                      Center(
                        child: GFAvatar(
                          backgroundImage: NetworkImage(profileInfo[
                                  'profilePic'] ??
                              'https://cdn.pixabay.com/photo/2020/03/12/19/55/northern-gannet-4926108__340.jpg'),
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
                        enabled: false,
                        controller: nameController,
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
                      Text(
                        'Email ID',
                        style: titleSmallBPR(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        cursorColor: primary,
                        controller: emailController,
                        enabled: false,
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
                        controller: numberController,
                        enabled: false,
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
                      SizedBox(height: 25),
                      Text(
                        'Orders completed',
                        style: titleSmallBPR(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        cursorColor: primary,
                        enabled: false,
                        controller: countController,
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
                      buildLogoutButton(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildLogoutButton() {
    return Container(
      height: 51,
      child: GFButton(
        onPressed: () {
          Common.removeToken().then((value) {
            Common.removeAccountID().then((value) {
              socket.getSocket().destroy();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Login(),
                  ),
                  (Route<dynamic> route) => false);
            });
          });
        },
        size: GFSize.LARGE,
        text: 'LOGOUT',
        textStyle: titleXLargeWPB(),
        color: secondary,
        blockButton: true,
      ),
    );
  }
}
