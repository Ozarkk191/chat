import 'dart:developer';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/textfield/search_group_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SearchPage extends StatefulWidget {
  final List<GroupModel> group;

  const SearchPage({Key key, this.group}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Firestore _databaseReference = Firestore.instance;
  TextEditingController _controller = new TextEditingController();
  List<GroupModel> _groupList = List<GroupModel>();
  bool checkID = true;
  bool _loading = false;
  bool _wait = false;
  bool _group = false;
  String nameGroup = "";

  _searchGroup(String val) {
    _groupList.clear();
    _group = false;
    if (val == "") {
      nameGroup = "";
      setState(() {});
    } else {
      var id;
      if (checkID) {
        id = widget.group.where((element) => element.id == val);
      } else {
        id = widget.group.where((element) => element.nameGroup == val);
      }
      log(id.length.toString());
      if (id.length != 0) {
        _groupList = id.toList();
        _checkMember(_groupList[0].groupID);

        nameGroup = _groupList[0].nameGroup;
      } else {
        nameGroup = "";

        setState(() {});
      }
    }
  }

  _checkMember(String id) async {
    List<dynamic> member;
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(id)
        .get()
        .then((value) {
      var group = GroupModel.fromJson(value.data);
      member = group.memberUIDList;
    }).then((value) {
      var uid = member.where((e) => e == AppModel.user.uid);
      if (uid.length == 0) {
        _getWaitting(id);
      } else {
        _group = true;
        setState(() {});
      }
    });
  }

  _getWaitting(String id) async {
    List<String> uidList = List<String>();
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(id)
        .collection("Waitting")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        uidList.add(value.documentID);
      });
    }).then((value) {
      var waitting = uidList.where((element) => element == AppModel.user.uid);
      if (waitting.length != 0) {
        _wait = true;
      } else {
        _wait = false;
        _group = false;
      }
      setState(() {});
    });
  }

  _setWaitting(String id) async {
    setState(() {
      _loading = true;
    });
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(id)
        .collection("Waitting")
        .document(AppModel.user.uid)
        .setData({"uid": AppModel.user.uid}).then((value) {
      _wait = true;
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: Text("ค้นหากลุ่ม"),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: LoadingOverlay(
        isLoading: _loading,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              SearchGroupTextField(
                controller: _controller,
                onSubmitted: (val) {
                  _searchGroup(val);
                },
                callback: () {
                  _searchGroup(_controller.text);
                },
              ),
              _searchFrom(context),
              SizedBox(height: 20),
              nameGroup != ""
                  ? Container(
                      child: Column(
                        children: <Widget>[
                          ProfileCard(profileUrl: _groupList[0].avatarGroup),
                          Text(
                            _groupList[0].nameGroup,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          RaisedButton(
                            onPressed: _group
                                ? null
                                : _wait
                                    ? null
                                    : () {
                                        _setWaitting(_groupList[0].groupID);
                                      },
                            color: Colors.green,
                            child: Text(_group
                                ? "เข้าร่วมแล้ว"
                                : _wait
                                    ? "กำลังรอการอนุมัติ"
                                    : "เข้าร่วมกลุ่ม"),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Container _searchFrom(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      child: Row(
        children: <Widget>[
          Checkbox(
            checkColor: Colors.black,
            hoverColor: Colors.white,
            focusColor: Colors.white,
            value: checkID,
            onChanged: (val) {
              setState(() {
                checkID = val;
              });
            },
          ),
          Text("ID กลุ่ม"),
          SizedBox(width: 20),
          Checkbox(
            checkColor: Colors.black,
            hoverColor: Colors.white,
            focusColor: Colors.white,
            value: !checkID,
            onChanged: (val) {
              setState(() {
                checkID = !val;
              });
            },
          ),
          Text("ชื่อกลุ่ม")
        ],
      ),
    );
  }
}
