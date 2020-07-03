import 'dart:developer';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/button/gradient_button.dart';
import 'package:chat/src/base_compoments/textfield/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataCollectPage extends StatefulWidget {
  @override
  _DataCollectPageState createState() => _DataCollectPageState();
}

class _DataCollectPageState extends State<DataCollectPage> {
  TextEditingController firstname;
  TextEditingController lastname;

  String _firstname = AppString.firstname;
  String _lastname = AppString.lastname;
  String _phone = "";

  @override
  void initState() {
    super.initState();
    firstname = TextEditingController(text: AppString.firstname);
    lastname = TextEditingController(text: AppString.lastname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff202020),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                alignment: Alignment.center,
                width: 120,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Register',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                hint: 'first name',
                onChanged: (value) {
                  _firstname = value;
                },
                controller: firstname,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                hint: 'last name',
                onChanged: (value) {
                  _lastname = value;
                },
                controller: lastname,
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                  hint: 'phone',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    _phone = value;
                  }),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 30,
              ),
              GradientButton(
                title: 'Submit',
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
    );
  }

  bool _check() {
    if (_firstname == "" || _lastname == "" || _phone == "") {
      return false;
    } else {
      return true;
    }
  }

  saveDataUser() {
    final _databaseReference = Firestore.instance;
    AppString.phoneNumber = _phone;
    log("${TypeStatus.USER}");

    UserModel data = UserModel(
      firstName: _firstname,
      lastName: _lastname,
      notiToken: AppString.notiToken,
      phoneNumber: _phone,
      email: AppString.email,
      displayName: AppString.displayName,
      gender: "ไม่ระบุ",
      birthDate: "ไม่ระบุ",
      isActive: false,
      roles: TypeStatus.USER.toString(),
      createdAt: AppString.dateTime,
      updatedAt: AppString.dateTime,
      avatarUrl: AppString.photoUrl,
    );

    _databaseReference
        .collection("Users")
        .document(AppString.uid)
        .setData(data.toJson());
    Navigator.of(context).pushReplacementNamed('/navuserhome');
  }
}
