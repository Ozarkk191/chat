import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/src/base_compoments/group_item/list_chat_time_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/group/create_group/create_group_page.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  // final _databaseReference = Firestore.instance;
  // List<GroupModel> _groupList = List<GroupModel>();
  // List<String> _lastTextList = List<String>();
  // List<String> _lastTimeList = List<String>();

  // _getGroupData() async {
  //   await _databaseReference
  //       .collection("Rooms")
  //       .document("chats")
  //       .collection("Group")
  //       .getDocuments()
  //       .then((QuerySnapshot snapshot) {
  //     snapshot.documents.forEach((value) {
  //       var group = GroupModel.fromJson(value.data);
  //       var uid = group.memberUIDList
  //           .where((element) => element == AppModel.user.uid);
  //       if (uid.length != 0) {
  //         _groupList.add(group);
  //         setState(() {});
  //       }
  //     });
  //   }).then((value) {
  //     _getLastText();
  //   });
  // }

  // _getLastText() async {
  //   String lastText = "";
  //   String lastTime = "";

  //   if (AppList.groupKey.length != 0) {
  //     for (var i = 0; i < AppList.groupKey.length; i++) {
  //       await _databaseReference
  //           .collection("Rooms")
  //           .document("chats")
  //           .collection("Group")
  //           .document(AppList.groupKey[i])
  //           .collection("messages")
  //           .getDocuments()
  //           .then((QuerySnapshot snapshot) {
  //         snapshot.documents.forEach((value) {
  //           var message = ChatMessage.fromJson(value.data);
  //           // log("1 :: ${message.text}");
  //           if (message != null) {
  //             if (message.text.isEmpty) {
  //               if (message.user.uid == AppModel.user.uid) {
  //                 lastText = "คุณได้ส่งรูปภาพ";
  //               } else {
  //                 lastText = "คุณได้รับรูปภาพ";
  //               }
  //             } else {
  //               lastText = message.text;
  //             }

  //             lastTime = DateTime.fromMillisecondsSinceEpoch(
  //                     message.createdAt.millisecondsSinceEpoch)
  //                 .toString();
  //             var str = lastTime.split(" ");
  //             var str2 = str[1].split(".");
  //             str = str2[0].split(":");
  //             lastTime = "${str[0]}:${str[1]} น.";
  //           } else {
  //             lastText = "";
  //             lastTime = "00:00 น.";
  //           }
  //         });
  //       }).then((value) {
  //         _lastTextList.add(lastText);
  //         _lastTimeList.add(lastTime);
  //         log(_lastTextList[0].toString());
  //         setState(() {});
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    // _getGroupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        leading: Container(),
        actions: <Widget>[
          AppModel.user.roles == '${TypeStatus.USER}'
              ? Container()
              : PopupMenuButton<String>(
                  child: Image.asset('assets/images/ic_add_group.png'),
                  color: Color(0xff292929),
                  onSelected: (value) {
                    _selecteMenu(value, context);
                  },
                  itemBuilder: (BuildContext context) {
                    return MenuSettings.groupList.map((String menu) {
                      return PopupMenuItem<String>(
                        value: menu,
                        child: Text(
                          menu,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList();
                  }),
        ],
        backgroundColor: Color(0xff202020),
        title: Text('แชทกลุ่ม'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: AppList.myGroupList.length != 0
            ? Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    SearchField(),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              AppString.uidRoomChat =
                                  AppList.myGroupList[index].groupID;
                              AppModel.group = AppList.myGroupList[index];
                              AppString.nameGroup =
                                  AppList.myGroupList[index].nameGroup;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatGroupPage(
                                    groupName:
                                        AppList.myGroupList[index].nameGroup,
                                    groupID: AppList.myGroupList[index].groupID,
                                    id: AppList.myGroupList[index].id,
                                  ),
                                ),
                              );
                            },
                            child: ListChatItem(
                              profileUrl:
                                  AppList.myGroupList[index].avatarGroup,
                              lastText: AppList.lastGroupTextList[index],
                              name: AppList.myGroupList[index].nameGroup,
                              time: AppList.lastGroupTimeList[index],
                            ),
                          );
                        },
                        itemCount: AppList.myGroupList.length,
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }

  void _selecteMenu(String menu, BuildContext context) {
    if (menu == MenuSettings.createGroup) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateGroup()));
    }
  }
}
