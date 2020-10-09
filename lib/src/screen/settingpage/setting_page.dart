import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/services/authservice.dart';
import 'package:chat/src/base_compoments/text/two_text_and_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'account_page/setting_account_page.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('Setting'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          TwoTextAndLine(
            context: context,
            title: 'บัญชี',
            data: ">",
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingAccountPage()));
            },
          ),
          // TwoTextAndLine(
          //     context: context,
          //     title: 'การแจ้งเตือน',
          //     data: ">",
          //     onTap: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => SettingNotificationPage()));
          //     }),
          // TwoTextAndLine(
          //     context: context,
          //     title: 'แชท',
          //     data: ">",
          //     onTap: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => SettingChatPage()));
          //     }),
          TwoTextAndLine(
              context: context,
              title: 'ออกจากระบบ',
              data: ">",
              onTap: () {
                _login(context);
              }),
          // TwoTextAndLine(
          //     context: context,
          //     title: 'ลบบัญชีผู้ใช้',
          //     onTap: () {
          //       DeleteAccountDialogHelpers.delete(context);
          //     }),
        ],
      )),
    );
  }

  void _login(BuildContext context) async {
    Firestore _databaseReference = Firestore.instance;
    await _databaseReference
        .collection('Users')
        .document(AppModel.user.uid)
        .updateData({
      "isActive": false,
      "lastTimeUpdate": DateTime.now().toString()
    }).then((_) {
      AuthService().signOut();
      Navigator.of(context).pushReplacementNamed('/login');
      clearAll();
    });
  }

  void clearAll() {
    AppList.lastTextList.clear();
    AppList.lastTimeList.clear();
    AppList.lastGroupTextList.clear();
    AppList.lastGroupTimeList.clear();
    AppList.userList.clear();
    AppList.allAdminList.clear();
    AppList.allUserList.clear();
    AppList.allUidList.clear();
    AppList.adminList.clear();
    AppList.uidList.clear();
    AppList.adminUidList.clear();
    AppList.myGroupList.clear();
    AppList.groupList.clear();
    AppList.groupAllList.clear();
    AppList.groupKey.clear();
    AppList.indexList.clear();
    AppList.user.clear();
    AppList.admin.clear();
    AppList.superAdmin.clear();
    AppModel.user = null;
    AppModel.group = null;
    AppBool.homeUserChange = true;
    AppBool.homeAdminChange = true;
    AppBool.groupChange = true;
    AppBool.chatChange = true;
  }
}
