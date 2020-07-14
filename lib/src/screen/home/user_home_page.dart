import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/helpers/group_dialog_helper.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/card/promotion_card.dart';
import 'package:chat/src/base_compoments/group_item/list_group_item.dart';
import 'package:chat/src/base_compoments/text/text_and_line.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/settingpage/edit_profile_page.dart';
import 'package:chat/src/screen/settingpage/setting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _databaseReference = Firestore.instance;

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
      });
    }
  }

  getAllUser() async {
    AppList.userList.clear();
    AppList.uidList.clear();
    await _databaseReference
        .collection("Users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        var allUser = UserModel.fromJson(value.data);
        if (allUser.roles != "${TypeStatus.USER}") {
          if (allUser.displayName != AppString.displayName) {
            AppList.userList.add(allUser);
            AppList.uidList.add(value.documentID);
          }
        }
      });
    });
  }

  _getGroup() async {
    AppList.groupList.clear();
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        var group = GroupModel.fromJson(value.data);
        var uid =
            group.memberUIDList.where((element) => element == AppString.uid);
        if (uid.length != 0) {
          AppList.groupKey.add(value.documentID);
          AppList.groupList.add(group);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    user();
    getAllUser();
    _getGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff202020),
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Color(0xff242424),
        leading: Container(),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
              // Navigator.of(context).pushReplacementNamed('/setting');
            },
            child: Image.asset('assets/images/ic_setting.png'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              SearchField(),
              buildMyProfile(
                profileUrl: AppString.photoUrl,
                context: context,
                displayName: AppString.displayName,
              ),
              TextAndLine(
                title: 'Group',
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 160,
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          GroupDialogHelper.adminDialog(
                            context,
                            'Chat',
                            'Delete',
                            'assets/images/ic_chat.png',
                            'assets/images/ic_trash.png',
                          );
                        },
                        child: ListGroupItem(
                          imgCoverUrl:
                              'https://i.pinimg.com/originals/a8/b2/6a/a8b26abdd653ad71d19ca2b63db68dae.jpg',
                          imgGroupUrl:
                              'https://wallpapercave.com/wp/w1fkwPh.jpg',
                          nameGroup: 'Group name',
                          numberUser: '9,999',
                        ),
                      );
                    },
                    itemCount: 6,
                    scrollDirection: Axis.horizontal),
              ),
              SizedBox(
                height: 5,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return PromotionCard(
                    imageUrlGroup: 'https://wallpapercave.com/wp/w1fkwPh.jpg',
                    imageUrlPromotion:
                        'https://ichiangmaipr.com/wp-content/uploads/2018/06/653234c16ef6c02c6e4f1d82f10221f8.jpg',
                    nameGroup: 'Group Name',
                    status: 'Active 48 นาที ที่ผ่านมา',
                    description:
                        'Lorem ipsum is some dummy text generator, some dummy text generator',
                    callback: () {
                      GroupDialogHelper.adminDialog(
                        context,
                        'Chat',
                        'Delete',
                        'assets/images/ic_chat.png',
                        'assets/images/ic_trash.png',
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildMyProfile(
      {String profileUrl, BuildContext context, String displayName}) {
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
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  'Full Premission',
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
