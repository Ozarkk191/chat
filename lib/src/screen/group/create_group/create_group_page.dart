import 'dart:io';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/card/icon_circle_card.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/group_item/add_user_group_button.dart';
import 'package:chat/src/base_compoments/group_item/column_profile_with_name.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:chat/src/screen/invite/invite_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String _profileUrl =
      "https://firebasestorage.googleapis.com/v0/b/chat-ae407.appspot.com/o/2020-07-13_15%3A55%3A08.422616?alt=media&token=99b504a0-6eba-42f0-875d-7afed05c2130";
  List<UserModel> _memberList = List<UserModel>();
  TextEditingController _nameGroup = new TextEditingController();
  String _statusGroup = "public";
  File _image;
  final picker = ImagePicker();
  bool isLoading = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  bool _check() {
    if (_profileUrl == null) {
      return false;
    } else if (_nameGroup.text == null) {
      return false;
    } else if (_memberList.length == 0) {
      return false;
    }
    return true;
  }

  void _createGroup() async {
    setState(() {
      isLoading = true;
    });
    var now2 = DateTime.now().millisecondsSinceEpoch.toString();
    AppString.uidRoomChat = now2;
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(now2);
    if (_image != null) {
      StorageUploadTask uploadTask = storageRef.putFile(
        File(_image.path),
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;

      _profileUrl = await download.ref.getDownloadURL();
    }

    List<String> uidlist = List<String>();
    for (int i = 0; i < _memberList.length; i++) {
      uidlist.add(_memberList[i].uid);
      print(_memberList[i].uid);
    }
    uidlist.add(AppString.uid);

    var group = GroupModel(
        nameGroup: _nameGroup.text,
        avatarGroup: _profileUrl,
        memberUIDList: uidlist,
        statusGroup: _statusGroup,
        coverUrl: _profileUrl);
    var _documentReference = Firestore.instance;
    _documentReference
        .collection('Rooms')
        .document("chats")
        .collection('Group')
        .document(now2)
        .setData(group.toJson());
    AppString.nameGroup = _nameGroup.text;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ChatGroupPage()));

    setState(() {
      isLoading = false;
    });
  }

  _pushToInvite(BuildContext context) async {
    _memberList = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvitePage(
          user: _memberList,
        ),
      ),
    );
    setState(() {});
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // _nameGroup.text = _profileUrl;
  // }

  @override
  void dispose() {
    _nameGroup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Color(0xff292929),
        appBar: AppBar(
          title: Text('ตั้งค่าโปรไฟล์กลุ่ม'),
          backgroundColor: Color(0xff202020),
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios)),
          actions: <Widget>[
            InkWell(
              onTap: !_check()
                  ? null
                  : () {
                      _createGroup();
                    },
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
                  itemCount: _memberList.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return AddUserGroupButton(
                        onTop: () {
                          _pushToInvite(context);
                        },
                        title: 'เชิญ',
                      );
                    } else {
                      return ColumnProFileWithName(
                        profileUrl: _memberList[index - 1].avatarUrl,
                        displayName: _memberList[index - 1].firstName,
                      );
                    }
                  },
                ),
              )
            ],
          ),
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
                _image == null
                    ? ProfileCard(profileUrl: _profileUrl)
                    : Card(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70, width: 1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Image.file(
                          _image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                InkWell(
                  onTap: getImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.all(5),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconCircleCard(
                          iconPath: 'assets/images/ic_camera_circle.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: ToggleSwitch(
                    minWidth: 50,
                    initialLabelIndex: 0,
                    activeBgColor: Colors.redAccent,
                    activeTextColor: Colors.white,
                    inactiveBgColor: Colors.white,
                    inactiveTextColor: Colors.black,
                    labels: ['', ''],
                    icons: [Icons.public, Icons.person],
                    onToggle: (index) {
                      if (index == 0) {
                        setState(() {
                          _statusGroup = "public";
                        });
                      } else {
                        setState(() {
                          _statusGroup = "private";
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  textAlign: TextAlign.center,
                  maxLength: 20,
                  controller: _nameGroup,
                  style: TextStyle(color: Colors.white),
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
