import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/helpers/group_dialog_helper.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/news_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/card/promotion_card.dart';
import 'package:chat/src/base_compoments/group_item/list_group_item.dart';
import 'package:chat/src/base_compoments/text/text_and_line.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/settingpage/edit_profire/edit_profile_page.dart';
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
  List<NewsModel> _newsList = List<NewsModel>();
  var uid;
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
          // if (allUser.displayName != AppModel.user.displayName) {
          AppList.userList.add(allUser);
          AppList.uidList.add(value.documentID);
          // }
        }
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
        var group = GroupModel.fromJson(value.data);
        var uid =
            group.memberUIDList.where((element) => element == AppString.uid);
        if (uid.length != 0) {
          AppList.groupKey.add(value.documentID);
          AppList.groupList.add(group);
        }
        _databaseReference
            .collection("News")
            .document(value.documentID)
            .collection("NewsDate")
            .getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((value) {
            var news = NewsModel.fromJson(value.data);
            var oldTime = DateTime.parse(news.timePost);
            var time = DateTime.now().difference(oldTime);
            var strSpit = time.toString().split(".");
            news.timePost = strSpit[0];
            _newsList.add(news);
            setState(() {});
          });
        });
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
                profileUrl: AppModel.user.avatarUrl,
                context: context,
                displayName: AppModel.user.displayName,
              ),
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
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                GroupDialogHelper.adminDialog(
                                  context: context,
                                  titleLeft: 'Group',
                                  titleRight: 'Delete',
                                  pathIconLeft: 'assets/images/ic_group.png',
                                  pathIconRight: 'assets/images/ic_trash.png',
                                  groupName: AppList.groupList[index].nameGroup,
                                  profileUrl:
                                      AppList.groupList[index].avatarGroup,
                                  coverUrl: AppList.groupList[index].coverUrl,
                                  member: AppList
                                      .groupList[index].memberUIDList.length
                                      .toString(),
                                  statusGroup:
                                      AppList.groupList[index].statusGroup,
                                );
                              },
                              child: ListGroupItem(
                                imgCoverUrl: AppList.groupList[index].coverUrl,
                                imgGroupUrl:
                                    AppList.groupList[index].avatarGroup,
                                nameGroup: AppList.groupList[index].nameGroup,
                                numberUser: AppList
                                    .groupList[index].memberUIDList.length
                                    .toString(),
                                status: AppList.groupList[index].statusGroup,
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
              _newsList.length != 0
                  ? TextAndLine(title: 'ข่าวสาร')
                  : Container(),
              SizedBox(
                height: 5,
              ),
              _newsList.length != 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _newsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PromotionCard(
                          imageUrlGroup: _newsList[index].imageGroup,
                          imageUrlPromotion: _newsList[index].imageUrl,
                          nameGroup: _newsList[index].nameGroup,
                          status: _newsList[index].timePost,
                          description: _newsList[index].title,
                          callback: () {
                            _databaseReference
                                .collection("News")
                                .document(_newsList[index].groupUID)
                                .collection("Waitting")
                                .document(AppModel.user.uid)
                                .setData({"uid": AppModel.user.uid});
                          },
                        );
                      },
                    )
                  : Container(),
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
                  'Status : User',
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
