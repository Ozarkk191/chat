import 'dart:async';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // AuthService().signOut();
    _ioggedIn();
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

  _ioggedIn() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    Firestore _databaseReference = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      AppString.uid = user.uid;
      _databaseReference
          .collection('Users')
          .document(user.uid)
          .get()
          .then((value) {
        print('aaaaaaa ::${value.data}');
        var userModel = UserModel.fromJson(value.data);
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
    } else {
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacementNamed('/');
      });
    }
  }
}
