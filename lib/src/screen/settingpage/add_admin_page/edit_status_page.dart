import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/screen/settingpage/add_admin_page/add_admin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditStatusPage extends StatefulWidget {
  final UserModel user;

  const EditStatusPage({Key key, @required this.user}) : super(key: key);
  @override
  _EditStatusPageState createState() => _EditStatusPageState();
}

class _EditStatusPageState extends State<EditStatusPage> {
  int initial = 0;
  String status;
  String permission;

  @override
  void initState() {
    super.initState();
    if (widget.user.roles == "${TypeStatus.USER}") {
      initial = 0;
      status = "${TypeStatus.USER}";
      permission = "User";
    } else if (widget.user.roles == "${TypeStatus.ADMIN}") {
      initial = 1;
      status = "${TypeStatus.ADMIN}";
      permission = "Admin";
    } else if (widget.user.roles == "${TypeStatus.SUPERADMIN}") {
      initial = 2;
      status = "${TypeStatus.SUPERADMIN}";
      permission = "Super Admin";
    }
  }

  void _updateStatus() async {
    Firestore _databaseReference = Firestore.instance;
    await _databaseReference
        .collection("Users")
        .document(widget.user.uid)
        .updateData({"roles": status}).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddAdminPage(),
        ),
      );
    });
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
                  _updateStatus();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            AppBool.homeAdminChange = true;
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => AddAdminPage()));
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              _dialogShowBack(
                  title: "แจ้งเตือน",
                  content:
                      "คุณต้องการให้ ${widget.user.displayName} เป็น $permission ใช่หรือไม่");
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              width: 50,
              height: 50,
              child: Center(
                child: Text("ตกลง"),
              ),
            ),
          ),
        ],
        title: Text("แก้ไขตำแหน่ง"),
        backgroundColor: Color(0xff202020),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              ProfileCard(
                profileUrl: widget.user.avatarUrl,
                height: 80,
                width: 80,
              ),
              SizedBox(height: 5),
              Text(
                widget.user.displayName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 20),
              ToggleSwitch(
                minWidth: 50,
                initialLabelIndex: initial,
                activeBgColor: Colors.redAccent,
                activeTextColor: Colors.white,
                inactiveBgColor: Colors.white,
                inactiveTextColor: Colors.black,
                labels: ['User', 'Admin', 'Super\nAdmin'],
                //icons: [Icons.public, Icons.person, Icons.public],
                onToggle: (index) {
                  if (index == 0) {
                    status = "${TypeStatus.USER}";
                    permission = "User";
                  } else if (index == 1) {
                    status = "${TypeStatus.ADMIN}";
                    permission = "Admin";
                  } else if (index == 2) {
                    status = "${TypeStatus.SUPERADMIN}";
                    permission = "Super Admin";
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
