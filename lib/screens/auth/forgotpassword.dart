import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/screens/auth/otp.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:grocerydelivery/widgets/appBar.dart';
import 'package:grocerydelivery/widgets/button.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key key, this.title, this.locale, this.localizedValues})
      : super(key: key);
  final String title, locale;
  final Map localizedValues;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String mobileNumber;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isVerfyEmailLoading = false;

  verifyEmail() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isVerfyEmailLoading = true;
        });
      }
      await AuthService.forgetPassword(mobileNumber).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              isVerfyEmailLoading = false;
            });
          }
          if (onValue['response_data'] != null) {
            showDialog<Null>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return new AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('${onValue['response_data']}',
                            style: textBarlowRegularBlack()),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text(
                        MyLocalizations.of(context).getLocalizations("OK"),
                        style: textbarlowRegularaPrimary(),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Otp(
                              locale: widget.locale,
                              localizedValues: widget.localizedValues,
                              mobileNumber: mobileNumber,
                              sId: onValue['sId'],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          }
        } catch (error) {
          if (mounted) {
            setState(() {
              isVerfyEmailLoading = false;
            });
          }
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isVerfyEmailLoading = false;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          isVerfyEmailLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "FORGET_PASSWORD"),
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 40.0, left: 18.0, bottom: 8.0, right: 20.0),
                child: Text(
                  MyLocalizations.of(context)
                      .getLocalizations("PASSWORD_RESET"),
                  style: textbarlowMediumBlack(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, bottom: 25.0, right: 20.0),
                child: Text(
                  MyLocalizations.of(context)
                      .getLocalizations("FORET_PASS_OTP_MSG"),
                  style: textbarlowRegularBlack(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: GFTypography(
                  showDivider: false,
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: MyLocalizations.of(context)
                                .getLocalizations("MOBILE_NUMBER"),
                            style: textbarlowRegularBlack()),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 5.0, bottom: 10.0, left: 20.0, right: 20.0),
                child: Container(
                  child: TextFormField(
                    onSaved: (String value) {
                      mobileNumber = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ENTER_MOBILE_NUMBER");
                      } else
                        return null;
                    },
                    style: textBarlowRegularBlack(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Color(0xFFF44242))),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
                        contentPadding: EdgeInsets.all(10),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        )),
                  ),
                ),
              ),
              InkWell(
                  onTap: verifyEmail,
                  child:
                      buttonSecondry(context, "SUBMIT", isVerfyEmailLoading)),
            ],
          ),
        ),
      ),
    );
  }
}
