import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/src/base_compoments/group_item/list_chat_time_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:flutter/material.dart';

import 'chat_room_page.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        actions: <Widget>[
          Container(width: 40, height: 40, child: Icon(Icons.more_vert)),
        ],
        leading: Container(),
        backgroundColor: Color(0xff202020),
        title: Text('Chat'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                        AppString.uidRoomChat = AppList.uidList[index];
                        List<String> uidsList = [
                          AppString.uidRoomChat,
                          AppString.uid
                        ];
                        uidsList.sort();
                        String test = "${uidsList[0]}_${uidsList[1]}";
                        AppString.uidRoomChat = test;
                        print('$test');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatRoomPage()));
                      },
                      child: ListChatItem(
                        profileUrl: AppList.userList[index].avatarUrl,
                        lastText: 'ข้อความสุดท้าย',
                        name: AppList.userList[index].displayName,
                        time: '00.00 น.',
                      ),
                    );
                  },
                  itemCount: AppList.userList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
