import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';

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
      print(newPassword);
      print(oldPassword);
      print(confirmPassword);
      if (newPassword == oldPassword) {
        showSnackbar(MyLocalizations.of(context)
            .getLocalizations("DO_NOT_ENTER_SAME_PASS"));
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
                          Navigator.pop(context);
                          Navigator.pop(context);
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
      appBar: GFAppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        title: Text(
          MyLocalizations.of(context).getLocalizations("CHANGE_PASSWORD"),
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
                    onPressed: changePassword,
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
                        isChangePasswordLoading
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
