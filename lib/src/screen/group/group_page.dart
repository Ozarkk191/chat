import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/src/base_compoments/group_item/list_chat_time_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/group/create_group/create_group_page.dart';
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
                        AppModel.group = AppList.groupList[index];
                        AppString.nameGroup =
                            AppList.groupList[index].nameGroup;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatGroupPage(
                              groupName: AppString.nameGroup,
                            ),
                          ),
                        );
                      },
                      child: ListChatItem(
                        profileUrl: AppList.groupList[index].avatarGroup,
                        lastText: AppList.lastTextList[index],
                        name: AppList.groupList[index].nameGroup,
                        time: AppList.lastTimeList[index],
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

  void _selecteMenu(String menu, BuildContext context) {
    if (menu == MenuSettings.createGroup) {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => CreateGroup()));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateGroup()));
    }
  }
}
