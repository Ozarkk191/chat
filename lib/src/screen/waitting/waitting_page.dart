import 'dart:developer';

import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/models/waitting_model.dart';
import 'package:chat/src/base_compoments/group_item/list_waitting_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class WaittingPage extends StatefulWidget {
  final List<WaittingModel> waittingList;

  const WaittingPage({Key key, @required this.waittingList}) : super(key: key);
  @override
  _WaittingPageState createState() => _WaittingPageState();
}

class _WaittingPageState extends State<WaittingPage> {
  Firestore _databaseReference = Firestore.instance;
  List<UserModel> _userList = List<UserModel>();
  List<String> _groupList = List<String>();
  List<String> _groupUIDList = List<String>();
  GroupModel _group;
  bool _loading = true;
  _getWaitting() async {
    for (var i = 0; i < widget.waittingList.length; i++) {
      // log(widget.waittingList[i].uidList);
      for (var j = 0; j < widget.waittingList[i].uidList.length; j++) {
        await _databaseReference
            .collection("Rooms")
            .document("chats")
            .collection("Group")
            .document(widget.waittingList[i].idGroup)
            .get()
            .then((value) {
          _group = GroupModel.fromJson(value.data);
          _groupList.add(_group.nameGroup);
          _groupUIDList.add(widget.waittingList[i].idGroup);
          // _group.nameGroup;
        });
        await _databaseReference
            .collection("Users")
            .document(widget.waittingList[i].uidList[j])
            .get()
            .then((value) {
          var group = UserModel.fromJson(value.data);
          _userList.add(group);

          setState(() {
            _loading = false;
          });
        });
      }
    }
  }

  _addToGroup(String uidGroup, List<dynamic> list) async {
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(uidGroup)
        .updateData({"memberUIDList": list}).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  _getMember(String uidGroup, String uid) async {
    List<dynamic> _list = List<String>();
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(uidGroup)
        .get()
        .then((value) {
      var group = GroupModel.fromJson(value.data);
      _list = group.memberUIDList;
      _list.add(uid);
      _addToGroup(uidGroup, _list);
    });
  }

  _confirm(int index, String uidGroup, String uid) async {
    setState(() {
      _loading = true;
    });
    _userList.removeAt(index);
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(uidGroup)
        .collection("Waitting")
        .document(uid)
        .delete()
        .then((_) {
      _getMember(uidGroup, uid);
    });
  }

  // _confirmAll(List<UserModel> userList, List<String> groupList) async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   groupList.forEach((element) { });
  //   for (var i = 0; i < groupList.length; i++) {
  //     log(userList[i].uid);
  //     log(groupList[i]);

  //     await _databaseReference
  //         .collection("Rooms")
  //         .document("chats")
  //         .collection("Group")
  //         .document(groupList[i])
  //         .collection("Waitting")
  //         .document(userList[i].uid)
  //         .delete()
  //         .then((_) {

  //     });
  //   }
  // }

  _cancel(int index, String uidGroup, String uid) async {
    setState(() {
      _loading = true;
    });
    _userList.removeAt(index);
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(uidGroup)
        .collection("Waitting")
        .document(uid)
        .delete()
        .then((_) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    _getWaitting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _loading,
      child: Scaffold(
        backgroundColor: Color(0xff292929),
        appBar: AppBar(
          title: Text('Waitting list'),
          backgroundColor: Color(0xff202020),
          leading: InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestNav(),
                  ),
                );
              },
              child: Icon(Icons.arrow_back_ios)),
          actions: <Widget>[
            InkWell(
              onTap: () {
                for (var i = 0; i < _groupList.length; i++) {
                  _confirm(i, _groupUIDList[i], _userList[i].uid);
                }
              },
              child: Container(
                width: 70,
                margin: EdgeInsets.only(right: 10),
                child: Center(
                  child: Text('รับทั้งหมด'),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                SearchField(),
                _userList.length != 0
                    ? Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                child: ListWaittingItem(
                              profileUrl: _userList[index].avatarUrl,
                              name: _userList[index].displayName,
                              groupName: _groupList[index],
                              onCancel: () {
                                _cancel(index, _groupUIDList[index],
                                    _userList[index].uid);
                              },
                              onConfirm: () {
                                _confirm(index, _groupUIDList[index],
                                    _userList[index].uid);
                              },
                            ));
                          },
                          itemCount: _userList.length,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
