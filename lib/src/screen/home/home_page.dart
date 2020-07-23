import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/helpers/dialoghelper.dart';
import 'package:chat/helpers/group_dialog_helper.dart';
import 'package:chat/helpers/user_dialog_helper.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/group_item/list_admin_item.dart';
import 'package:chat/src/base_compoments/group_item/list_group_item.dart';
import 'package:chat/src/base_compoments/group_item/list_user_item.dart';
import 'package:chat/src/base_compoments/text/text_and_line.dart';
import 'package:chat/src/base_compoments/text/text_and_line_edit.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/settingpage/add_admin_page/add_admin_page.dart';
import 'package:chat/src/screen/settingpage/edit_profire/edit_profile_page.dart';
import 'package:chat/src/screen/settingpage/setting_page.dart';
import 'package:chat/src/screen/waitting/waitting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Firestore _databaseReference = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GroupModel _group;
  List<String> _waittingList = List<String>();

  user() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      AppString.uid = user.uid;
      await _databaseReference
          .collection('Users')
          .document(user.uid)
          .get()
          .then((value) {
        var userModel = UserModel.fromJson(value.data);
        AppString.displayName = userModel.displayName;
        AppString.firstname = userModel.firstName;
        AppString.lastname = userModel.lastName;
        AppString.birthDate = userModel.birthDate;
        AppString.email = userModel.email;
        AppString.notiToken = userModel.notiToken;
        AppString.phoneNumber = userModel.phoneNumber;
        AppString.roles = userModel.roles.toString();
        AppString.dateTime = userModel.updatedAt;
        AppString.isActive = userModel.isActive;
        AppString.gender = userModel.gender;
      }).then((value) {
        setState(() {});
      });
    }
  }

  _getAllAdmin() async {
    AppList.adminList.clear();
    AppList.adminUidList.clear();
    AppList.user.clear();
    AppList.admin.clear();
    AppList.superAdmin.clear();
    await _databaseReference
        .collection("Users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        var allUser = UserModel.fromJson(value.data);
        if (allUser.displayName != AppModel.user.displayName) {
          if (allUser.roles != "${TypeStatus.USER}") {
            var oldTime = DateTime.parse(allUser.lastTimeUpdate);
            var time = DateTime.now().difference(oldTime);
            var strSpit = time.toString().split(".");
            allUser.lastTimeUpdate = strSpit[0];
            AppList.adminList.add(allUser);
            AppList.adminUidList.add(value.documentID);
          }
        }
        setState(() {});
      });
    });
  }

  _getGroup() async {
    AppList.groupList.clear();
    AppList.groupKey.clear();
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        _group = GroupModel.fromJson(value.data);
        _getWaitting(value.documentID);
        var uid =
            _group.memberUIDList.where((element) => element == AppString.uid);
        if (uid.length != 0) {
          // _getLastText(value.documentID);

          AppList.groupKey.add(value.documentID);
          AppList.groupList.add(_group);
        }
      });
    }).then((value) {
      _getLastText();
      setState(() {});
    });
  }

  _getAllUser() async {
    AppList.userList.clear();
    AppList.uidList.clear();
    AppList.allUserList.clear();
    AppList.lastTextList.clear();
    AppList.lastTimeList.clear();
    await _databaseReference
        .collection("Users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        var allUser = UserModel.fromJson(value.data);
        if (allUser.displayName != AppModel.user.displayName) {
          AppList.allUserList.add(allUser);
          AppList.allUidList.add(value.documentID);
          if (allUser.roles == "${TypeStatus.USER}") {
            AppList.userList.add(allUser);
            AppList.uidList.add(value.documentID);
          }
        }
      });
    }).then((value) => setState(() {}));
  }

  _getWaitting(String id) async {
    String uid = "null";
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(id)
        .collection("Waitting")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        _waittingList.add(value.documentID);
        // if (value.documentID == AppModel.user.uid) {
        //   uid = value.documentID;
        // }
      });
    });
  }

  _getLastText() async {
    String lastText = "";
    String lastTime = "";
    if (AppList.groupKey.length != 0) {
      for (var i = 0; i < AppList.groupKey.length; i++) {
        await _databaseReference
            .collection("Rooms")
            .document("chats")
            .collection("Group")
            .document(AppList.groupKey[i])
            .collection("messages")
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((value) {
            var message = ChatMessage.fromJson(value.data);
            // log("1 :: ${message.text}");
            if (message != null) {
              if (message.text.isEmpty) {
                if (message.user.uid == AppModel.user.uid) {
                  lastText = "คุณได้ส่งรูปภาพ";
                } else {
                  lastText = "คุณได้รับรูปภาพ";
                }
              } else {
                lastText = message.text;
              }

              lastTime = DateTime.fromMillisecondsSinceEpoch(
                      message.createdAt.millisecondsSinceEpoch)
                  .toString();
              var str = lastTime.split(" ");
              var str2 = str[1].split(".");
              str = str2[0].split(":");
              lastTime = "${str[0]}:${str[1]} น.";
            } else {
              lastText = "";
              lastTime = "00:00 น.";
            }
          });
        });

        // String timeRead = _getRead(id).toString();
        AppList.lastTextList.add(lastText);
        AppList.lastTimeList.add(lastTime);
        setState(() {});
      }
    }
  }

  Future<String> _getRead(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String read = prefs.getString(key);
    return read ?? "";
  }

  @override
  void initState() {
    super.initState();
    user();
    _getGroup();
    _getAllUser();
    _getAllAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff202020),
        leading: Container(),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
            child: Image.asset('assets/images/ic_setting.png'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            AppList.groupList.length != 0
                ? Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        SearchField(),
                        buildMyProfile(
                          profileUrl: AppModel.user.avatarUrl,
                          context: context,
                          displayName: AppModel.user.displayName,
                          premission:
                              AppModel.user.roles == "${TypeStatus.ADMIN}"
                                  ? "Admin"
                                  : "Super Admin",
                        ),
                        AppModel.user.roles != "${TypeStatus.SUPERADMIN}"
                            ? TextAndLine(
                                title: 'แอดมิน',
                              )
                            : TextAndLineEdit(
                                title: "แอดมิน",
                                callback: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddAdminPage()));
                                },
                              ),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  DialogHelper.adminDialog(
                                    context,
                                    AppList.adminList[index].avatarUrl,
                                    AppList.adminList[index].displayName,
                                    AppList.adminList[index].coverUrl,
                                  );
                                },
                                child: ListAdminItem(
                                  profileUrl:
                                      AppList.adminList[index].avatarUrl,
                                  adminName:
                                      AppList.adminList[index].displayName,
                                  callback: () {},
                                  status: AppList.adminList[index].isActive,
                                  lastTime:
                                      AppList.adminList[index].lastTimeUpdate,
                                ),
                              );
                            },
                            itemCount: AppList.adminList.length,
                          ),
                        ),
                        _waittingList.length != 0
                            ? TextAndLine(title: 'คำร้องขอเข้ากลุ่ม')
                            : Container(),
                        SizedBox(
                          height: 5,
                        ),
                        _waittingList.length != 0
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              WaittingPage()));
                                },
                                child: Row(
                                  children: <Widget>[
                                    ProfileCard(
                                      profileUrl:
                                          'https://i.pinimg.com/736x/0f/c3/e7/0fc3e7cea3075c7a5c231ca73e60a6e9.jpg',
                                      width: 50,
                                      height: 50,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'มีคำร้องขอเข้ากลุ่ม ${_waittingList.length} คำร้อง',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        AppList.groupList.length != 0
                            ? TextAndLine(title: 'กลุ่ม')
                            : Container(),
                        SizedBox(
                          height: 5,
                        ),
                        AppList.groupList.length != 0
                            ? Container(
                                height: 160,
                                child: ListView.builder(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          GroupDialogHelper.adminDialog(
                                            context: context,
                                            titleLeft: 'Group',
                                            titleRight: 'Delete',
                                            pathIconLeft:
                                                'assets/images/ic_group.png',
                                            pathIconRight:
                                                'assets/images/ic_trash.png',
                                            groupName: AppList
                                                .groupList[index].nameGroup,
                                            profileUrl: AppList
                                                .groupList[index].avatarGroup,
                                            coverUrl: AppList
                                                .groupList[index].coverUrl,
                                            member: AppList.groupList[index]
                                                .memberUIDList.length
                                                .toString(),
                                            statusGroup: _group.statusGroup,
                                          );
                                        },
                                        child: ListGroupItem(
                                          imgCoverUrl:
                                              AppList.groupList[index].coverUrl,
                                          imgGroupUrl: AppList
                                              .groupList[index].avatarGroup,
                                          nameGroup: AppList
                                              .groupList[index].nameGroup,
                                          numberUser: AppList.groupList[index]
                                              .memberUIDList.length
                                              .toString(),
                                          status: AppList
                                              .groupList[index].statusGroup,
                                        ),
                                      );
                                    },
                                    itemCount: AppList.groupList.length,
                                    scrollDirection: Axis.horizontal),
                              )
                            : Container(),
                        SizedBox(
                          height: 5,
                        ),
                        AppList.userList.length != 0
                            ? TextAndLine(title: 'ลูกค้า')
                            : Container(),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  UserDialogHelper.adminDialog(
                                    context: context,
                                    profileUrl:
                                        AppList.userList[index].avatarUrl,
                                    username:
                                        AppList.userList[index].displayName,
                                    coverUrl: AppList.userList[index].coverUrl,
                                  );
                                },
                                child: ListUserItem(
                                  profileUrl: AppList.userList[index].avatarUrl,
                                  userName: AppList.userList[index].displayName,
                                  callback: () {},
                                ),
                              );
                            },
                            itemCount: AppList.userList.length,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Container buildMyProfile({
    String profileUrl,
    BuildContext context,
    String displayName,
    String premission,
  }) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ProfileCard(
            profileUrl: profileUrl,
            width: 70,
            height: 70,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$displayName',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                Text(
                  'Status : $premission',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfilPage()));
            },
            child: Container(
              width: 40,
              height: 20,
              child: Center(
                child: Text(
                  'edit',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xff202020),
                border: Border.all(width: 1, color: Color(0xff9B9B9B)),
                borderRadius: new BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
