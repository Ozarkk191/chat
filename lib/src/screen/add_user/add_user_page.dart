import 'package:chat/app_strings/menu_settings.dart';
import 'package:flutter/material.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Color(0xff202020),
              title: Text("เพิ่มสมาชิกกลุ่ม"),
            ),
            SingleChildScrollView(
                child: ListView.builder(
              itemCount: AppList.userList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container();
              },
            )),
          ],
        ),
      ),
    );
  }
}
