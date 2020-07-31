import 'dart:developer';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/chat_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/list_chat_time_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';

import 'chat_room_page.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Firestore _databaseReference = Firestore.instance;
  List<String> _uidList = List<String>();
  List<ChatModel> _chatList = List<ChatModel>();
  List<UserModel> _userList = List<UserModel>();

  _getAllUser() async {
    await _databaseReference
        .collection("Users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        var allUser = UserModel.fromJson(value.data);
        if (AppModel.user.roles != "${TypeStatus.USER}") {
          if (allUser.roles == "${TypeStatus.USER}") {
            _userList.add(allUser);
            _uidList.add(value.documentID);
            List<String> uidsList = [
              value.documentID,
              AppModel.user.uid,
            ];
            uidsList.sort();
            String key = "${uidsList[0]}_${uidsList[1]}";
            _getLastText(key, allUser);
            // setState(() {});
          }
        } else {
          if (allUser.roles != "${TypeStatus.USER}") {
            _userList.add(allUser);
            _uidList.add(value.documentID);
            List<String> uidsList = [
              value.documentID,
              AppModel.user.uid,
            ];
            uidsList.sort();
            String key = "${uidsList[0]}_${uidsList[1]}";
            _getLastText(key, allUser);
            // setState(() {});
          }
        }
      });
    });
  }

  _getLastText(String key, UserModel user) async {
    String lastText = "";
    String lastTime = "";
    String checktime = "";
    log("message0123");

    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("ChatRoom")
        .document(key)
        .collection("messages")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        var message = ChatMessage.fromJson(value.data);

        if (message != null) {
          if (message.text.isEmpty) {
            lastText = "รูปภาพ";
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
        chat = ChatModel(
          checkTime: 0,
          user: user,
          lastText: lastText,
          lastTime: lastTime,
        );
      } else {
        chat = ChatModel(
          checkTime: int.parse(checktime),
          user: user,
          lastText: lastText,
          lastTime: lastTime,
        );
      }

      _chatList.add(chat);
      _chatList.sort((a, b) => b.checkTime.compareTo(a.checkTime));
      setState(() {});
    });
  }

  @override
  void initState() {
    _getAllUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Color(0xff202020),
        title: AppString.roles == "${TypeStatus.USER}"
            ? Text('แชทกับแอดมิน')
            : Text('แชทกับลูกค้า'),
        centerTitle: true,
      ),
      body: _chatList.length != 0
          ? SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    SearchField(),
                    SizedBox(height: 10),
                    _chatList.length != 0
                        ? Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    // AppString.uidRoomChat = AppList.uidList[index];
                                    AppString.uidAdmin =
                                        _chatList[index].user.uid;
                                    List<String> uidsList = [
                                      AppString.uidAdmin,
                                      AppModel.user.uid
                                    ];
                                    uidsList.sort();
                                    String test =
                                        "${uidsList[0]}_${uidsList[1]}";
                                    AppString.uidRoomChat = test;

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatRoomPage()));
                                  },
                                  child: ListChatItem(
                                    profileUrl: _chatList[index].user.avatarUrl,
                                    lastText: _chatList[index].lastText,
                                    name: _chatList[index].user.displayName,
                                    time: _chatList[index].lastTime,
                                  ),
                                );
                              },
                              itemCount: _userList.length,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
