import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/chat_model.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/list_chat_time_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/group/create_group/create_group_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final _databaseReference = Firestore.instance;
  List<GroupModel> _groupList = List<GroupModel>();
  List<String> _groupNameList = List<String>();
  List<ChatModel> _listItem = List<ChatModel>();
  String _groupNameChoose = "group";

  // var items = List<ShowListItem>();

  _getGroupData() async {
    GroupModel group;

    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        group = GroupModel.fromJson(value.data);
        var uid =
            group.adminList.where((element) => element == AppModel.user.uid);
        if (uid.length != 0) {
          _groupList.add(group);
          _groupNameList.add(group.nameGroup);
          _groupNameChoose = group.nameGroup;

          // _getChat(group);
          _getText(group: group, memberList: group.memberUIDList);

          setState(() {});
        }
      });
    }).then((value) {
      // _getLastText(group.groupID, group.memberUIDList);
      // log("----> || ${group.nameGroup}");
    });
  }

  // void _getMenu(List<GroupModel> list) async {
  //   if (list.length == 0) {
  //     _groupNameChoose = "group";
  //   }else{
  //     for (var i = 0; i < count; i++) {

  //     }
  //   }
  // }

  _getText({GroupModel group, List<dynamic> memberList}) async {
    ChatMessage message;
    UserModel user;
    String lastTime = "";
    String lastText = "";
    String checktime = "";
    for (var i = 0; i <= memberList.length; i++) {
      await _databaseReference
          .collection('Users')
          .document(memberList[i])
          .get()
          .then((value) {
        user = UserModel.fromJson(value.data);
      });
      await _databaseReference
          .collection("Rooms")
          .document("chats")
          .collection("Group")
          .document(group.groupID)
          .collection(memberList[i])
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((value) {
          message = ChatMessage.fromJson(value.data);
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

            if (lastTime.isNotEmpty) {
              checktime = lastTime.replaceAll(".", "");
              checktime = checktime.replaceAll(" ", "");
              checktime = checktime.replaceAll(":", "");
              checktime = checktime.replaceAll("-", "");
            } else {
              checktime = "0";
            }
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
        ChatModel chat;
        if (lastTime.isEmpty) {
          chat = ChatModel(
            checkTime: 0,
            user: user,
            lastText: lastText,
            lastTime: lastTime,
            group: group,
          );
        } else {
          chat = ChatModel(
            checkTime: int.parse(checktime),
            user: user,
            lastText: lastText,
            lastTime: lastTime,
            group: group,
          );
        }
        if (AppModel.user.roles == "${TypeStatus.USER}") {
          if (AppModel.user.uid == chat.user.uid) {
            _listItem.add(chat);
            _listItem.sort((a, b) => b.checkTime.compareTo(a.checkTime));
            AppList.listItemGroup.add(chat);
            AppList.listItemGroup
                .sort((a, b) => b.checkTime.compareTo(a.checkTime));
          }
        } else {
          _listItem.add(chat);
          _listItem.sort((a, b) => b.checkTime.compareTo(a.checkTime));
          AppList.listItemGroup.add(chat);
          AppList.listItemGroup
              .sort((a, b) => b.checkTime.compareTo(a.checkTime));
          _filterSearchResults(group.nameGroup);
        }

        setState(() {});
      });
    }
  }

  void _filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<ChatModel> dummyListData = List<ChatModel>();
      _listItem.forEach((item) {
        if (item.group.nameGroup.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        AppList.listItemGroup.clear();
        AppList.listItemGroup.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        AppList.listItemGroup.clear();
        AppList.listItemGroup.addAll(_listItem);
      });
    }
  }

  @override
  void initState() {
    if (AppBool.groupChange) {
      AppList.listItemGroup.clear();
      AppBool.groupChange = false;
      _getGroupData();
    }

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
                  },
                ),
        ],
        backgroundColor: Colors.black,
        title: Text('แชทกลุ่ม'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              // SearchField(
              //   onChanged: (val) {
              //     _filterSearchResults(val);
              //   },
              // ),
              Container(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<String>(
                  initialValue: _groupNameChoose,
                  child: Container(
                    width: 150,
                    height: 40,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _groupNameChoose,
                          style: TextStyle(color: Colors.black),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  color: Color(0xffffffff),
                  onSelected: (value) {
                    setState(() {
                      _groupNameChoose = value;
                      _filterSearchResults(_groupNameChoose);
                    });

                    // _selecteMenu(value, context);
                  },
                  itemBuilder: (BuildContext context) {
                    return _groupNameList.map((String menu) {
                      return PopupMenuItem<String>(
                        value: menu,
                        child: Text(
                          menu,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        AppString.uidRoomChat =
                            AppList.listItemGroup[index].group.groupID;
                        AppModel.group = AppList.listItemGroup[index].group;
                        AppString.nameGroup =
                            AppList.listItemGroup[index].group.nameGroup;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatGroupPage(
                              groupName:
                                  AppList.listItemGroup[index].group.nameGroup,
                              groupID:
                                  AppList.listItemGroup[index].group.groupID,
                              id: AppList.listItemGroup[index].user.uid,
                            ),
                          ),
                        );
                      },
                      child: AppModel.user.roles == "${TypeStatus.USER}"
                          ? ListChatItem(
                              profileUrl: AppList
                                  .listItemGroup[index].group.avatarGroup,
                              lastText: AppList.listItemGroup[index].lastText,
                              name:
                                  AppList.listItemGroup[index].group.nameGroup,
                              time: AppList.listItemGroup[index].lastTime,
                            )
                          : ListChatItem(
                              profileUrl:
                                  AppList.listItemGroup[index].user.avatarUrl,
                              lastText: AppList.listItemGroup[index].lastText,
                              name:
                                  AppList.listItemGroup[index].user.displayName,
                              time: AppList.listItemGroup[index].lastTime,
                            ),
                    );
                  },
                  itemCount: AppList.listItemGroup.length,
                ),
              ),
            ],
          ),
        ),
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
