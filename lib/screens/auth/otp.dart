import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/screens/auth/resetPas.dart';
import 'package:grocerydelivery/services/alert-service.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:grocerydelivery/widgets/appBar.dart';
import 'package:grocerydelivery/widgets/button.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class Otp extends StatefulWidget {
  Otp(
      {Key key,
      this.locale,
      this.localizedValues,
      this.loginTime,
      this.mobileNumber,
      this.sId})
      : super(key: key);
  final String mobileNumber, locale, sId;
  final Map localizedValues;
  final bool loginTime;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String enteredOtp, sid;
  bool isOtpVerifyLoading = false,
      isEmailLoading = false,
      isResentOtpLoading = false;
  @override
  void initState() {
    sid = widget.sId ?? null;
    super.initState();
  }

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
        Map body = {
          "otp": enteredOtp,
          "mobileNumber": widget.mobileNumber.toString()
        };
        if (sid != null) {
          body['sId'] = sid;
        }
        await AuthService.verifyOtp(body).then((onValue) {
          if (mounted) {
            setState(() {
              isOtpVerifyLoading = false;
            });
          }
          if (onValue['response_data'] != null &&
              onValue['verificationToken'] != null) {
            showDialog<Null>(
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return new AlertDialog(
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        new Text('${onValue['response_data'] ?? ""}',
                            style: textBarlowMediumBlack()),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text(
                          MyLocalizations.of(context).getLocalizations("OK"),
                          style: TextStyle(color: green)),
                      onPressed: () {
                        if (widget.loginTime == true) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        } else {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPassword(
                                    token: onValue['verificationToken'],
                                    mobileNumber: widget.mobileNumber,
                                    locale: widget.locale,
                                    localizedValues: widget.localizedValues)),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            );
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
      AlertService().showSnackbar("ENTER_OTP_ERROR", context, _scaffoldKey);
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

    await AuthService.forgetPassword(widget.mobileNumber).then((response) {
      if (mounted) {
        setState(() {
          AlertService()
              .showSnackbar(response['response_data'], context, _scaffoldKey);
          sid = response['sId'] ?? null;
          isResentOtpLoading = false;
        });
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
                          .getLocalizations("OTP_CODE_MSG"),
                      style: textBarlowRegularBlack()),
                  TextSpan(text: '', style: textBarlowMediumGreen()),
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
                      MyLocalizations.of(context)
                          .getLocalizations("RESENT_OTP"),
                      style: textBarlowRegularBlack()),
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
                fields: 6,
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
}
