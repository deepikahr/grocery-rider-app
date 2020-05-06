import 'package:flutter/material.dart';
import 'package:grocerydelivery/main.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import '../../models/order.dart';
import '../../models/socket.dart';
import '../../screens/auth/login.dart';
import '../../services/api_service.dart';
import '../../services/common.dart';
import '../../services/socket.dart';
import '../../styles/styles.dart';
import 'package:getflutter/getflutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  Profile({Key key, this.localizedValues, this.locale}) : super(key: key);
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

  var dropdownValue;

  String getLang;
  Map<String, Map<String, String>> localizedValues;

  String selectedLanguages, selectedLang;

  List<String> languages = [
    'English',
    'French',
    'Chinese',
    'Arbic',
    'Japanese',
    'Russian',
    'Italian',
    'Spanish',
    'Portuguese'
  ];

  var selectedLanguage, selectedLocale;

  @override
  void initState() {
    socket = Provider.of<SocketModel>(context, listen: false).getSocketInstance;
    getProfileInfo();
    getLanguages();
    super.initState();
  }

  getLanguages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        selectedLanguage = prefs.getString('selectedLanguage');
      });
    }
    if (selectedLanguage == 'en') {
      selectedLocale = 'English';
    } else if (selectedLanguage == 'fr') {
      selectedLocale = 'French';
    } else if (selectedLanguage == 'zh') {
      selectedLocale = 'Chinese';
    } else if (selectedLanguage == 'ar') {
      selectedLocale = 'Arbic';
    } else if (selectedLanguage == 'ja') {
      selectedLocale = 'Japanese';
    } else if (selectedLanguage == 'ru') {
      selectedLocale = 'Russian';
    } else if (selectedLanguage == 'it') {
      selectedLocale = 'Italian';
    } else if (selectedLanguage == 'es') {
      selectedLocale = 'Spanish';
    } else if (selectedLanguage == 'pt') {
      selectedLocale = 'Portuguese';
    }
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
      if (value['statusCode'] == 401) {
        setState(() {
          profileInfo = {};
        });
      }
    }).catchError((e) {
      setState(() {
        profileInfo = {};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          MyLocalizations.of(context).profile,
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
                  child: SquareLoader(),
                )
              : profileInfo == {}
                  ? buildLogoutButton()
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
                            MyLocalizations.of(context).userName,
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
                                borderSide:
                                    BorderSide(color: greyA, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: greyA, width: 1.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            MyLocalizations.of(context).emailId,
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
                                borderSide:
                                    BorderSide(color: greyA, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: greyA, width: 1.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            MyLocalizations.of(context).mobileNumber,
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
                                borderSide:
                                    BorderSide(color: greyA, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: greyA, width: 1.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Text(
                            MyLocalizations.of(context).ordersCompleted,
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
                                borderSide:
                                    BorderSide(color: greyA, width: 1.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: greyA, width: 1.0),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                MyLocalizations.of(context).selectLanguages,
                                style: titleSmallBPR(),
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: Text(selectedLocale == null
                                      ? 'English'
                                      : selectedLocale),
                                  value: selectedLanguages,
                                  onChanged: (newValue) async {
                                    if (newValue == 'English') {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (mounted) {
                                        setState(() {
                                          prefs.setString(
                                              'selectedLanguage', 'en');
                                        });
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DeliveryApp(
                                              "en",
                                              widget.localizedValues,
                                            ),
                                          ),
                                          (Route<dynamic> route) => false);
                                    } else if (newValue == 'Chinese') {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (mounted) {
                                        setState(() {
                                          prefs.setString(
                                              'selectedLanguage', 'zh');
                                        });
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DeliveryApp(
                                              "zh",
                                              widget.localizedValues,
                                            ),
                                          ),
                                          (Route<dynamic> route) => false);
                                    } else if (newValue == 'Arbic') {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (mounted) {
                                        setState(() {
                                          prefs.setString(
                                              'selectedLanguage', 'ar');
                                        });
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DeliveryApp(
                                              "ar",
                                              widget.localizedValues,
                                            ),
                                          ),
                                          (Route<dynamic> route) => false);
                                    } else if (newValue == 'Japanese') {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (mounted) {
                                        setState(() {
                                          prefs.setString(
                                              'selectedLanguage', 'ja');
                                        });
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DeliveryApp(
                                              "ja",
                                              widget.localizedValues,
                                            ),
                                          ),
                                          (Route<dynamic> route) => false);
                                    } else if (newValue == 'Russian') {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (mounted) {
                                        setState(() {
                                          prefs.setString(
                                              'selectedLanguage', 'ru');
                                        });
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DeliveryApp(
                                              "ru",
                                              widget.localizedValues,
                                            ),
                                          ),
                                          (Route<dynamic> route) => false);
                                    } else if (newValue == 'Italian') {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (mounted) {
                                        setState(() {
                                          prefs.setString(
                                              'selectedLanguage', 'it');
                                        });
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DeliveryApp(
                                              "it",
                                              widget.localizedValues,
                                            ),
                                          ),
                                          (Route<dynamic> route) => false);
                                    } else if (newValue == 'Spanish') {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (mounted) {
                                        setState(() {
                                          prefs.setString(
                                              'selectedLanguage', 'es');
                                        });
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DeliveryApp(
                                              "es",
                                              widget.localizedValues,
                                            ),
                                          ),
                                          (Route<dynamic> route) => false);
                                    } else if (newValue == 'Portuguese') {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (mounted) {
                                        setState(() {
                                          prefs.setString(
                                              'selectedLanguage', 'pt');
                                        });
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DeliveryApp(
                                              "pt",
                                              widget.localizedValues,
                                            ),
                                          ),
                                          (Route<dynamic> route) => false);
                                    } else {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      if (mounted) {
                                        setState(() {
                                          prefs.setString(
                                              'selectedLanguage', 'fr');
                                        });
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                DeliveryApp(
                                              "fr",
                                              widget.localizedValues,
                                            ),
                                          ),
                                          (Route<dynamic> route) => false);
                                    }
                                  },
                                  items: languages.map((lang) {
                                    return DropdownMenuItem(
                                      child: new Text(lang),
                                      value: lang,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
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
                    builder: (BuildContext context) => Login(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues),
                  ),
                  (Route<dynamic> route) => false);
            });
          });
        },
        size: GFSize.LARGE,
        child: Text(
          MyLocalizations.of(context).LOGOUT,
          style: titleGPBSec(),
        ),
        type: GFButtonType.outline2x,
        color: secondary,
        blockButton: true,
      ),
    );
  }
}
