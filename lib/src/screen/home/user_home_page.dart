import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/helpers/group_dialog_helper.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/news_model.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/group_item/list_group_user_item.dart';
import 'package:chat/src/base_compoments/text/text_and_line.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/search/search_page.dart';
import 'package:chat/src/screen/settingpage/edit_profire/edit_profile_page.dart';
import 'package:chat/src/screen/settingpage/setting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  // FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _databaseReference = Firestore.instance;
  List<NewsModel> _newsList = List<NewsModel>();
  // List<bool> _newsActiveList = List<bool>();
  NewsModel news;

  bool uidMember = false;
  List<String> waittingList = List<String>();

  // user() async {
  //   FirebaseUser user = await _auth.currentUser();
  //   if (user != null) {
  //     AppModel.user.uid = user.uid;
  //     await _databaseReference
  //         .collection('Users')
  //         .document(user.uid)
  //         .get()
  //         .then((value) {
  //       AppModel.user = UserModel.fromJson(value.data);
  //     });
  //   }
  // }

  _getGroup() async {
    AppList.groupList.clear();
    AppList.groupKey.clear();
    AppList.lastTextList.clear();
    AppList.lastTimeList.clear();
    AppList.groupAllList.clear();
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        var group = GroupModel.fromJson(value.data);
        AppList.groupAllList.add(group);
        var uid = group.memberUIDList
            .where((element) => element == AppModel.user.uid);
        if (uid.length != 0) {
          AppList.groupKey.add(value.documentID);
          AppList.groupList.add(group);
          _getLastText(value.documentID);
        }
        _getNews(value.documentID);
      });
    }).then((value) {});
  }

  _getNews(String id) async {
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(id)
        .collection("News")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        news = NewsModel.fromJson(value.data);

        var oldTime = DateTime.parse(news.timePost);
        var time = DateTime.now().difference(oldTime);

        var strSpit = time.toString().split(".");
        news.timePost = strSpit[0];
        news.timeCheck = int.parse(strSpit[0].replaceAll(":", ""));
        _getGroupProfile(news.groupUID);

        news.isActive = uidMember;
        _newsList.add(news);
        _newsList.sort((a, b) => a.timeCheck.compareTo(b.timeCheck));
        setState(() {});
      });
    });
  }

  _getGroupProfile(String key) async {
    var uid;
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(key)
        .get()
        .then((value) {
      var group = GroupModel.fromJson(value.data);
      uid =
          group.memberUIDList.where((element) => element == AppModel.user.uid);
    }).then((_) {
      if (uid.length != 0) {
        uidMember = true;
        setState(() {});
      }
    });
  }

  _getLastText(String key) async {
    String lastText = "";
    String lastTime = "";

    if (AppList.groupKey.length != 0) {
      await _databaseReference
          .collection("Rooms")
          .document("chats")
          .collection("Group")
          .document(key)
          .collection("messages")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((value) {
          var message = ChatMessage.fromJson(value.data);

          if (message != null) {
            if (message.text.isEmpty) {
              lastText = "คุณได้รับรูปภาพ";
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
      }).then((value) {
        AppList.lastTextList.add(lastText);
        AppList.lastTimeList.add(lastTime);
        // log(AppList.lastTimeList[0]);
        setState(() {});
      });
    }
  }

  // Future<String> _getRead(String key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String read = prefs.getString(key);
  //   return read ?? "";
  // }

  @override
  void initState() {
    super.initState();
    // user();
    // getAllUser();
    if (AppBool.homeUserChange) {
      AppBool.homeUserChange = false;
      _getGroup();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff202020),
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: Container(),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: SettingPage()));
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => SettingPage()));
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
                SearchField(
                  enable: false,
                  callback: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(
                          group: AppList.groupAllList,
                        ),
                      ),
                    );
                  },
                ),
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
                        child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  GroupDialogHelper.adminDialog(
                                    context: context,
                                    titleLeft: 'Group',
                                    pathIconLeft: 'assets/images/ic_group.png',
                                    groupName:
                                        AppList.groupList[index].nameGroup,
                                    profileUrl:
                                        AppList.groupList[index].avatarGroup,
                                    coverUrl: AppList.groupList[index].coverUrl,
                                    member: AppList
                                        .groupList[index].memberUIDList.length
                                        .toString(),
                                    statusGroup:
                                        AppList.groupList[index].statusGroup,
                                    callbackItem1: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatGroupPage(
                                            groupName: AppList
                                                .groupList[index].nameGroup,
                                            groupID: AppList.groupKey[index],
                                            id: AppList.groupList[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ListGroupUserItem(
                                  imgCoverUrl:
                                      AppList.groupList[index].coverUrl,
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
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical),
                      )
                    : Container(),
                SizedBox(
                  height: 5,
                ),
                // _newsList.length != 0
                //     ? TextAndLine(title: 'ข่าวสาร')
                //     : Container(),
                // SizedBox(
                //   height: 5,
                // ),
                // _newsList.length != 0 || waittingList.length != 0
                //     ? ListView.builder(
                //         shrinkWrap: true,
                //         physics: const NeverScrollableScrollPhysics(),
                //         itemCount: _newsList.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           return PromotionCard(
                //             imageUrlGroup: _newsList[index].imageGroup,
                //             imageUrlPromotion: _newsList[index].imageUrl,
                //             nameGroup: _newsList[index].nameGroup,
                //             status: _newsList[index].timePost,
                //             description: _newsList[index].title,
                //             keyGroup: _newsList[index].groupUID,
                //             waitting: "null",
                //             isActive: _newsList[index].isActive,
                //             callback: () {
                //               _databaseReference
                //                   .collection("Rooms")
                //                   .document("chats")
                //                   .collection("Group")
                //                   .document(_newsList[index].groupUID)
                //                   .collection("Waitting")
                //                   .document(AppModel.user.uid)
                //                   .setData({"uid": AppModel.user.uid});
                //               _dialogShowBack(
                //                   title: "แจ้งเตือน",
                //                   content:
                //                       "คุณได้ส่งคำขอร้องเข้ากลุ่มเรียบร้อยแล้ว\nกำลังรอแอดมินอนุมัติ");
                //               setState(() {});
                //             },
                //           );
                //         },
                //       )
                //     : Container(),
              ],
            ),
          ),
        )
        // : Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.height,
        //     child: Center(
        //       child: CircularProgressIndicator(),
        //     ),
        //   ),
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
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: EditProfilPage()));
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => EditProfilPage()));
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

  // Future<bool> _dialogShowBack({String title, String content}) {
  //   return showDialog(
  //         context: context,
  //         builder: (context) => new AlertDialog(
  //           title: new Text('$title'),
  //           content: new Text('$content'),
  //           actions: <Widget>[
  //             new GestureDetector(
  //               onTap: () {
  //                 Navigator.of(context).pop(false);
  //                 setState(() {});
  //               },
  //               child: Container(
  //                 padding: EdgeInsets.all(10),
  //                 child: Text("ตกลง"),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false;
  // }
}
