import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/screens/auth/resetPas.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:grocerydelivery/widgets/appBar.dart';
import 'package:grocerydelivery/widgets/button.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class Otp extends StatefulWidget {
  Otp({Key key, this.email, this.locale, this.localizedValues})
      : super(key: key);
  final String email, locale;
  final Map localizedValues;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String enteredOtp;
  bool isOtpVerifyLoading = false,
      isEmailLoading = false,
      isResentOtpLoading = false;

  verifyOTP() async {
    if (enteredOtp != null) {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        if (mounted) {
          setState(() {
            isOtpVerifyLoading = true;
          });
        }
        await AuthService.verifyOtp(enteredOtp, widget.email).then((onValue) {
          try {
            if (mounted) {
              setState(() {
                isOtpVerifyLoading = false;
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
                          new Text(
                            '${onValue['response_data']['message'] ?? ""}',
                            style: textBarlowMediumBlack(),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text(
                          'OK',
                          style: TextStyle(color: green),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(
                                verificationToken: onValue['response_data']
                                    ['verificationToken'],
                                email: widget.email,
                                locale: widget.locale,
                                localizedValues: widget.localizedValues,
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
                isOtpVerifyLoading = false;
              });
            }
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              isOtpVerifyLoading = false;
            });
          }
        });
      } else {
        return;
      }
    } else {
      if (mounted) {
        setState(() {
          isOtpVerifyLoading = false;
        });
      }
      showSnackbar(MyLocalizations.of(context).getLocalizations("OTP_MSG"));
    }
  }

  showAlert(message) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            MyLocalizations.of(context).getLocalizations("ERROR"),
            style: hintSfMediumredsmall(),
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(
                  '$message',
                  style: textBarlowRegularBlack(),
                ),
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  resentOTP() async {
    if (mounted) {
      setState(() {
        isResentOtpLoading = true;
      });
    }

    await AuthService.forgetPassword(widget.email.toLowerCase())
        .then((response) {
      try {
        if (mounted) {
          setState(() {
            isResentOtpLoading = false;
          });
        }
        if (response['response_data'] != null) {
          showSnackbar(response['response_data']);
        }
      } catch (error) {
        if (mounted) {
          setState(() {
            isResentOtpLoading = false;
          });
        }
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isResentOtpLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "WELCOME"),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 15.0, right: 20.0),
            child: Text(
              MyLocalizations.of(context).getLocalizations("VERIFY_OTP"),
              style: textbarlowMediumBlack(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: MyLocalizations.of(context)
                          .getLocalizations("CODE_MSG"),
                      style: textBarlowRegularBlack()),
                  TextSpan(
                    text: ' ${widget.email}',
                    style: textBarlowMediumGreen(),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: resentOTP,
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  child: Text(
                    MyLocalizations.of(context).getLocalizations("RESENT_OTP"),
                    style: textBarlowRegularBlack(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  child: isResentOtpLoading ? SquareLoader() : Container(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 5.0, left: 20.0, right: 20.0),
            child: GFTypography(
              showDivider: false,
              child: Text(
                MyLocalizations.of(context)
                    .getLocalizations("ENTER_VERIFICATION_CODE", true),
                style: textBarlowRegularBlack(),
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Container(
              width: 800,
              child: PinEntryTextField(
                showFieldAsBox: true,
                fieldWidth: 40.0,
                onSubmit: (String pin) {
                  if (mounted) {
                    setState(() {
                      enteredOtp = pin;
                    });
                  }
                },
              ),
            ),
          ),
          InkWell(
              onTap: verifyOTP,
              child: buttonSecondry(context, "SUBMIT", isOtpVerifyLoading)),
        ],
      ),
    );
  }

  void showSnackbar(message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 3000),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
