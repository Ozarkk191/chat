import 'package:chat/helpers/user_dialog_helper.dart';
import 'package:chat/services/authservice.dart';
import 'package:chat/src/base_compoments/text/two_text_and_line.dart';
import 'package:flutter/material.dart';
import 'account_page/setting_account_page.dart';
import 'chat_page/setting_chat_page.dart';
import 'notification_page/setting_notifition_page.dart';

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
          TwoTextAndLine(
              context: context,
              title: 'การแจ้งเตือน',
              data: ">",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingNotificationPage()));
              }),
          TwoTextAndLine(
              context: context,
              title: 'แชท',
              data: ">",
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingChatPage()));
              }),
          TwoTextAndLine(
              context: context,
              title: 'ออกจากระบบ',
              data: ">",
              onTap: () {
                AuthService().signOut();
                Navigator.of(context).pushReplacementNamed('/');
              }),
          TwoTextAndLine(
              context: context,
              title: 'ลบบัญชีผู้ใช้',
              onTap: () {
                DeleteAccountDialogHelpers.delete(context);
              }),
        ],
      )),
    );
  }
}
