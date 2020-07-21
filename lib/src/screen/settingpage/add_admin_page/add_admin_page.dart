import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/src/base_compoments/group_item/list_user_status.dart';
import 'package:chat/src/base_compoments/text/text_and_line.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:flutter/material.dart';

class AddAdminPage extends StatefulWidget {
  @override
  _AddAdminPageState createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => TestNav()));
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Text("เพิ่มแอดมิน"),
        backgroundColor: Color(0xff202020),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextAndLine(title: "สมาชิกทั้งหมด"),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppList.allUserList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListUserWithStatus(
                    callback: () {},
                    profileUrl: AppList.allUserList[index].avatarUrl,
                    userName: AppList.allUserList[index].displayName,
                    status:
                        AppList.allUserList[index].roles == "${TypeStatus.USER}"
                            ? "USER"
                            : AppList.allUserList[index].roles ==
                                    "${TypeStatus.ADMIN}"
                                ? "ADMIN"
                                : "SUPERADMIN",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
