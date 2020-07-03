import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/src/base_compoments/card/icon_circle_card.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/group_item/add_user_group_button.dart';
import 'package:chat/src/base_compoments/group_item/column_profile_with_name.dart';
import 'package:flutter/material.dart';

class SettingGroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('ตั้งค่าโปรไฟล์กลุ่ม'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        actions: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
              width: 70,
              child: Center(
                child: Text('สร้าง'),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            headerGroup(context),
            Text(
              'สมาชิก',
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return AddUserGroupButton(
                      title: 'เชิญ',
                    );
                  } else {
                    return ColumnProFileWithName(
                      profileUrl: AppString.photoUrl,
                      displayName: AppString.displayName,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container headerGroup(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(right: 20),
            child: Stack(
              children: <Widget>[
                ProfileCard(
                    profileUrl: "https://wallpapercave.com/wp/w1fkwPh.jpg"),
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconCircleCard(
                        iconPath: 'assets/images/ic_camera_circle.png'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                DropdownButton<String>(
                  value: 'assets/images/ic_globe.png',
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {},
                  items: <String>[
                    'assets/images/ic_globe.png',
                    'assets/images/ic_peple.png',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Image.asset(value),
                    );
                  }).toList(),
                ),
                TextField(
                  textAlign: TextAlign.center,
                  maxLength: 50,
                  decoration: InputDecoration(
                    hintText: 'ชื่อกลุ่ม',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
