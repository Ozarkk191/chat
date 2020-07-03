import 'package:chat/src/base_compoments/text/text_line_switch.dart';
import 'package:flutter/material.dart';

class SettingNotificationPage extends StatefulWidget {
  @override
  _SettingNotificationPageState createState() =>
      _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  bool _isCheckedNoti = true;
  bool _isCheckedWait = false;
  bool _isCheckedEmail = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('แจ้งเตือน'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20),
          TextLineSwitch(
            context: context,
            title: 'การแจ้งเตือนแอพ',
            isChecked: _isCheckedNoti,
            onTap: () {
              setState(() {
                _isCheckedNoti = !_isCheckedNoti;
              });
            },
          ),
          TextLineSwitch(
            context: context,
            title: 'ปิดการแจ้งเตือนชั่วคราว',
            isChecked: _isCheckedWait,
            onTap: () {
              setState(() {
                _isCheckedWait = !_isCheckedWait;
              });
            },
          ),
          TextLineSwitch(
            context: context,
            title: 'การแจ้งเตือนทาง E-mail',
            isChecked: _isCheckedEmail,
            onTap: () {
              setState(() {
                _isCheckedEmail = !_isCheckedEmail;
              });
            },
          ),
        ],
      ),
    );
  }
}
