import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/list_chat_time_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_room_page.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Firestore _databaseReference = Firestore.instance;
  List<String> _uidList = List<String>();
  List<UserModel> _userList = List<UserModel>();

  _getAllUser() async {
    await _databaseReference
        .collection("Users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        var allUser = UserModel.fromJson(value.data);
        if (allUser.roles != "${TypeStatus.USER}") {
          _userList.add(allUser);
          _uidList.add(value.documentID);
          setState(() {});
        }
      });
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
      body: _userList.length != 0
          ? SingleChildScrollView(
              child: Container(
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
                              // AppString.uidRoomChat = AppList.uidList[index];
                              AppString.uidAdmin = _uidList[index];
                              List<String> uidsList = [
                                AppString.uidAdmin,
                                AppModel.user.uid
                              ];
                              uidsList.sort();
                              String test = "${uidsList[0]}_${uidsList[1]}";
                              AppString.uidRoomChat = test;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatRoomPage()));
                            },
                            child: ListChatItem(
                              profileUrl: _userList[index].avatarUrl,
                              lastText: 'ข้อความสุดท้าย',
                              name: _userList[index].displayName,
                              time: '00.00 น.',
                            ),
                          );
                        },
                        itemCount: _userList.length,
                      ),
                    ),
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
