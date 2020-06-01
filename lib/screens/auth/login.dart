import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import '../../services/common.dart';
import '../../services/auth.dart';
import '../home/tabs.dart';
import '../../styles/styles.dart';

class LOGIN extends StatefulWidget {
  final Map localizedValues;
  final String locale;
  LOGIN({Key key, this.localizedValues, this.locale}) : super(key: key);
  @override
  _LOGINState createState() => _LOGINState();
}

class _LOGINState extends State<LOGIN> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String email, password;
  bool isLoading = false;
  bool isLoggedIn, isAboutUsData = false;
  Map<String, dynamic> aboutUsDatails;

  @override
  void initState() {
    checkAUthentication();
    getAboutUsData();
    super.initState();
  }

  void getAboutUsData() {
    if (mounted) {
      setState(() {
        isAboutUsData = true;
      });
    }
    APIService.aboutUs().then((value) {
      try {
        if (value['response_code'] == 200) {
          if (mounted) {
            setState(() {
              aboutUsDatails = value['response_data'][0];
              isAboutUsData = false;
            });
          }
        }
      } catch (error, _) {
        if (mounted) {
          setState(() {
            isAboutUsData = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isAboutUsData = false;
        });
      }
    });
  }

  void checkAUthentication() async {
    await Common.getToken().then((token) async {
      if (token != null) {
        await AuthService.setLanguageCodeToProfile();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Tabs(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues),
            ),
            (Route<dynamic> route) => false);
      } else {
        setState(() {
          isLoggedIn = false;
        });
      }
    });
  }

  void lOGIN() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      Common.getPlayerId().then((palyerId) {
        Map<String, dynamic> body = {
          'email': email,
          'password': password,
          "playerId": palyerId ?? 'no id found'
        };
        AuthService.lOGIN(body).then((onValue) {
          if (onValue['response_code'] == 401) {
            Common.showSnackbar(_scaffoldKey, onValue['response_data']);
          } else if (onValue['response_code'] == 200 &&
              onValue['response_data']['token'] != null) {
            if (onValue['response_data']['role'] == 'Delivery Boy') {
              Common.setToken(onValue['response_data']['token']).then((_) {
                Common.setAccountID(onValue['response_data']['_id'])
                    .then((_) async {
                  await AuthService.setLanguageCodeToProfile();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Tabs(
                              locale: widget.locale,
                              localizedValues: widget.localizedValues),
                        ),
                        (Route<dynamic> route) => false);
                  }
                });
              });
            } else {
              Common.showSnackbar(_scaffoldKey,
                  '$email ${MyLocalizations.of(context).authorizationError}');
            }
          } else {
            Common.showSnackbar(
                _scaffoldKey, MyLocalizations.of(context).wrongFormat);
          }
          setState(() {
            isLoading = false;
          });
        }).catchError((onError) {
          setState(() {
            isLoading = false;
          });
          Common.showSnackbar(_scaffoldKey, onError);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          isLoggedIn == null ? '' : MyLocalizations.of(context).lOGIN,
          style: titleWPS(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: isLoggedIn == null
          ? Column(
              children: [
                SizedBox(height: 90),
                Center(
                  child: isAboutUsData
                      ? SquareLoader()
                      : aboutUsDatails['deliveryAppLogo'] != null
                          ? Image.network(
                              aboutUsDatails['deliveryAppLogo']['imageUrl'],
                              height: 100,
                            )
                          : Image.asset(
                              'lib/assets/icons/logo_outline.png',
                              height: 60,
                            ),
                ),
                // Center(
                //   child: Text(
                //     MyLocalizations.of(context).groceryDelivery,
                //     style: titleLargePPB(),
                //   ),
                // ),
                SizedBox(height: 50),
                Padding(
                    padding: EdgeInsets.only(top: 50), child: SquareLoader())
              ],
            )
          : ListView(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 90),
                              Center(
                                child: isAboutUsData
                                    ? SquareLoader()
                                    : aboutUsDatails['deliveryAppLogo'] != null
                                        ? Image.network(
                                            aboutUsDatails['deliveryAppLogo']
                                                ['imageUrl'],
                                            height: 100,
                                          )
                                        : Image.asset(
                                            'lib/assets/icons/logo_outline.png',
                                            height: 60,
                                          ),
                              ),
                              // Center(
                              //     child: Text(
                              //         MyLocalizations.of(context)
                              //             .groceryDelivery,
                              //         style: titleLargePPB())),
                              SizedBox(height: 50),
                              Text(
                                MyLocalizations.of(context).emailId,
                                style: titleSmallBPR(),
                              ),
                              SizedBox(height: 10),
                              buildEmailTextFormField(),
                              SizedBox(height: 25),
                              Text(
                                MyLocalizations.of(context).password,
                                style: titleSmallBPR(),
                              ),
                              SizedBox(height: 10),
                              buildPasswordextFormField(),
                            ],
                          ),
                        ),
                      ),
                      buildlOGINButton()
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildEmailTextFormField() {
    return TextFormField(
      initialValue: "delivery1@ionicfirebaseapp.com",
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
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greyA, width: 1.0),
        ),
        errorStyle: titleVerySamllPPB(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty || !RegExp(Common.emailPattern).hasMatch(value)) {
          return MyLocalizations.of(context).errorEmail;
        } else
          return null;
      },
      onSaved: (String value) {
        email = value;
      },
    );
  }

  Widget buildPasswordextFormField() {
    return TextFormField(
      initialValue: "123456",
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
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greyA, width: 1.0),
        ),
        errorStyle: titleVerySamllPPB(),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return MyLocalizations.of(context).errorPassword;
        } else
          return null;
      },
      onSaved: (String value) {
        password = value;
      },
    );
  }

  Widget buildlOGINButton() {
    return Positioned(
      bottom: 10.0,
      child: Container(
        height: 51,
        child: GFButton(
          onPressed: () {
            if (!isLoading) lOGIN();
          },
          size: GFSize.LARGE,
          child: isLoading
              ? SquareLoader()
              : Text(
                  MyLocalizations.of(context).lOGIN,
                  style: titleXLargeWPB(),
                ),
          color: secondary,
          blockButton: true,
        ),
      ),
    );
  }
}
