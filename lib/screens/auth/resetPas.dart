import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/screens/auth/login.dart';
import 'package:grocerydelivery/services/api_service.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';

class ResetPassword extends StatefulWidget {
  final String token, locale;
  final Map localizedValues;
  ResetPassword({Key key, this.token, this.localizedValues, this.locale})
      : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String password1;
  String password2;
  bool success = false, passwordVisible = true, passwordVisible1 = true;

  bool isResetPasswordLoading = false;

  resetPassword() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (mounted) {
        setState(() {
          isResetPasswordLoading = true;
        });
      }
      Map<String, dynamic> body = {"password": password1};
      await APIService.resetPassword(body, widget.token).then((onValue) {
        try {
          if (mounted) {
            setState(() {
              isResetPasswordLoading = false;
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
                          '${onValue['response_data']}',
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
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => LOGIN(
                                locale: widget.locale,
                                localizedValues: widget.localizedValues,
                              ),
                            ),
                            (Route<dynamic> route) => false);
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
              isResetPasswordLoading = false;
            });
          }
        }
      }).catchError((error) {
        if (mounted) {
          setState(() {
            isResetPasswordLoading = false;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          isResetPasswordLoading = false;
        });
      }
      return;
    }
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
          MyLocalizations.of(context).getLocalizations("PASSWORD_RESET"),
          style: titleWPS(),
        ),
        centerTitle: true,
        backgroundColor: primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, bottom: 5.0, right: 20.0),
                child: GFTypography(
                  showDivider: false,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 2.0),
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: MyLocalizations.of(context)
                                  .getLocalizations("ENTER_NEW_PASSWORD", true),
                              style: textBarlowRegularBlack()),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
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
                      suffixIcon: InkWell(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              passwordVisible1 = !passwordVisible1;
                            });
                          }
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ENTER_NEW_PASSWORD");
                      } else if (value.length < 6) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ERROR_PASS");
                      } else
                        return null;
                    },
                    controller: _passwordTextController,
                    onSaved: (String value) {
                      password1 = value;
                    },
                    obscureText: passwordVisible1,
                  ),
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
                                .getLocalizations("RE_ENTER_NEW_PASSWORD"),
                            style: textBarlowRegularBlack()),
                        TextSpan(
                          text: ' ',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 0,
                          color: Color(0xFFF44242),
                        ),
                      ),
                      errorStyle: TextStyle(color: Color(0xFFF44242)),
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          }
                        },
                        child: Icon(
                          Icons.remove_red_eye,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary),
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return MyLocalizations.of(context)
                            .getLocalizations("RE_ENTER_NEW_PASSWORD");
                      } else if (value.length < 6) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ERROR_PASS");
                      } else if (_passwordTextController.text != value) {
                        return MyLocalizations.of(context)
                            .getLocalizations("PASS_NOT_MATCH");
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      password2 = value;
                    },
                    obscureText: passwordVisible,
                  ),
                ),
              ),
              Container(
                height: 55,
                margin:
                    EdgeInsets.only(top: 30, bottom: 20, right: 20, left: 20),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.29), blurRadius: 5)
                ]),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 0.0,
                    right: 0.0,
                  ),
                  child: GFButton(
                    color: secondary,
                    blockButton: true,
                    onPressed: resetPassword,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          MyLocalizations.of(context)
                              .getLocalizations("SUBMIT"),
                          style: titleXLargeWPB(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        isResetPasswordLoading
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
        ),
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
