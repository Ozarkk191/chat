import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/text/text_and_line.dart';
import 'package:chat/src/screen/broadcast/broadcast_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddAddminGroupPage extends StatefulWidget {
  final List<dynamic> adminGroupList;
  final GroupModel group;

  const AddAddminGroupPage({
    Key key,
    this.adminGroupList,
    this.group,
  }) : super(key: key);
  @override
  _AddAddminGroupPageState createState() => _AddAddminGroupPageState();
}

class _AddAddminGroupPageState extends State<AddAddminGroupPage> {
  Firestore _databaseReference = Firestore.instance;
  List<UserModel> _adminAll = List<UserModel>();
  List<UserModel> _adminGroup = List<UserModel>();
  List<dynamic> _adminGroupUID = List<dynamic>();
  List<dynamic> _adminGroupUserUID = List<dynamic>();
  bool _firstTime1 = true;
  bool _firstTime2 = true;
  bool _loading = false;
  @override
  void initState() {
    _adminGroupUserUID = widget.group.memberUIDList;
    super.initState();
  }

  Future<List<UserModel>> getAllAdmin() async {
    if (_firstTime1) {
      _adminAll.clear();
      _firstTime1 = false;
      await _databaseReference
          .collection("Users")
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((value) {
          UserModel admin = UserModel.fromJson(value.data);
          if (admin.roles != TypeStatus.USER.toString()) {
            var adminGroup = widget.adminGroupList
                .where((element) => element == admin.uid)
                .toList();
            if (adminGroup.length == 0) {
              _adminAll.add(admin);
              return _adminAll;
            }
          }
        });
      });
    }
    return _adminAll;
  }

  Future<List<UserModel>> getAdminGroup() async {
    if (_firstTime2) {
      _adminGroup.clear();
      _firstTime2 = false;
      for (var i = 0; i < widget.adminGroupList.length; i++) {
        await _databaseReference
            .collection("Users")
            .document(widget.adminGroupList[i].toString())
            .get()
            .then((value) {
          UserModel admin = UserModel.fromJson(value.data);
          _adminGroup.add(admin);
          _adminGroupUID.add(admin.uid);
          return _adminGroup;
        });
      }
    }
    return _adminGroup;
  }

  void _update() async {
    setState(() {
      _loading = true;
    });
    GroupModel group = widget.group;
    group.adminList = _adminGroupUID;
    group.memberUIDList = _adminGroupUserUID;

    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(widget.group.groupID)
        .updateData({"adminList": _adminGroupUID}).then((value) {
      setState(() {
        _loading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Broadcast(
            group: group,
            uidList: group.memberUIDList,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _loading,
      child: Scaffold(
        backgroundColor: Color(0xff292929),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("เพิ่มแอดมิน"),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                _update();
              },
              child: Container(
                width: 60,
                height: 50,
                child: Center(
                  child: Text("บันทึก"),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                TextAndLine(title: "แอดมินของกลุ่ม"),
                FutureBuilder(
                  future: getAdminGroup(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: _adminGroup.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return _item(
                              context: context,
                              callback: () {
                                if (_adminGroup.length > 1) {
                                  _adminAll.add(_adminGroup[index]);
                                  _adminGroupUserUID
                                      .add(_adminGroup[index].uid);
                                  _adminGroup.removeAt(index);
                                  _adminGroupUID.removeAt(index);
                                  setState(() {});
                                } else {
                                  _dialogShow(
                                    title: "ไม่สามารถทำรายการได้",
                                    content:
                                        "ต้องมีแอดมินในกลุ่มอย่างน้อย 1 คน",
                                  );
                                }
                              },
                              urlAvater: _adminGroup[index].avatarUrl,
                              username: _adminGroup[index].displayName,
                              icon: Icons.arrow_circle_down);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                TextAndLine(title: "แอดมินทั้งหมด"),
                FutureBuilder(
                  future: getAllAdmin(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: _adminAll.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return _item(
                              context: context,
                              callback: () {
                                _adminGroup.add(_adminAll[index]);
                                _adminGroupUID.add(_adminAll[index].uid);
                                _adminAll.removeAt(index);
                                _adminGroupUserUID.removeAt(index);
                                setState(() {});
                              },
                              urlAvater: _adminAll[index].avatarUrl,
                              username: _adminAll[index].displayName,
                              icon: Icons.arrow_circle_up);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _dialogShow({String title, String content}) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('$title'),
            content: new Text('$content'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Text("ตกลง"),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Container _item({
    BuildContext context,
    String urlAvater,
    String username,
    Function callback,
    IconData icon,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                ProfileCard(
                  profileUrl: urlAvater,
                  height: 50,
                  width: 50,
                ),
                Text(
                  username,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: callback,
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
