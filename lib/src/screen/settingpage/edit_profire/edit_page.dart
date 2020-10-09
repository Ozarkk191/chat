import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/src/base_compoments/button/gradient_button.dart';
import 'package:chat/src/base_compoments/textfield/big_round_textfield.dart';
import 'package:chat/src/screen/settingpage/edit_profire/edit_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _firstName = new TextEditingController();
  TextEditingController _lastName = new TextEditingController();
  TextEditingController _birthday = new TextEditingController();
  bool _male = false;
  bool _female = false;
  bool _other = false;
  bool _loading = false;
  String _gender = "";
  File _avatar, _cover;
  final picker = ImagePicker();
  final pickerAvatar = ImagePicker();
  final validNameTh = RegExp(r'^[ก-๏\s]+$');
  final validNameEn = RegExp(r'^[a-zA-Z]+$');
  final validName = RegExp(r'^[a-zA-Zก-๙]+$');
  // DateTime _newDateTime;

  String _errorText = "";
  String _errorText2 = "";

  Future getImageAvatar() async {
    final pickedFile1 =
        await pickerAvatar.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile1 != null) {
        _avatar = File(pickedFile1.path);
        log(_avatar.toString());
      }
    });
  }

  Future getImageCover() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _cover = File(pickedFile.path);
        log(_cover.toString());
      }
    });
  }

  bool _check() {
    if (_firstName.text == "" || _lastName.text == "") {
      return false;
    } else if (_errorText != "" && _errorText2 != "") {
      return false;
    } else {
      return true;
    }
  }

  void _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final _databaseReference = Firestore.instance;
    if (_avatar != null) {
      var now = DateTime.now().millisecondsSinceEpoch.toString();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(now);
      StorageUploadTask uploadTask = storageRef.putFile(
        File(_avatar.path),
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;
      AppModel.user.avatarUrl = await download.ref.getDownloadURL();
    }
    if (_cover != null) {
      var now = DateTime.now().millisecondsSinceEpoch.toString();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(now);
      StorageUploadTask uploadTask = storageRef.putFile(
        File(_cover.path),
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;
      AppModel.user.coverUrl = await download.ref.getDownloadURL();
    }

    _databaseReference
        .collection('Users')
        .document(AppModel.user.uid)
        .updateData({
      "firstName": _firstName.text,
      "lastName": _lastName.text,
      "gender": _gender,
      "birthDate": _birthday.text,
      "displayName": "${_firstName.text} ${_lastName.text}",
      "avatarUrl": AppModel.user.avatarUrl,
      "coverUrl": AppModel.user.coverUrl
    }).then((_) {
      AppModel.user.firstName = _firstName.text;
      AppModel.user.lastName = _lastName.text;
      AppModel.user.displayName = "${_firstName.text} ${_lastName.text}";
      AppModel.user.birthDate = _birthday.text;
      AppModel.user.gender = _gender;
      setState(() {
        _loading = false;
      });
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => EditProfilPage()));
    });
  }

  _time() async {
    CupertinoRoundedDatePicker.show(
      context,
      fontFamily: "Mali",
      textColor: Colors.white,
      background: Color(0xff202020),
      borderRadius: 16,
      maximumYear: 2020,
      minimumYear: 1950,
      initialDatePickerMode: CupertinoDatePickerMode.date,
      onDateTimeChanged: (newDateTime) {
        var date = newDateTime.toString().split(" ");
        date = date[0].split("-");
        String month = _month(date[1]);
        _birthday.text = "${date[2]} $month ${date[0]}";
        setState(() {});
      },
    );
  }

  String _month(String month) {
    switch (month) {
      case "01":
        month = "มกราคม";
        break;
      case "02":
        month = "กุมภาพันธ์";
        break;
      case "03":
        month = "มีนาคม";
        break;
      case "04":
        month = "เมษายน";
        break;
      case "05":
        month = "พฤษภาคม";
        break;
      case "06":
        month = "มิถุนายน";
        break;
      case "07":
        month = "กรกฏาคม";
        break;
      case "08":
        month = "สิงหาคม";
        break;
      case "09":
        month = "กันยายน";
        break;
      case "10":
        month = "ตุลาคม";
        break;
      case "11":
        month = "พฤศจิกายน";
        break;
      case "12":
        month = "ธันวาคม";
        break;
    }
    return month;
  }

  @override
  void initState() {
    _firstName.text = AppModel.user.firstName;
    _lastName.text = AppModel.user.lastName;
    _birthday.text = AppModel.user.birthDate ?? "ไม่ระบุ";
    if (_birthday.text == "null") {
      _birthday.text = "ไม่ระบุ";
    }
    if (AppModel.user.gender == "ไม่ระบุ" || AppModel.user.gender == null) {
      _other = true;
      _gender = "ไม่ระบุ";
    } else if (AppModel.user.gender == "ชาย") {
      _male = true;
      _gender = "ชาย";
    } else if (AppModel.user.gender == "หญิง") {
      _female = true;
      _gender = "หญิง";
    }
    super.initState();
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _birthday.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _loading,
      child: Scaffold(
        backgroundColor: Color(0xff292929),
        appBar: AppBar(
          title: Text('แก้ไขข้อมูลส่วนตัว'),
          backgroundColor: Color(0xff242424),
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => EditProfilPage()));
            },
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                buildProfile(
                  context: context,
                  coverUrl: AppModel.user.coverUrl,
                  profileUrl: AppModel.user.avatarUrl,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      child: BigRoundTextField(
                        enabled: false,
                        maxLength: 15,
                        backgroundColor: Color(0xff292929),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        hintText: "ชื่อ :",
                      ),
                    ),
                    SizedBox(width: 5),
                    BigRoundTextField(
                      controller: _firstName,
                      maxLength: 15,
                      fontSize: 14,
                      onChanged: (val) {
                        _validate(val);
                      },
                    ),
                  ],
                ),
                Text(
                  _errorText,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      child: BigRoundTextField(
                        enabled: false,
                        maxLength: 15,
                        backgroundColor: Color(0xff292929),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        hintText: "นามสกุล :",
                      ),
                    ),
                    SizedBox(width: 5),
                    BigRoundTextField(
                      controller: _lastName,
                      maxLength: 15,
                      fontSize: 14,
                      onChanged: (val) {
                        _validate2(val);
                      },
                    ),
                  ],
                ),
                Text(
                  _errorText2,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _genderCheckBox(
                      gender: _male,
                      onChanged: (val) {
                        setState(() {
                          _male = val;
                          if (_male) {
                            _gender = "ชาย";
                            _female = false;
                            _other = false;
                          }
                        });
                      },
                      title: "ชาย",
                    ),
                    _genderCheckBox(
                      gender: _female,
                      onChanged: (val) {
                        setState(() {
                          _female = val;
                          if (_female) {
                            _gender = "หญิง";
                            _male = false;
                            _other = false;
                          }
                        });
                      },
                      title: "หญิง",
                    ),
                    _genderCheckBox(
                      gender: _other,
                      onChanged: (val) {
                        setState(() {
                          _other = val;
                          if (_other) {
                            _gender = "ไม่ระบุ";
                            _male = false;
                            _female = false;
                          }
                        });
                      },
                      title: "ไม่ระบุ",
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      child: BigRoundTextField(
                        enabled: false,
                        maxLength: 15,
                        backgroundColor: Color(0xff292929),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        hintText: "วันเกิด :",
                      ),
                    ),
                    SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        _time();
                      },
                      child: BigRoundTextField(
                        controller: _birthday,
                        enabled: false,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                GradientButton(
                  title: 'บันทึก',
                  callBack: !_check()
                      ? null
                      : () {
                          _updateProfile();
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validate(String value) {
    setState(() {});
    if (value.length == 0) {
      setState(() {
        _errorText = "*กรุณากรอกข้อมูล";
      });
    } else {
      if (!validName.hasMatch(value)) {
        setState(() {
          _errorText = "*ไม่สามรถใช้อักษรพิเศษได้";
        });
      } else if (value.contains("฿")) {
        setState(() {
          _errorText = "*ไม่สามรถใช้อักษรพิเศษได้";
        });
      } else if (!validNameTh.hasMatch(value)) {
        if (!validNameEn.hasMatch(value)) {
          setState(() {
            _errorText = "*ชื่อต้องเป็นภาษาเดียวกัน";
          });
        } else {
          setState(() {
            _errorText = "";
          });
        }
      } else if (!validNameEn.hasMatch(value)) {
        if (!validNameTh.hasMatch(value)) {
          setState(() {
            _errorText = "*ชื่อต้องเป็นภาษาเดียวกัน";
          });
        } else {
          setState(() {
            _errorText = "";
          });
        }
      }
      if (_lastName.text != "") {
        var first = !validNameTh.hasMatch(_lastName.text);
        var last = !validNameTh.hasMatch(value);
        if (first != last) {
          setState(() {
            _errorText = "*ชื่อและนามสกุลต้องเป็นภาษาเดียวกัน";
          });
        }
      }
    }
  }

  void _validate2(String value) {
    setState(() {});
    if (value.length == 0) {
      setState(() {
        _errorText2 = "*กรุณากรอกข้อมูล";
      });
    } else {
      if (!validName.hasMatch(value)) {
        setState(() {
          _errorText2 = "*ไม่สามรถใช้อักษรพิเศษได้";
        });
      } else if (value.contains("฿")) {
        setState(() {
          _errorText2 = "*ไม่สามรถใช้อักษรพิเศษได้";
        });
      } else if (!validNameTh.hasMatch(value)) {
        if (!validNameEn.hasMatch(value)) {
          setState(() {
            _errorText2 = "*นามสกุลต้องเป็นภาษาเดียวกัน";
          });
        } else {
          setState(() {
            _errorText2 = "";
          });
        }
      } else if (!validNameEn.hasMatch(value)) {
        if (!validNameTh.hasMatch(value)) {
          setState(() {
            _errorText2 = "*นามสกุลต้องเป็นภาษาเดียวกัน";
          });
        } else {
          setState(() {
            _errorText2 = "";
          });
        }
      }
      if (_firstName.text != "") {
        var first = !validNameTh.hasMatch(_firstName.text);
        var last = !validNameTh.hasMatch(value);
        if (first != last) {
          setState(() {
            _errorText2 = "*ชื่อและนามสกุลต้องเป็นภาษาเดียวกัน";
          });
        }
      }
    }
  }

  Container _genderCheckBox({
    bool gender,
    Function onChanged,
    String title,
  }) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            activeColor: Colors.cyan,
            checkColor: Colors.black,
            value: gender,
            onChanged: onChanged,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Container buildProfile({
    Key key,
    BuildContext context,
    String coverUrl,
    String profileUrl,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: _cover == null
                ? CachedNetworkImage(
                    imageUrl: coverUrl,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Image.file(
                    _cover,
                    fit: BoxFit.cover,
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(1),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0), Colors.black],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              getImageCover();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: Text(
                      'เปลี่ยนรูปปก',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/images/ic_edit.png'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                getImageAvatar();
              },
              child: Container(
                width: 100,
                height: 100,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      _avatar == null
                          ? CachedNetworkImage(
                              imageUrl: profileUrl,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Image.file(
                              _avatar,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 30,
                          width: 100,
                          color: Colors.black.withOpacity(0.7),
                          child: Center(
                            child: Text(
                              'เปลี่ยนรูป',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
