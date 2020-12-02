import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/screens/auth/login.dart';
import 'package:grocerydelivery/services/alert-service.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:grocerydelivery/widgets/appBar.dart';
import 'package:grocerydelivery/widgets/button.dart';

class ChangePassword extends StatefulWidget {
  final String token, locale;
  final Map localizedValues;

  ChangePassword({Key key, this.token, this.localizedValues, this.locale})
      : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordTextController = TextEditingController();

  String oldPassword, newPassword, confirmPassword;
  bool oldPasswordVisible = true,
      newPasswordVisible = true,
      confirmPasswordVisible = true;

  bool isChangePasswordLoading = false;

  changePassword() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (newPassword == oldPassword) {
        AlertService()
            .showSnackbar("DO_NOT_ENTER_SAME_PASS", context, _scaffoldKey);
      } else {
        if (mounted) {
          setState(() {
            isChangePasswordLoading = true;
          });
        }
        Map<String, dynamic> body = {
          "currentPassword": oldPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword
        };
        await AuthService.changePassword(body).then((onValue) {
          try {
            if (mounted) {
              setState(() {
                isChangePasswordLoading = false;
              });
            }
            AlertService()
                .showSnackbar(onValue['response_data'], context, _scaffoldKey);
            Common.getSelectedLanguage().then((selectedLocale) async {
              Map body = {"language": selectedLocale, "playerId": null};
              AuthService.updateUserInfo(body).then((value) async {
                await Common.setToken(null);
                await Common.setAccountID(null);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => LOGIN(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                      ),
                    ),
                    (Route<dynamic> route) => false);
              });
            });
          } catch (error) {
            if (mounted) {
              setState(() {
                isChangePasswordLoading = false;
              });
            }
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              isChangePasswordLoading = false;
            });
          }
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isChangePasswordLoading = false;
        });
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarPrimary(context, "CHANGE_PASSWORD"),
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
                                  .getLocalizations("ENTER_OLD_PASSWORD", true),
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
                              oldPasswordVisible = !oldPasswordVisible;
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
                            .getLocalizations("ENTER_OLD_PASSWORD");
                      } else if (value.length < 6) {
                        return MyLocalizations.of(context)
                            .getLocalizations("ERROR_PASS");
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      oldPassword = value;
                    },
                    obscureText: oldPasswordVisible,
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
                              newPasswordVisible = !newPasswordVisible;
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
                      newPassword = value;
                    },
                    obscureText: newPasswordVisible,
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
                            text: MyLocalizations.of(context).getLocalizations(
                                "ENTER_CONFIRM_PASSWORD", true),
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
                              confirmPasswordVisible = !confirmPasswordVisible;
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
                            .getLocalizations("ENTER_CONFIRM_PASSWORD");
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
                      confirmPassword = value;
                    },
                    obscureText: confirmPasswordVisible,
                  ),
                ),
              ),
              InkWell(
                  onTap: changePassword,
                  child: buttonSecondry(
                      context, "SUBMIT", isChangePasswordLoading)),
            ],
          ),
        ),
      ),
    );
  }
}
