import 'package:flutter/material.dart';
import 'package:grocerydelivery/main.dart';
import 'package:grocerydelivery/services/auth.dart';
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
    await Common.getAllLanguageNames().then((value) {
      languages = value;
    });
    await Common.getAllLanguageCodes().then((value) {
      languagesCodes = value;
    });
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

  selectLanguagesMethod() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 250,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(
                  new Radius.circular(24.0),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView(
                children: <Widget>[
                  ListView.builder(
                      padding: EdgeInsets.only(bottom: 25),
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          languages.length == null ? 0 : languages.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GFButton(
                          onPressed: () async {
                            await Common.setSelectedLanguage(languagesCodes[i]);
                            Map localizedValues;
                            String defaultLocale = '';
                            await Common.getSelectedLanguage().then((value) {
                              String locale = value ?? defaultLocale;
                              APIService.getLanguageJson(locale)
                                  .then((value) async {
                                localizedValues =
                                    value['response_data']['json'];
                                if (locale == '') {
                                  defaultLocale = value['response_data']
                                      ['defaultCode']['languageCode'];
                                  locale = defaultLocale;
                                }
                                await Common.setSelectedLanguage(locale);
                                await Common.setAllLanguageCodes(
                                    value['response_data']['langCode']);
                                await Common.setAllLanguageNames(
                                    value['response_data']['langName']);
                                await AuthService.setLanguageCodeToProfile();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DeliveryApp(
                                        locale: locale,
                                        localizedValues: localizedValues,
                                      ),
                                    ),
                                    (Route<dynamic> route) => false);
                              });
                            });
                          },
                          type: GFButtonType.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                languages[i],
                                style: titleSmallBPR(),
                              ),
                              Container()
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
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
                          InkWell(
                            onTap: () {
                              selectLanguagesMethod();
                            },
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                color: Color(0xFFF7F7F7),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0,
                                        bottom: 10.0,
                                        left: 20.0,
                                        right: 20.0),
                                    child: Text(
                                      MyLocalizations.of(context)
                                          .selectLanguages,
                                      style: titleSmallBPR(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
          Map localizedValues;
          String defaultLocale = '';

          String locale = defaultLocale;
          APIService.getLanguageJson(locale).then((value) async {
            localizedValues = value['response_data']['json'];
            if (locale == '') {
              defaultLocale =
                  value['response_data']['defaultCode']['languageCode'];
              locale = defaultLocale;
            }
            await Common.setSelectedLanguage(locale);
            await Common.setAllLanguageCodes(
                value['response_data']['langCode']);
            await Common.setAllLanguageNames(
                value['response_data']['langName']);
            await AuthService.setLanguageCodeToProfile();
            Common.removeToken().then((value) {
              Common.removeAccountID().then((value) {
                socket.getSocket().destroy();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => DeliveryApp(
                        locale: locale,
                        localizedValues: localizedValues,
                      ),
                    ),
                    (Route<dynamic> route) => false);
              });
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
