import 'dart:async';
import 'dart:developer';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/request_body_parameters.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/repositories/post_repository.dart';
import 'package:chat/src/base_compoments/button/gradient_button.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:chat/src/screen/navigator/user_nav_bottom.dart';
import 'package:chat/src/screen/register/data_collect_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class ConfirmOTPPage extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  final String link;
  final UserModel user;

  const ConfirmOTPPage(
      {Key key, @required this.phoneNumber, this.otp, this.user, this.link})
      : super(key: key);
  @override
  _ConfirmOTPPageState createState() => _ConfirmOTPPageState();
}

class _ConfirmOTPPageState extends State<ConfirmOTPPage> {
  Timer _timer;
  int _start = 180;
  String otp = "";
  String otpBackEnd = "";
  bool _loading = false;
  TextEditingController _otp = new TextEditingController();

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void _save(UserModel user) {
    final _databaseReference = Firestore.instance;
    _databaseReference
        .collection("Users")
        .document(user.uid)
        .setData(user.toJson())
        .then((_) {
      if (widget.link != null) {
        _goToGroup(widget.link);
      } else {
        Navigator.of(context).pushReplacementNamed('/navuserhome');
      }
    });
  }

  void _goToGroup(String link) async {
    if (link != null) {
      List<String> _groupID = List<String>();
      Firestore _databaseReference = Firestore.instance;
      await _databaseReference
          .collection("Rooms")
          .document("chats")
          .collection("Group")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((value) {
          _groupID.add(value.documentID);
        });
      }).then((value) {
        var id = _groupID.where((element) => element == link).toList();
        if (id.length == 0) {
          if (AppModel.user.roles == TypeStatus.USER.toString()) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => UserNavBottom()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => TestNav()));
          }
        } else {
          _getGroup(link);
        }
        setState(() {});
      });
    }
  }

  _getGroup(String groupID) async {
    List<dynamic> _memberList = List<String>();
    Firestore _databaseReference = Firestore.instance;
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(groupID)
        .get()
        .then((value) {
      var group = GroupModel.fromJson(value.data);
      _memberList = group.memberUIDList;

      var member =
          _memberList.where((element) => element == AppModel.user.uid).toList();
      if (member.length == 0) {
        _memberList.add(AppModel.user.uid);
        _databaseReference
            .collection("Rooms")
            .document("chats")
            .collection("Group")
            .document(groupID)
            .updateData({"memberUIDList": _memberList}).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatGroupPage(
                groupName: group.nameGroup,
                groupID: group.groupID,
                id: group.id,
              ),
            ),
          );
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatGroupPage(
              groupName: group.nameGroup,
              groupID: group.groupID,
              id: group.id,
            ),
          ),
        );
      }
    });
  }

  bool _checkOTP() {
    if (otp == null) {
      return false;
    } else if (otp != otpBackEnd) {
      return false;
    } else {
      return true;
    }
  }

  void _sendOTP() async {
    var parameter = SendOTPParameters(phoneNumber: widget.phoneNumber);
    var response = await PostRepository().sendOTP(parameter);
    switch (response['message']) {
      case "success":
        setState(() {
          _loading = false;
        });
        _start = 180;
        startTimer();
        _dialogShow(title: "แจ้งเตือน", content: "ส่ง OTP อีกครั้งเรียบร้อย");
        otpBackEnd = response['otp'].toString();
        break;
      default:
        setState(() {
          _loading = false;
        });
        _dialogShow(title: "แจ้งเตือน", content: "${response['message']}");
        break;
    }
  }

  @override
  void initState() {
    startTimer();
    otpBackEnd = widget.otp;
    log("${widget.user.displayName}");
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otp.dispose();
    super.dispose();
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

                  _otp.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      body: LoadingOverlay(
        isLoading: _loading,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              AppBar(
                leading: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DataCollectPage(
                                  phoneNumber: widget.phoneNumber,
                                )));
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
                backgroundColor: Color(0xff202020),
                title: Text("ยืนยัน OTP"),
                centerTitle: true,
              ),
              SizedBox(height: 20),
              Text(
                "ระบบกำลังส่ง OTP\nไปที่เบอร์มือถือ +66${widget.phoneNumber}",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              PinCodeTextField(
                pinBoxHeight: 60,
                pinBoxWidth: 60,
                highlightPinBoxColor: Colors.white,
                controller: _otp,
                defaultBorderColor: Colors.white,
                hasTextBorderColor: Colors.white,
                pinBoxRadius: 10,
                wrapAlignment: WrapAlignment.center,
                pinBoxColor: Colors.white,
                pinTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                onTextChanged: (val) {
                  setState(() {
                    otp = val;
                  });
                },
                onDone: (val) {
                  if (val != otpBackEnd) {
                    setState(() {
                      _loading = false;
                    });
                    _dialogShow(
                        title: "แจ้งเตือน",
                        content: "OTP ไม่ถูกต้อง\nกรุณาตรวจสอบ OTP");
                  }
                },
              ),
              SizedBox(height: 20),
              GradientButton(
                title: 'ยืนยัน',
                callBack: !_checkOTP()
                    ? null
                    : () {
                        setState(() {
                          _loading = true;
                        });
                        _save(widget.user);
                      },
              ),
              SizedBox(height: 20),
              Text(
                _start != 0 ? "หากไม่ได้รับ OTP ($_start วินาที)" : "",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              InkWell(
                onTap: _start != 0
                    ? null
                    : () {
                        setState(() {
                          _loading = true;
                        });
                        _sendOTP();
                      },
                child: Text(
                  _start != 0 ? "" : "ขอ OTP อีกครั้ง",
                  style: TextStyle(
                      color: _start == 0 ? Colors.red : Colors.grey,
                      decoration: TextDecoration.underline,
                      fontWeight:
                          _start == 0 ? FontWeight.bold : FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
