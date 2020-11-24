import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/main.dart';
import 'package:grocerydelivery/screens/auth/changePassword.dart';
import 'package:grocerydelivery/screens/home/editProfile.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/appBar.dart';
import 'package:grocerydelivery/widgets/button.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:grocerydelivery/widgets/normalText.dart';
import 'package:provider/provider.dart';
import '../../models/socket.dart';
import '../../services/api_service.dart';
import '../../services/common.dart';
import '../../services/socket.dart';
import '../../styles/styles.dart';

class Profile extends StatefulWidget {
  final Map localizedValues;
  final String locale;

  Profile({Key key, this.localizedValues, this.locale}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> profileInfo;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  SocketService socket;
  List languagesList;
  bool languagesListLoading = false, isProfileLoading = false;
  var selectedLanguages;
  @override
  void initState() {
    socket = Provider.of<SocketModel>(context, listen: false).getSocketInstance;
    getProfileInfo();
    getLanguages();
    super.initState();
  }

  getLanguages() async {
    if (mounted) {
      setState(() {
        languagesListLoading = true;
      });
    }
    APIService.getLanguagesList().then((value) {
      if (value['response_data'] != null && mounted) {
        setState(() {
          if (mounted) {
            setState(() {
              languagesList = value['response_data'];
              for (int i = 0; i < languagesList.length; i++) {
                if (languagesList[i]['languageCode'] == widget.locale) {
                  selectedLanguages = languagesList[i]['languageName'];
                }
              }
              languagesListLoading = false;
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            languagesList = [];
            languagesListLoading = false;
          });
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          languagesList = [];
          languagesListLoading = false;
        });
      }
    });
  }

  void getProfileInfo() {
    if (mounted) {
      setState(() {
        isProfileLoading = true;
      });
    }
    AuthService.getUserInfo().then((value) {
      if (value['response_data'] != null && mounted) {
        setState(() {
          profileInfo = value['response_data'];
          nameController.text =
              '${profileInfo['firstName']} ${profileInfo['lastName']}';
          if (profileInfo['orderDelivered'] == null) {
            countController.text = "0";
          } else {
            countController.text = profileInfo['orderDelivered'].toString();
          }
          numberController.text = profileInfo['mobileNumber'].toString() ?? '';
          emailController.text = profileInfo['email'].toString() ?? '';
          isProfileLoading = false;
        });
      }
    }).catchError((e) {
      setState(() {
        profileInfo = {};
        isProfileLoading = false;
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
                      itemCount: languagesList.length == null
                          ? 0
                          : languagesList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return GFButton(
                            onPressed: () async {
                              setState(() {
                                selectedLanguages =
                                    languagesList[i]['languageName'];
                              });
                              await Common.setSelectedLanguage(
                                  languagesList[i]['languageCode']);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DeliveryApp()),
                                  (Route<dynamic> route) => false);
                            },
                            type: GFButtonType.transparent,
                            child: alertText(context,
                                languagesList[i]['languageName'], null));
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
      key: _scaffoldKey,
      appBar: appBar(context, "PROFILE"),
      backgroundColor: Colors.white,
      body: languagesListLoading || isProfileLoading
          ? Center(
              child: SquareLoader(),
            )
          : ListView(
              children: <Widget>[
                profileInfo == {}
                    ? buildlOGOUTButton()
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 30),
                            Center(
                              child: GFAvatar(
                                backgroundImage: profileInfo['imageUrl'] == null
                                    ? AssetImage('lib/assets/logo.png')
                                    : NetworkImage(profileInfo['imageUrl']),
                                radius: 60,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                                MyLocalizations.of(context)
                                    .getLocalizations("USER_NAME", true),
                                style: titleSmallBPR()),
                            SizedBox(height: 10),
                            buildTextField(context, nameController),
                            SizedBox(height: 25),
                            Text(
                                MyLocalizations.of(context)
                                    .getLocalizations("EMAIL_ID", true),
                                style: titleSmallBPR()),
                            SizedBox(height: 10),
                            buildTextField(context, emailController),
                            SizedBox(height: 25),
                            Text(
                                MyLocalizations.of(context)
                                    .getLocalizations("MOBILE_NUMBER", true),
                                style: titleSmallBPR()),
                            SizedBox(height: 10),
                            buildTextField(context, numberController),
                            SizedBox(height: 25),
                            Text(
                                MyLocalizations.of(context)
                                    .getLocalizations("ORDER_COMPLETED", true),
                                style: titleSmallBPR()),
                            SizedBox(height: 10),
                            buildTextField(context, countController),
                            SizedBox(height: 20),
                            InkWell(
                                onTap: () {
                                  var result = Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditProfile(
                                              locale: widget.locale,
                                              localizedValues:
                                                  widget.localizedValues),
                                    ),
                                  );
                                  result.then((value) {
                                    if (value != null) {
                                      socket = Provider.of<SocketModel>(context,
                                              listen: false)
                                          .getSocketInstance;
                                      getProfileInfo();
                                      getLanguages();
                                    }
                                  });
                                },
                                child: buildContainerField(
                                    context, "EDIT_PROFILE")),
                            SizedBox(height: 20),
                            languagesList.length > 0
                                ? InkWell(
                                    onTap: () {
                                      selectLanguagesMethod();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        buildContainerField(
                                            context, "CHANGE_LANGUAGE"),
                                        buildContainerField(
                                            context, selectedLanguages ?? ""),
                                      ],
                                    ))
                                : Container(),
                            SizedBox(height: 20),
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChangePassword(
                                              locale: widget.locale,
                                              localizedValues:
                                                  widget.localizedValues),
                                    ),
                                  );
                                },
                                child: buildContainerField(
                                    context, "CHANGE_PASSWORD")),
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
    return InkWell(
        onTap: () {
          Common.getSelectedLanguage().then((selectedLocale) async {
            Map body = {"language": selectedLocale, "playerId": null};
            AuthService.updateUserInfo(body).then((value) async {
              showSnackbar(MyLocalizations.of(context)
                  .getLocalizations("LOGOUT_SUCCESSFULL"));
              Future.delayed(Duration(milliseconds: 1500), () async {
                await Common.setToken(null);
                await Common.setAccountID(null);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DeliveryApp()),
                    (Route<dynamic> route) => false);
              });
            });
          });
        },
        child: logoutButton(context, "LOGOUT"));
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
