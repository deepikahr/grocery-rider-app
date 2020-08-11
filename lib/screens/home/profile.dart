import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/main.dart';
import 'package:grocerydelivery/screens/auth/changePassword.dart';
import 'package:grocerydelivery/screens/home/editProfile.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/loader.dart';
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
  Map<String, dynamic> profileInfo;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  SocketService socket;

  List languagesList;
  bool languagesListLoading = false, isProfileLoading = false;

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
        print(value);
        setState(() {
          profileInfo = value['response_data'];
          nameController.text =
              '${profileInfo['firstName']} ${profileInfo['lastName']}';
          countController.text = profileInfo['completedOrder'].toString() ?? 0;
          numberController.text = profileInfo['mobileNumber'] ?? '';
          emailController.text = profileInfo['email'] ?? '';
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
                            Common.setSelectedLanguage(
                                languagesList[i]['languageCode']);
                            main();
                          },
                          type: GFButtonType.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                languagesList[i]['languageName'],
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
          MyLocalizations.of(context).getLocalizations("PROFILE"),
          style: titleWPS(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
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
                              MyLocalizations.of(context)
                                  .getLocalizations("EMAIL_ID", true),
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
                              MyLocalizations.of(context)
                                  .getLocalizations("MOBILE_NUMBER", true),
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
                              MyLocalizations.of(context)
                                  .getLocalizations("ORDER_COMPLETED", true),
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
                                            .getLocalizations("EDIT_PROFILE"),
                                        style: titleSmallBPR(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            languagesList.length > 0
                                ? InkWell(
                                    onTap: () {
                                      selectLanguagesMethod();
                                    },
                                    child: Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF7F7F7),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                                left: 20.0,
                                                right: 20.0),
                                            child: Text(
                                              MyLocalizations.of(context)
                                                  .getLocalizations(
                                                      "SELECT_LANGUAGE"),
                                              style: titleSmallBPR(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
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
                                            .getLocalizations(
                                                "CHANGE_PASSWORD"),
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
          Common.getSelectedLanguage().then((selectedLocale) async {
            Map body = {"language": selectedLocale};
            await AuthService.updateUserInfo(body).then((onValue) {
              Map body = {"playerId": null};
              AuthService.updateUserInfo(body).then((value) async {
                await Common.setToken(null);
                await Common.setAccountID(null);
                main();
              });
            });
          });
        },
        size: GFSize.LARGE,
        child: Text(
          MyLocalizations.of(context).getLocalizations("LOGOUT"),
          style: titleGPBSec(),
        ),
        type: GFButtonType.outline2x,
        color: secondary,
        blockButton: true,
      ),
    );
  }
}
