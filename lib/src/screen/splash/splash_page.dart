import 'dart:async';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/services/authservice.dart';

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
    super.initState();
    _messaging.getToken().then((token) {
      tokenCheck = token;
    });
    _loggedIn();
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

  _loggedIn() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    Firestore _databaseReference = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      AppString.uid = user.uid;
      await _databaseReference
          .collection('Users')
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((value) {
          List<String> _uidKey = List<String>();
          _uidKey.add(value.documentID);
          var listUid = _uidKey.where((element) => element == user.uid);
          if (listUid.length == 0) {
            Timer(Duration(seconds: 3), () {
              AuthService().signOut();
              Navigator.of(context).pushReplacementNamed('/');
            });
          } else {
            _databaseReference
                .collection('Users')
                .document(user.uid)
                .get()
                .then((value) {
              var userModel = UserModel.fromJson(value.data);
              if (userModel.notiToken != tokenCheck) {
                userModel.notiToken = tokenCheck;
                _databaseReference
                    .collection('Users')
                    .document(user.uid)
                    .setData(userModel.toJson());
              }
              AppString.displayName = userModel.displayName;
              AppString.firstname = userModel.firstName;
              AppString.lastname = userModel.lastName;
              AppString.birthDate = userModel.birthDate;
              AppString.email = userModel.email;
              AppString.notiToken = userModel.notiToken;
              AppString.phoneNumber = userModel.phoneNumber;
              AppString.roles = userModel.roles;
              AppString.dateTime = userModel.updatedAt;
              AppString.isActive = userModel.isActive;
              AppString.gender = userModel.gender;
              AppString.photoUrl = userModel.avatarUrl;

              if (AppString.roles == TypeStatus.USER.toString()) {
                Navigator.of(context).pushReplacementNamed('/navuserhome');
              } else {
                Navigator.of(context).pushReplacementNamed('/navhome');
              }
            });
          }
        });
      });
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacementNamed('/');
      });
    }
  }
}
