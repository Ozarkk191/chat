import 'dart:developer';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/show_list_item.dart';
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
  List<ShowListItem> _listItem = List<ShowListItem>();
  var items = List<ShowListItem>();

  _getGroupData() async {
    var group;
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        group = GroupModel.fromJson(value.data);
        var uid = group.memberUIDList
            .where((element) => element == AppModel.user.uid);
        if (uid.length != 0) {
          _groupList.add(group);
          setState(() {});
        }
      });
    }).then((value) {
      _getLastText(group);
    });
  }

  _getLastText(GroupModel group) async {
    String lastText = "";
    String lastTime = "";
    String checktime = "";

    if (_groupList.length != 0) {
      for (var i = 0; i < _groupList.length; i++) {
        log(" 000 :: ${_groupList[i].nameGroup}");
        await _databaseReference
            .collection("Rooms")
            .document("chats")
            .collection("Group")
            .document(_groupList[i].groupID)
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
          var chat;
          if (lastTime.isEmpty) {
            chat = ShowListItem(
              checkTime: 0,
              group: _groupList[i],
              lastText: lastText,
              lastTime: lastTime,
            );
          } else {
            chat = ShowListItem(
              checkTime: int.parse(checktime),
              group: _groupList[i],
              lastText: lastText,
              lastTime: lastTime,
            );
          }

          _listItem.add(chat);
          _listItem.sort((a, b) => b.checkTime.compareTo(a.checkTime));
          items.add(chat);
          items.sort((a, b) => b.checkTime.compareTo(a.checkTime));

          setState(() {});
        });
      }
    }
  }

  void _filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<ShowListItem> dummyListData = List<ShowListItem>();
      _listItem.forEach((item) {
        if (item.group.nameGroup.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(_listItem);
      });
    }
  }

  @override
  void initState() {
    _getGroupData();
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
            SearchField(
              onChanged: (val) {
                _filterSearchResults(val);
              },
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
                      AppString.uidRoomChat = items[index].group.groupID;
                      AppModel.group = items[index].group;
                      AppString.nameGroup = items[index].group.nameGroup;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatGroupPage(
                            groupName: items[index].group.nameGroup,
                            groupID: items[index].group.groupID,
                            id: items[index].group.id,
                          ),
                        ),
                      );
                    },
                    child: ListChatItem(
                      profileUrl: items[index].group.avatarGroup,
                      lastText: items[index].lastText,
                      name: items[index].group.nameGroup,
                      time: items[index].lastTime,
                    ),
                  );
                },
                itemCount: items.length,
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _selecteMenu(String menu, BuildContext context) {
    if (menu == MenuSettings.createGroup) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateGroup()));
    }
  }
}
