import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import '../../services/common.dart';
import '../../services/auth.dart';
import '../home/tabs.dart';
import '../../styles/styles.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String email, password;
  bool isLoading = false;
  bool isLoggedIn;

  @override
  void initState() {
    checkAUthentication();

    super.initState();
  }

  void checkAUthentication() async {
    await Common.getToken().then((token) {
      if (token != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Tabs(),
            ),
            (Route<dynamic> route) => false);
      } else {
        setState(() {
          isLoggedIn = false;
        });
      }
    });
  }

  void login() async {
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
          if (onValue['response_code'] == 401) {
            Common.showSnackbar(_scaffoldKey, onValue['response_data']);
          } else if (onValue['response_code'] == 200 &&
              onValue['response_data']['token'] != null) {
            if (onValue['response_data']['role'] == 'Delivery Boy') {
              Common.setToken(onValue['response_data']['token']).then((_) {
                Common.setAccountID(onValue['response_data']['_id']).then((_) {
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Tabs(),
                        ),
                        (Route<dynamic> route) => false);
                  }
                });
              });
            } else {
              Common.showSnackbar(_scaffoldKey,
                  '$email is not authorised to login to Delivery App.');
            }
          } else {
            Common.showSnackbar(_scaffoldKey,
                'Something went wrong!, Received Data was in wrong format!');
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
          isLoggedIn == null ? '' : 'Login',
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
                    child: Image.asset(
                  'lib/assets/icons/logo_outline.png',
                  height: 60,
                )),
                Center(
                  child: Text(
                    'Grocery Delivery',
                    style: titleLargePPB(),
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: GFLoader(
                    type: GFLoaderType.ios,
                    size: 70,
                  ),
                )
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
                                  child: Image.asset(
                                'lib/assets/icons/logo_outline.png',
                                height: 60,
                              )),
                              Center(
                                  child: Text('Grocery Delivery',
                                      style: titleLargePPB())),
                              SizedBox(height: 50),
                              Text(
                                'Email',
                                style: titleSmallBPR(),
                              ),
                              SizedBox(height: 10),
                              buildEmailTextFormField(),
                              SizedBox(height: 25),
                              Text(
                                'Password',
                                style: titleSmallBPR(),
                              ),
                              SizedBox(height: 10),
                              buildPasswordextFormField(),
                            ],
                          ),
                        ),
                      ),
                      buildLoginButton()
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildEmailTextFormField() {
    return TextFormField(
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
          return 'Please enter a valid email';
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
          return 'Password should be atleast 6 char long';
        } else
          return null;
      },
      onSaved: (String value) {
        password = value;
      },
    );
  }

  Widget buildLoginButton() {
    return Positioned(
      bottom: 10.0,
      child: Container(
        height: 51,
        child: GFButton(
          onPressed: () {
            if (!isLoading) login();
          },
          size: GFSize.LARGE,
          child: isLoading
              ? GFLoader(
                  type: GFLoaderType.ios,
                )
              : Text(
                  'LOGIN',
                  style: titleXLargeWPB(),
                ),
          color: secondary,
          blockButton: true,
        ),
      ),
    );
  }
}
