import 'package:chat/src/base_compoments/text/text_line_switch.dart';
import 'package:chat/src/base_compoments/text/two_text_and_line.dart';
import 'package:flutter/material.dart';

class SettingChatPage extends StatefulWidget {
  @override
  _SettingChatPageState createState() => _SettingChatPageState();
}

class _SettingChatPageState extends State<SettingChatPage> {
  bool _isChecked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('แชท'),
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
            title: 'วอลเปเปอร์',
            onTap: () {},
          ),
          TwoTextAndLine(
            context: context,
            title: 'ขนาดตัวอักษร',
            onTap: () {},
          ),
          TextLineSwitch(
            context: context,
            title: 'ส่งอีกครั้งอัตโนมัติ ',
            isChecked: _isChecked,
            onTap: () {
              setState(() {
                _isChecked = !_isChecked;
              });
            },
          ),
        ],
      ),
    );
  }
}
