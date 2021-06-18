import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/screens/auth/forgotpassword.dart';
import 'package:grocerydelivery/screens/auth/otp.dart';
import 'package:grocerydelivery/services/alert-service.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/widgets/appBar.dart';
import 'package:grocerydelivery/widgets/button.dart';

import '../../services/auth.dart';
import '../../services/common.dart';
import '../../styles/styles.dart';
import '../home/tabs.dart';

class LOGIN extends StatefulWidget {
  final Map? localizedValues;
  final String? locale;

  LOGIN({Key? key, this.localizedValues, this.locale}) : super(key: key);

  @override
  _LOGINState createState() => _LOGINState();
}

class _LOGINState extends State<LOGIN> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? userName, password;
  bool isLoading = false;

  void loginMethod() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      Common.getPlayerId().then((palyerId) {
        Map body = {
          'userName': userName,
          'password': password,
          "playerId": palyerId ?? 'no id found'
        };
        AuthService.login(body).then((onValue) {
          if (onValue['response_code'] == 205) {
            showAlert(onValue['response_data'], userName);
          } else if (onValue['response_data'] != null &&
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
                            locale: widget.locale!,
                            localizedValues: widget.localizedValues!),
                      ),
                      (Route<dynamic> route) => false);
                }
              });
            } else {
              AlertService().showSnackbar(
                  '$userName ${MyLocalizations.of(context)!.getLocalizations("AUTHORICATION_ERROR")}',
                  context,
                  _scaffoldKey);
            }
          } else {
            AlertService().showSnackbar("WRONG_FORMAT", context, _scaffoldKey);
          }
          setState(() {
            isLoading = false;
          });
        }).catchError((onError) {
          setState(() {
            isLoading = false;
          });
        });
      });
    }
  }

  showAlert(message, mobileNumber) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            message,
            style: hintSfMediumredsmall(),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                MyLocalizations.of(context)!.getLocalizations("CANCEL"),
                style: textbarlowRegularaPrimary(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                MyLocalizations.of(context)!.getLocalizations("SEND_OTP"),
                style: textbarlowRegularaPrimary(),
              ),
              onPressed: () {
                AuthService.forgetPassword(mobileNumber).then((response) {
                  AlertService().showSnackbar(
                      response['response_data'], context, _scaffoldKey);
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Otp(
                          locale: widget.locale!,
                          localizedValues: widget.localizedValues!,
                          loginTime: true,
                          mobileNumber: mobileNumber,
                          sId: response['sId']),
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "LOGIN") as PreferredSizeWidget?,
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
                                    AssetImage('lib/assets/logo.png'),
                                radius: 60)),
                        SizedBox(height: 30),
                        Text(
                            MyLocalizations.of(context)!.getLocalizations(
                                "EMAIL_OR_MOBILE_NUMBER", true),
                            style: titleSmallBPR()),
                        SizedBox(height: 10),
                        buildEmailOrMobileNumberTextFormField(),
                        SizedBox(height: 25),
                        Text(
                            MyLocalizations.of(context)!
                                .getLocalizations("PASSWORD", true),
                            style: titleSmallBPR()),
                        SizedBox(height: 10),
                        buildPasswordextFormField(),
                        SizedBox(height: 10),
                        buildForgotPasswordLink(),
                        SizedBox(height: 10),
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
                  text: MyLocalizations.of(context)!
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

  Widget buildEmailOrMobileNumberTextFormField() {
    return TextFormField(
      initialValue: Constants.predefined == "true"
          ? "delivery1@ionicfirebaseapp.com"
          : null,
      cursorColor: primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: greyA,
        contentPadding: EdgeInsets.all(15),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: greyA, width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: greyA, width: 1.0)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: greyA, width: 1.0)),
        errorStyle: titleVerySamllPPB(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value!.isEmpty) {
          return MyLocalizations.of(context)!
              .getLocalizations("ENTER_EMAIL_OR_MOBILE_NUMBER");
        } else
          return null;
      },
      onSaved: (String? value) {
        userName = value;
      },
    );
  }

  Widget buildPasswordextFormField() {
    return TextFormField(
      initialValue: Constants.predefined == "true" ? "123456" : null,
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
      validator: (String? value) {
        if (value!.isEmpty || value.length < 6) {
          return MyLocalizations.of(context)!.getLocalizations("ERROR_PASSWORD");
        } else
          return null;
      },
      onSaved: (String? value) {
        password = value;
      },
    );
  }

  Widget buildlOGINButton() {
    return Positioned(
      bottom: 10.0,
      child: InkWell(
        onTap: () {
          if (!isLoading) loginMethod();
        },
        child: loginButton(context, "LOGIN", isLoading),
      ),
    );
  }
}
