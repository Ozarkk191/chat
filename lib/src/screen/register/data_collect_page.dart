import 'dart:developer';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/request_body_parameters.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/repositories/post_repository.dart';
import 'package:chat/services/authservice.dart';
import 'package:chat/src/base_compoments/button/gradient_button.dart';
import 'package:chat/src/base_compoments/textfield/big_round_textfield.dart';
import 'package:chat/src/screen/login/login_page.dart';
import 'package:chat/src/screen/register/confirm_otp_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class DataCollectPage extends StatefulWidget {
  final String phoneNumber;

  const DataCollectPage({Key key, this.phoneNumber}) : super(key: key);
  @override
  _DataCollectPageState createState() => _DataCollectPageState();
}

class _DataCollectPageState extends State<DataCollectPage> {
  TextEditingController _phone = new TextEditingController();
  String _erroeText = "";
  bool _loading = false;
  final validPhone = RegExp(r'^(?:[+0]9)?[0-9]{10}$');

  @override
  void initState() {
    _phone.text = widget.phoneNumber ?? "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _phone.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AuthService().signOut();
    log('didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _dialogShowBack(
          title: "แจ้งเตือน",
          content:
              "การลงทะเบียนยังไม่สมบรูณ์\nคุณต้องการยกเลิกการลงทะเบียนหรือไม่"),
      child: Scaffold(
        backgroundColor: Color(0xff292929),
        body: LoadingOverlay(
          isLoading: _loading,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    AppBar(
                      leading: InkWell(
                        onTap: () {
                          _dialogShowBack(
                              title: "แจ้งเตือน",
                              content:
                                  "การลงทะเบียนยังไม่สมบรูณ์\nคุณต้องการยกเลิกการลงทะเบียนหรือไม่");
                        },
                        child: Icon(Icons.arrow_back_ios),
                      ),
                      backgroundColor: Color(0xff202020),
                      title: Text("กรุณาใส่เบอร์มือถือ"),
                      centerTitle: true,
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color(0xff111111),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Text(
                              "+66",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            BigRoundTextField(
                              maxLength: 10,
                              controller: _phone,
                              hintText: "ใส่เบอร์มือถือ",
                              keyboardType: TextInputType.phone,
                              onChanged: (val) {
                                if (val.toString().length == 10) {
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                  });
                                }
                                _validate(val);
                              },
                            ),
                            Text(
                              _erroeText,
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Text(
                        'กรุณาใส่เบอร์โทรศัพท์ของคุณ เพื่อยืนยันตัวตน ระบบจะทำการส่ง OTP ไปทาง SMS',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    GradientButton(
                      title: !_check() ? 'กรุณากรอกเบอร์โทรศัทพ์' : 'ต่อไป',
                      callBack: !_check()
                          ? null
                          : () {
                              saveDataUser();
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _check() {
    if (_phone.text == "") {
      return false;
    } else if (_phone.text.length != 10) {
      return false;
    } else if (!validPhone.hasMatch(_phone.text)) {
      return false;
    } else if (_phone.text.substring(0, 2) != "06" &&
        _phone.text.substring(0, 2) != "08" &&
        _phone.text.substring(0, 2) != "09") {
      return false;
    } else {
      return true;
    }
  }

  void _validate(String value) {
    if (!validPhone.hasMatch(value)) {
      setState(() {
        _erroeText = "*เบอร์มือถือผิดรูปแบบ";
      });
    } else if (value.substring(0, 2) != "06" &&
        value.substring(0, 2) != "08" &&
        value.substring(0, 2) != "09") {
      setState(() {
        _erroeText = "*เบอร์มือถือผิดรูปแบบ";
      });
    } else if (value.length == 0) {
      setState(() {
        _erroeText = "*กรุณากรอกเบอร์มือถือ";
      });
    } else {
      setState(() {
        _erroeText = "";
      });
    }
  }

  Future<bool> _dialogShow({String title, String content}) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('$title'),
            content: new Text('$content'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("ตกลง"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _dialogShowBack({String title, String content}) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('$title'),
            content: new Text('$content'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                  AuthService().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("ใช่"),
                ),
              ),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("ไม่"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  saveDataUser() async {
    if (_check()) {
      setState(() {
        _loading = true;
      });
      final _databaseReference = Firestore.instance;
      AppString.phoneNumber = _phone.text;
      List<String> _phoneList = List<String>();
      List<String> _group = [];
      UserModel data = UserModel(
          firstName: AppString.firstname,
          lastName: AppString.lastname,
          notiToken: AppString.notiToken,
          phoneNumber: _phone.text,
          email: AppString.email,
          displayName: AppString.displayName,
          gender: "ไม่ระบุ",
          birthDate: "ไม่ระบุ",
          isActive: false,
          roles: TypeStatus.USER.toString(),
          createdAt: AppString.dateTime,
          updatedAt: AppString.dateTime,
          avatarUrl: AppString.photoUrl,
          groupKey: _group);

      await _databaseReference
          .collection("Users")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((value) {
          var dataCheck = UserModel.fromJson(value.data);
          _phoneList.add(dataCheck.phoneNumber);
        });
      });

      var checkPhone = _phoneList.where((element) => element == _phone.text);
      if (checkPhone.length == 0) {
        _sendOTP(data);
      } else {
        setState(() {
          _loading = false;
        });
        _dialogShow(
            title: "แจ้งเตือน",
            content: "มีเบอร์โทรนี้ในระบบแล้ว\nไม่สามารถใช้เบอร์โทรซ้ำได้");
      }
    } else {
      _dialogShow(
          title: "แจ้งเตือน",
          content:
              "ระบบไม่สามารถส่ง OTP ได้\nเนื่องจากเบอร์มือถือไม่ถูกรูปแบบ\nกรุณากรอกเบอร์มือถือใหม่");
    }
  }

  void _sendOTP(UserModel user) async {
    var parameter = SendOTPParameters(phoneNumber: _phone.text);
    var response = await PostRepository().sendOTP(parameter);
    switch (response['statusCode']) {
      case 200:
      case 201:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmOTPPage(
              phoneNumber: _phone.text,
              user: user,
              otp: response['otp'].toString(),
            ),
          ),
        );
        break;
      default:
        setState(() {
          _loading = false;
        });
    }
  }
}
