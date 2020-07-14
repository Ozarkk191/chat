import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/src/base_compoments/group_item/list_chat_time_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        leading: Container(),
        actions: <Widget>[
          AppString.roles == '${TypeStatus.USER}'
              ? Container()
              : InkWell(
                  onTap: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/images/ic_add_group.png'),
                  ),
                ),
        ],
        backgroundColor: Color(0xff202020),
        title: Text('แชทกลุ่ม'),
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
                        AppString.uidRoomChat = AppList.groupKey[index];
                        AppString.nameGroup =
                            AppList.groupList[index].nameGroup;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatGroupPage(),
                          ),
                        );
                      },
                      child: ListChatItem(
                        profileUrl: AppList.groupList[index].avatarGroup,
                        lastText: 'ข้อความสุดท้าย',
                        name: AppList.groupList[index].nameGroup,
                        time: '00.00 น.',
                      ),
                    );
                  },
                  itemCount: AppList.groupList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
