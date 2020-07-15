import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/row_profile_with_name.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllMemberPage extends StatefulWidget {
  @override
  _AllMemberPageState createState() => _AllMemberPageState();
}

class _AllMemberPageState extends State<AllMemberPage> {
  Firestore _databaseReference = Firestore.instance;
  List<UserModel> _memberList = List<UserModel>();

  // AppString.uidRoomChat

  void _getMemberUID() async {
    await _databaseReference
        .collection('Rooms')
        .document('chats')
        .collection('Group')
        .document(AppString.uidRoomChat)
        .get()
        .then((value) {
      var member = GroupModel.fromJson(value.data);
      _getMember(member.memberUIDList);
    });
  }

  void _getMember(List<dynamic> list) {
    if (list.length != 0) {
      for (int i = 0; i < list.length; i++) {
        _databaseReference
            .collection('Users')
            .document(list[i].toString())
            .get()
            .then((value) {
          var member = UserModel.fromJson(value.data);
          _memberList.add(member);
          setState(() {});
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getMemberUID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('สมาชิกทั้งหมด'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              SearchField(),
              SizedBox(height: 10),
              _memberList.length != 0
                  ? Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _memberList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: ObjectKey(_memberList[index]),
                            child: RowProfileWithName(
                              profileUrl: _memberList[index].avatarUrl,
                              displayName: _memberList[index].displayName,
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
