import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/src/base_compoments/text/two_text_and_line.dart';
import 'package:flutter/material.dart';

class SettingAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('บัญชี'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          TwoTextAndLine(
            context: context,
            title: 'หมายเลขโทรศัพท์',
            data: AppModel.user.phoneNumber,
            onTap: () {},
          ),
          TwoTextAndLine(
            context: context,
            title: 'อีเมล',
            data: AppModel.user.email,
            onTap: () {},
          ),
          TwoTextAndLine(
            context: context,
            title: 'รหัสผ่าน',
            data: '**********',
            onTap: () {},
          ),
          TwoTextAndLine(
            context: context,
            title: 'Facebook',
            onTap: () {},
          ),
          TwoTextAndLine(
            context: context,
            title: 'ล็อครหัสผ่าน',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
