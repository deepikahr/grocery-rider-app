import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/screens/auth/resetPas.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class Otp extends StatefulWidget {
  Otp({Key key, this.email, this.token, this.locale, this.localizedValues})
      : super(key: key);
  final String email, token, locale;
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
        Map<String, dynamic> body = {"otp": enteredOtp};
        await APIService.verifyOtp(body, widget.token).then((onValue) {
          try {
            if (mounted) {
              setState(() {
                isOtpVerifyLoading = false;
              });
            }
            if (onValue['response_code'] == 200) {
              showDialog<Null>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return new AlertDialog(
                    content: new SingleChildScrollView(
                      child: new ListBody(
                        children: <Widget>[
                          new Text(
                            '${onValue['response_data']['message']}',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPassword(
                                token: onValue['response_data']['token'],
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
            } else if (onValue['response_code'] == 401) {
              showSnackbar('${onValue['response_data']}');
            } else {
              showSnackbar('${onValue['response_data']}');
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
      showSnackbar(MyLocalizations.of(context).pleaseEnter4DigitOTP);
    }
  }

  showAlert(message) {
    showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(
            MyLocalizations.of(context).error,
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
                MyLocalizations.of(context).ok,
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
    Map body = {
      "email": widget.email,
    };
    await APIService.verifyEmail(body).then((response) {
      try {
        if (mounted) {
          setState(() {
            isResentOtpLoading = false;
          });
        }
        if (response['response_code'] == 200) {
          showSnackbar(response['response_data']['message']);
        } else {
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
      appBar: GFAppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Text(
          MyLocalizations.of(context).welcome,
          style: titleWPS(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 15.0, right: 20.0),
            child: Text(
              MyLocalizations.of(context).verifyOtp,
              style: textbarlowMediumBlack(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: MyLocalizations.of(context).wehavesenta4digitcodeto,
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
                    MyLocalizations.of(context).resentOTP,
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
                MyLocalizations.of(context).enterVerificationcode,
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
          Container(
            height: 55,
            margin: EdgeInsets.only(top: 30, bottom: 20, right: 20, left: 20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.29), blurRadius: 5)
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 0.0,
                right: 0.0,
              ),
              child: GFButton(
                color: secondary,
                blockButton: true,
                onPressed: verifyOTP,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      MyLocalizations.of(context).submitOTP,
                      style: titleXLargeWPB(),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    isOtpVerifyLoading
                        ? GFLoader(
                            type: GFLoaderType.ios,
                          )
                        : Text("")
                  ],
                ),
                textStyle: textBarlowRegularrBlack(),
              ),
            ),
          ),
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
