import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:grocerydelivery/services/auth.dart';
import 'package:grocerydelivery/services/common.dart';
import 'package:grocerydelivery/services/constants.dart';
import 'package:grocerydelivery/services/localizations.dart';
import 'package:grocerydelivery/styles/styles.dart';
import 'package:grocerydelivery/widgets/loader.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:ui';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> userInfo;
  final Map localizedValues;
  final String locale;
  EditProfile({Key key, this.userInfo, this.locale, this.localizedValues})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> userInfo;
  bool isLoading = false, isPicUploading = false, profileEdit = false;
  String firstName, lastName, mobileNumber;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var image;
  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await AuthService.getUserInfo().then((onValue) {
      if (mounted) {
        setState(() {
          isLoading = false;
          userInfo = onValue['response_data'];
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          userInfo = null;
          isLoading = false;
        });
      }
    });
  }

  updateUserInfo(url, key, filePath) async {
    var body = {"imageUrl": url, "imageId": key, "filePath": filePath};

    await AuthService.updateUserInfo(body).then((onValue) {
      if (mounted) {
        setState(() {
          isPicUploading = false;
        });
      }
      showSnackbar(onValue['response_data']);
      Future.delayed(Duration(milliseconds: 2500), () {
        Navigator.of(context).pop(true);
      });
      getUserInfo();
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isPicUploading = false;
        });
      }
    });
  }

  updateUserInformation() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      return;
    } else {
      form.save();
      if (mounted) {
        setState(() {
          profileEdit = true;
        });
      }

      Map<String, dynamic> body = {
        "firstName": firstName,
        "lastName": lastName,
        "mobileNumber": mobileNumber
      };

      await AuthService.updateUserInfo(body).then((onValue) {
        if (mounted) {
          setState(() {
            profileEdit = false;
          });
        }
        showSnackbar(onValue['response_data']);
        Future.delayed(Duration(milliseconds: 2500), () {
          Navigator.of(context).pop(true);
        });
      }).catchError((error) {
        if (mounted) {
          setState(() {
            profileEdit = false;
          });
        }
      });
    }
  }

  selectGallary() async {
    // ignore: deprecated_member_use
    image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        isPicUploading = true;
      });
    }
    imageUpload(image);
  }

  selectCamera() async {
    // ignore: deprecated_member_use
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (mounted) {
      setState(() {
        isPicUploading = true;
      });
    }
    imageUpload(image);
  }

  imageUpload(_imageFile) async {
    Navigator.pop(context);
    var stream =
        // ignore: deprecated_member_use
        new http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));

    int length = await _imageFile.length();
    String uri = Constants.apiURL + '/users/upload/image';

    dynamic request = new http.MultipartRequest("POST", Uri.parse(uri));

    dynamic multipartFile = new http.MultipartFile('file', stream, length,
        filename: path.basename(_imageFile.path));

    await request.files.add(multipartFile);
    String token;

    await Common.getToken().then((onValue) {
      token = onValue;
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isPicUploading = false;
        });
      }
    });

    request.headers['Authorization'] = 'bearer $token';
    await request.send().then((response) async {
      await response.stream.transform(utf8.decoder).listen((value) async {
        Map<String, dynamic> data;
        data = json.decode(value);
        print(data);
        updateUserInfo(data['response_data']['url'],
            data['response_data']['key'], data['response_data']['filePath']);
      });
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isPicUploading = true;
        });
      }
    });
  }

  selectImage() async {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: 220,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(
                  new Radius.circular(24.0),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      MyLocalizations.of(context).getLocalizations("SELECT"),
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  GFButton(
                    onPressed: selectCamera,
                    type: GFButtonType.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          MyLocalizations.of(context)
                              .getLocalizations("TAKE_PHOTO"),
                          style: hintSfboldBig(),
                        ),
                        Icon(Icons.camera_alt),
                      ],
                    ),
                  ),
                  GFButton(
                    onPressed: selectGallary,
                    type: GFButtonType.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          MyLocalizations.of(context)
                              .getLocalizations("CHOOSE_FROM_PHOTOS"),
                          style: hintSfboldBig(),
                        ),
                        Icon(Icons.image),
                      ],
                    ),
                  ),
                  userInfo['filePath'] != null && userInfo['imageUrl'] != null
                      ? GFButton(
                          onPressed: removeImage,
                          type: GFButtonType.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                MyLocalizations.of(context)
                                    .getLocalizations("REMOVE_PHOTO"),
                                style: hintSfboldBig(),
                              ),
                              Icon(Icons.delete_forever),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  removeImage() {
    if (mounted) {
      setState(() {
        isPicUploading = true;
      });
    }
    AuthService.imagedelete().then((value) {
      if (mounted) {
        setState(() {
          isPicUploading = false;
          showSnackbar(value['response_data']);
          updateUserInfo(null, null, null);
          Future.delayed(Duration(milliseconds: 2500), () {
            Navigator.of(context).pop(true);
          });
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isPicUploading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primary,
        title: Text(
          MyLocalizations.of(context).getLocalizations("EDIT_PROFILE"),
          style: titleWPS(),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? SquareLoader()
          : Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 250,
                    child: Stack(
                      children: <Widget>[
                        image == null
                            ? userInfo['filePath'] == null &&
                                    userInfo['imageUrl'] == null
                                ? Center(
                                    child: new Container(
                                      width: 200.0,
                                      height: 200.0,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new AssetImage(
                                              'lib/assets/logo.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: new Container(
                                      width: 200.0,
                                      height: 200.0,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new NetworkImage(
                                              userInfo['filePath'] == null
                                                  ? userInfo['imageUrl']
                                                  : Constants.imageKitUrl +
                                                      "/tr:dpr-auto,tr:w-500" +
                                                      userInfo['filePath']),
                                        ),
                                      ),
                                    ),
                                  )
                            : isPicUploading
                                ? SquareLoader()
                                : Center(
                                    child: new Container(
                                      width: 200.0,
                                      height: 200.0,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: new FileImage(image),
                                        ),
                                      ),
                                    ),
                                  ),
                        Positioned(
                          left: 250,
                          top: 190,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: secondary,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: IconButton(
                              onPressed: selectImage,
                              icon: Icon(Icons.camera_alt),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      userInfo['email'] ?? "",
                      style: textBarlowRegularBlack(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, bottom: 5, top: 5),
                    child: Text(
                      MyLocalizations.of(context)
                          .getLocalizations("FIRST_NAME", true),
                      style: textbarlowRegularBlack(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: TextFormField(
                      initialValue: userInfo['firstName'] ?? "",
                      style: textBarlowRegularBlack(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Color(0xFFF44242))),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      onSaved: (String value) {
                        firstName = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return MyLocalizations.of(context)
                              .getLocalizations("ENTER_FIRST_NAME");
                        } else
                          return null;
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, bottom: 5, top: 5),
                    child: Text(
                      MyLocalizations.of(context)
                          .getLocalizations("LAST_NAME", true),
                      style: textbarlowRegularBlack(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: TextFormField(
                      initialValue: userInfo['lastName'] ?? "",
                      style: textBarlowRegularBlack(),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Color(0xFFF44242))),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      onSaved: (String value) {
                        lastName = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return MyLocalizations.of(context)
                              .getLocalizations("ENTER_LAST_NAME");
                        } else
                          return null;
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, bottom: 5.0, right: 18.0),
                    child: Text(
                      MyLocalizations.of(context)
                          .getLocalizations("CONTACT_NUMBER", true),
                      style: textbarlowRegularBlack(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: TextFormField(
                      initialValue: userInfo['mobileNumber'] ?? "",
                      style: textBarlowRegularBlack(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0, color: Color(0xFFF44242))),
                        errorStyle: TextStyle(color: Color(0xFFF44242)),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        contentPadding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          top: 10.0,
                          bottom: 10.0,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primary),
                        ),
                      ),
                      onSaved: (String value) {
                        mobileNumber = value;
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return MyLocalizations.of(context)
                              .getLocalizations("ENTER_CONTACT_NUMBER");
                        } else
                          return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 51,
          child: GFButton(
            onPressed: () {
              if (!isLoading) updateUserInformation();
            },
            size: GFSize.LARGE,
            child: profileEdit
                ? GFLoader(
                    type: GFLoaderType.ios,
                  )
                : Text(
                    MyLocalizations.of(context).getLocalizations("SUBMIT"),
                    style: titleXLargeWPB(),
                  ),
            color: secondary,
            blockButton: true,
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
