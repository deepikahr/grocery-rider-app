import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/screens/auth/forgotpassword.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/services/localizations.dart';

import '../../services/auth.dart';
import '../../services/common.dart';
import '../../styles/styles.dart';
import '../home/tabs.dart';

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

  void loginMethod() async {
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
        AuthService.login(body).then((onValue) {
          print(onValue);
          if (onValue['response_data'] != null &&
              onValue['response_data']['token'] != null) {
            if (onValue['response_data']['role'] == 'DELIVERY_BOY') {
              Common.setToken(onValue['response_data']['token'])
                  .then((_) async {
                Common.setAccountID(onValue['response_data']['id']);
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
            } else {
              Common.showSnackbar(_scaffoldKey,
                  '$email ${MyLocalizations.of(context).getLocalizations("AUTHORICATION_ERROR")}');
            }
          } else {
            Common.showSnackbar(_scaffoldKey,
                MyLocalizations.of(context).getLocalizations("WRONG_FORMAT"));
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
          MyLocalizations.of(context).getLocalizations("LOGIN"),
          style: titleWPS(),
        ),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50),
                        Center(
                          child: GFAvatar(
                            backgroundImage:
                                AssetImage('lib/assets/logo/logo.png'),
                            radius: 60,
                          ),
                        ),
                        SizedBox(height: 50),
                        Text(
                          MyLocalizations.of(context)
                              .getLocalizations("EMAIL", true),
                          style: titleSmallBPR(),
                        ),
                        SizedBox(height: 10),
                        buildEmailTextFormField(),
                        SizedBox(height: 25),
                        Text(
                          MyLocalizations.of(context)
                              .getLocalizations("PASSWORD", true),
                          style: titleSmallBPR(),
                        ),
                        SizedBox(height: 10),
                        buildPasswordextFormField(),
                        SizedBox(height: 10),
                        buildForgotPasswordLink(),
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

  Widget buildForgotPasswordLink() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPassword(
              locale: widget.locale,
              localizedValues: widget.localizedValues,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: MyLocalizations.of(context)
                          .getLocalizations("FORGET_PASSWORD") +
                      "?",
                  style: titleSmallBPR()),
              TextSpan(
                text: '',
                style: TextStyle(color: primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailTextFormField() {
    return TextFormField(
      initialValue: Constants.APP_NAME.contains('Readymade')
          ? "delivery1@ionicfirebaseapp.com"
          : null,
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
          return MyLocalizations.of(context).getLocalizations("ERROR_MAIL");
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
      initialValue: Constants.APP_NAME.contains('Readymade') ? "123456" : null,
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
          return MyLocalizations.of(context).getLocalizations("ERROR_PASSWORD");
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
            if (!isLoading) loginMethod();
          },
          size: GFSize.LARGE,
          child: isLoading
              ? GFLoader(
                  type: GFLoaderType.ios,
                )
              : Text(
                  MyLocalizations.of(context).getLocalizations("LOGIN"),
                  style: titleXLargeWPB(),
                ),
          color: secondary,
          blockButton: true,
        ),
      ),
    );
  }
}
