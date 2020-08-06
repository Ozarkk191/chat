import 'dart:async';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/services/authservice.dart';
import 'package:chat/src/screen/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseMessaging _messaging = FirebaseMessaging();
  String tokenCheck = "";
  @override
  void initState() {
    _check();

    super.initState();
    _messaging.getToken().then((token) {
      tokenCheck = token;
    });
    // _loggedIn();
  }

  _check() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    Firestore _databaseReference = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    List<String> _listUID = List<String>();
    if (user != null) {
      await _databaseReference
          .collection('Users')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((value) {
          _listUID.add(value.documentID);
        });
      }).then((value) {
        var uid = _listUID.where((element) => element == user.uid);
        if (uid.length != 0) {
          _getPorfile();
        } else {
          AuthService().signOut();
          Timer(Duration(seconds: 3), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          });
        }
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }
  }

  _getPorfile() async {
    AppModel.user = null;
    FirebaseAuth _auth = FirebaseAuth.instance;
    Firestore _databaseReference = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    AppString.uid = user.uid;
    _databaseReference
        .collection('Users')
        .document(user.uid)
        .get()
        .then((value) {
      // var userModel = UserModel.fromJson(value.data);
      AppModel.user = UserModel.fromJson(value.data);
      if (AppModel.user.banned) {
        _dialogShow(title: "แจ้งเตือน", content: "คุณถูกแบนออกจากระบบ");
      } else {
        if (AppModel.user.notiToken != tokenCheck) {
          AppModel.user.notiToken = tokenCheck;
          _databaseReference
              .collection('Users')
              .document(user.uid)
              .setData(AppModel.user.toJson());
        }
        AppString.displayName = AppModel.user.displayName;
        AppString.firstname = AppModel.user.firstName;
        AppString.lastname = AppModel.user.lastName;
        AppString.birthDate = AppModel.user.birthDate;
        AppString.email = AppModel.user.email;
        AppString.notiToken = AppModel.user.notiToken;
        AppString.phoneNumber = AppModel.user.phoneNumber;
        AppString.roles = AppModel.user.roles;
        AppString.dateTime = AppModel.user.updatedAt;
        AppString.isActive = AppModel.user.isActive;
        AppString.gender = AppModel.user.gender;
        AppString.photoUrl = AppModel.user.avatarUrl;
        AppString.coverUrl = AppModel.user.coverUrl;
        AppModel.user.isActive = true;
        AppModel.user.lastTimeUpdate = DateTime.now().toString();
        _databaseReference
            .collection('Users')
            .document(user.uid)
            .setData(AppModel.user.toJson());

        if (AppString.roles == TypeStatus.USER.toString()) {
          Navigator.of(context).pushReplacementNamed('/navuserhome');
        } else {
          Navigator.of(context).pushReplacementNamed('/navhome');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff202020),
      body: Center(
        child: Container(
          width: 200,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
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
                  AuthService().signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
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
}
