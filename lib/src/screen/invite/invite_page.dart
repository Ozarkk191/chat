import 'dart:async';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/list_user_invite_item.dart';
import 'package:flutter/material.dart';

class InvitePage extends StatefulWidget {
  final List<UserModel> user;
  final String groupID;

  const InvitePage({Key key, this.user, this.groupID}) : super(key: key);
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  List<bool> _boolList = List<bool>();
  String _link = "https://secretchat.store/group?uid=";
  List<UserModel> _addUserList = List<UserModel>();

  @override
  void initState() {
    super.initState();
    _link = "$_link${widget.groupID}";
    for (int i = 0; i <= AppList.userList.length; i++) {
      _boolList.add(false);
    }
    Timer(Duration(milliseconds: 500), () {
      if (AppList.indexList.length != 0) {
        for (int i = 0; i <= AppList.indexList.length; i++) {
          _boolList[AppList.indexList[i]] = true;
          setState(() {});
        }
      }
    });
  }

  void _addUser() {
    AppList.indexList.clear();
    for (int i = 0; i < _boolList.length; i++) {
      if (_boolList[i]) {
        UserModel data = AppList.userList[i];
        data.uid = AppList.allUidList[i];
        AppList.indexList.add(i);
        _addUserList.add(data);
      }
    }
    Navigator.pop(context, _addUserList);
  }

  // void _filterSearchResults(String query) {
  //   if (query.isNotEmpty) {
  //     List<UserModel> dummyListData = List<UserModel>();
  //     AppList.userList.forEach((item) {
  //       if (item.displayName.toLowerCase().contains(query.toLowerCase())) {
  //         dummyListData.add(item);
  //       }
  //     });
  //     setState(() {
  //       _items.clear();
  //       _items.addAll(dummyListData);
  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       _items.clear();
  //       _items.addAll(_addUserList);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('เชิญ'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
          onTap: () {
            if (widget.user != null) {
              Navigator.pop(context, widget.user);
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          InkWell(
            onTap: _addUser,
            child: Container(
              width: 70,
              child: Center(
                child: Text('ตกลง'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListUserInviteItem(
                    index: index,
                    profileUrl: AppList.userList[index].avatarUrl,
                    value: _boolList[index],
                    onChanged: (val) {
                      setState(() {
                        // log("$index");
                        _boolList[index] = val;
                        // if(_boolList[index]){
                        //     _intdexList[index] .add(index);
                        // }
                      });
                    },
                    userName: AppList.userList[index].displayName,
                  );
                },
                itemCount: AppList.userList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell boxQRandLink(String pathImage, String boxTitle, Function callback) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xff404040),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(pathImage),
            SizedBox(
              height: 10,
            ),
            Text(
              '$boxTitle',
              style: TextStyle(color: Colors.white, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
