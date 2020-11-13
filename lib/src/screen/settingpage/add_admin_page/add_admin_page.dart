import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/list_user_status.dart';
import 'package:chat/src/base_compoments/text/text_and_line.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:chat/src/screen/settingpage/add_admin_page/edit_status_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAdminPage extends StatefulWidget {
  @override
  _AddAdminPageState createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  List<UserModel> user = List<UserModel>();
  List<UserModel> admin = List<UserModel>();
  List<UserModel> superAdmin = List<UserModel>();
  bool _loading = true;

  _getUser() async {
    Firestore _databaseReference = Firestore.instance;
    await _databaseReference
        .collection("Users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        var allUser = UserModel.fromJson(value.data);
        if (allUser.displayName != AppModel.user.displayName) {
          if (allUser.roles == "${TypeStatus.USER}") {
            user.add(allUser);
          } else if (allUser.roles == "${TypeStatus.ADMIN}") {
            admin.add(allUser);
          } else if (allUser.roles == "${TypeStatus.SUPERADMIN}") {
            superAdmin.add(allUser);
          }
        }
      });
    }).then((_) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            AppBool.homeAdminChange = true;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => TestNav()));
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Text("เพิ่มแอดมิน"),
        backgroundColor: Color(0xff202020),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: !_loading
              ? Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextAndLine(title: "Super Admin"),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: superAdmin.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditStatusPage(
                                    user: superAdmin[index],
                                  ),
                                ),
                              );
                            },
                            child: ListUserWithStatus(
                                callback: () {},
                                profileUrl: superAdmin[index].avatarUrl,
                                userName: superAdmin[index].displayName,
                                status: "SUPERADMIN"),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    admin.length != 0
                        ? Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: TextAndLine(title: "Admin"),
                          )
                        : Container(),
                    admin.length != 0
                        ? Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: admin.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditStatusPage(
                                          user: admin[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListUserWithStatus(
                                      callback: () {},
                                      profileUrl: admin[index].avatarUrl,
                                      userName: admin[index].displayName,
                                      status: "ADMIN"),
                                );
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(height: 20),
                    user.length != 0
                        ? Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: TextAndLine(title: "User"),
                          )
                        : Container(),
                    user.length != 0
                        ? Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: user.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditStatusPage(
                                          user: user[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListUserWithStatus(
                                    callback: () {},
                                    profileUrl: user[index].avatarUrl,
                                    userName: user[index].displayName,
                                    status: "USER",
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(height: 20),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
