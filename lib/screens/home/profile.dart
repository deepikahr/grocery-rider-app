import 'dart:convert';

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
  final Map localizedValues;
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

  List languages, languagesCodes;

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
        selectedLocale = prefs.getString('selectedLanguageName');
        print(selectedLocale);
        print("kk");
        languages = json.decode(prefs.getString('alllanguageNames'));
        print(languages);
        languagesCodes = json.decode(prefs.getString('alllanguageCodes'));
        print(languagesCodes);
      });
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
                  ? buildlOGOUTButton()
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
                                  hint: Text(selectedLocale),
                                  value: selectedLanguages,
                                  onChanged: (newValue) async {
                                    if (mounted) {
                                      setState(() {
                                        selectedLocale = newValue;
                                      });
                                    }

                                    for (int i = 0; i < languages.length; i++) {
                                      print(newValue);
                                      print(languages[i]);
                                      if (languages[i] == newValue) {
                                        print("success");
                                        SharedPreferences.getInstance()
                                            .then((prefs) {
                                          prefs.setString('selectedLanguage',
                                              languagesCodes[i]);
                                          Map localizedValues;
                                          String defaultLocale = '';
                                          String locale = prefs.getString(
                                                  'selectedLanguage') ??
                                              defaultLocale;
                                          APIService.getLanguageJson(locale)
                                              .then((value) {
                                            print(value);
                                            localizedValues =
                                                value['response_data']['json'];
                                            if (locale == '') {
                                              defaultLocale =
                                                  value['response_data']
                                                          ['defaultCode']
                                                      ['languageCode'];
                                              locale = defaultLocale;
                                            }
                                            prefs.setString(
                                                'selectedLanguageName',
                                                newValue);
                                            prefs.setString(
                                                'selectedLanguage', locale);
                                            prefs.setString(
                                                'alllanguageNames',
                                                json.encode(
                                                    value['response_data']
                                                        ['langName']));
                                            prefs.setString(
                                                'alllanguageCodes',
                                                json.encode(
                                                    value['response_data']
                                                        ['langCode']));

                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          DeliveryApp(
                                                    locale: locale,
                                                    localizedValues:
                                                        localizedValues,
                                                  ),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                          });
                                        });
                                      }
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
                          buildlOGOUTButton(),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  Widget buildlOGOUTButton() {
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
                    builder: (BuildContext context) => LOGIN(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues),
                  ),
                  (Route<dynamic> route) => false);
            });
          });
        },
        size: GFSize.LARGE,
        child: Text(
          MyLocalizations.of(context).lOGOUT,
          style: titleGPBSec(),
        ),
        type: GFButtonType.outline2x,
        color: secondary,
        blockButton: true,
      ),
    );
  }
}
