import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/list_user_item.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UnBanned extends StatefulWidget {
  final List<UserModel> userBannedList;

  const UnBanned({Key key, @required this.userBannedList}) : super(key: key);
  @override
  _UnBannedState createState() => _UnBannedState();
}

class _UnBannedState extends State<UnBanned> {
  Firestore _databaseReference = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        backgroundColor: Color(0xff202020),
        title: Text("ปลดแบน"),
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => TestNav()));
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: widget.userBannedList.length != 0
            ? Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.userBannedList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            _dialogShow(
                                title: "แจ้งเตือน",
                                content:
                                    "คุณต้องการปลดแบน ${widget.userBannedList[index].displayName} ออกจากระบบหรือไม่",
                                index: index,
                                uid: widget.userBannedList[index].uid,
                                status: "admin");
                          },
                          child: ListUserItem(
                            callback: () {},
                            profileUrl: widget.userBannedList[index].avatarUrl,
                            userName: widget.userBannedList[index].displayName,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text(
                    "ไม่มีรายชื่อที่ถูกแบน",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
      ),
    );
  }

  Future<bool> _dialogShow({
    String title,
    String content,
    int index,
    String uid,
    String status,
  }) async {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('$title'),
            content: Text('$content'),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                  widget.userBannedList.removeAt(index);

                  _databaseReference
                      .collection("Users")
                      .document(uid)
                      .updateData({"banned": false}).then((_) {
                    setState(() {});
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("ใช่"),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("ไม่"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}
