import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/chat_model.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/list_chat_time_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';

class UserGruopPage extends StatefulWidget {
  @override
  _UserGruopPageState createState() => _UserGruopPageState();
}

class _UserGruopPageState extends State<UserGruopPage> {
  final _databaseReference = Firestore.instance;
  List<GroupModel> _groupList = List<GroupModel>();
  List<ChatModel> _itemList = List<ChatModel>();
  List<ChatModel> _itemGroupList = List<ChatModel>();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

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
        var uid = group.memberUIDList
            .where((element) => element == AppModel.user.uid);
        if (uid.length != 0) {
          _groupList.add(group);
          _getText(group: group);
        }
      });
    }).then((value) {
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  _getText({GroupModel group}) async {
    ChatMessage message;
    UserModel user;
    AppList.listItem.clear();
    AppList.listItemGroup.clear();
    String lastTime = "";
    String lastText = "";
    String checktime = "";

    await _databaseReference
        .collection('Users')
        .document(AppModel.user.uid)
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data);
    });
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(group.groupID)
        .collection(AppModel.user.uid)
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

      if (AppModel.user.uid == chat.user.uid) {
        _itemGroupList.add(chat);
        _itemGroupList.sort((a, b) => b.checkTime.compareTo(a.checkTime));
        _itemList.add(chat);
        _itemList.sort((a, b) => b.checkTime.compareTo(a.checkTime));
      }

      if (this.mounted) {
        setState(() {});
      }
    });
  }

  void _filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<ChatModel> dummyListData = List<ChatModel>();
      _itemGroupList.forEach((item) {
        if (item.group.nameGroup.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      if (this.mounted) {
        setState(() {
          _itemList.clear();
          _itemList.addAll(dummyListData);
        });
      }
      return;
    } else {
      if (this.mounted) {
        setState(() {
          _itemList.clear();
          _itemList.addAll(_itemGroupList);
        });
      }
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
        backgroundColor: Colors.black,
        title: Text('กลุ่ม'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: 10),
              SearchField(
                onChanged: (val) {
                  _filterSearchResults(val);
                },
              ),
              SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatGroupPage(
                                groupName: _itemList[index].group.nameGroup,
                                groupID: _itemList[index].group.groupID,
                                id: AppModel.user.uid,
                                group: _itemList[index].group,
                              ),
                            ),
                          );
                        },
                        child: ListChatItem(
                          profileUrl: _itemList[index].group.avatarGroup,
                          lastText: _itemList[index].lastText,
                          name: _itemList[index].group.nameGroup,
                          time: _itemList[index].lastTime,
                        ));
                  },
                  itemCount: _itemList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}