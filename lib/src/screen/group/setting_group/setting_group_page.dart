import 'dart:developer';
import 'dart:io';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/card/icon_circle_card.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/group_item/column_profile_with_name.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingGroupPage extends StatefulWidget {
  final List<UserModel> memberList;
  final String groupName;
  final String groupId;
  final String id;

  const SettingGroupPage(
      {Key key, this.memberList, this.groupName, this.groupId, this.id})
      : super(key: key);
  @override
  _SettingGroupPageState createState() => _SettingGroupPageState();
}

class _SettingGroupPageState extends State<SettingGroupPage> {
  String _profileUrl = "";
  TextEditingController _nameGroup = new TextEditingController();
  String _statusGroup = "public";
  File _image;
  int position;
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

  void _updateDataGroup() async {
    setState(() {
      isLoading = true;
    });

    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(AppString.uidRoomChat);
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
    var _documentReference = Firestore.instance;
    await _documentReference
        .collection('Rooms')
        .document("chats")
        .collection('Group')
        .document(AppString.uidRoomChat)
        .updateData({
      "nameGroup": _nameGroup.text,
      "statusGroup": _statusGroup,
      "avatarGroup": _profileUrl
    }).then((_) {
      AppModel.group.nameGroup = _nameGroup.text;
      AppModel.group.avatarGroup = _profileUrl;
      AppModel.group.statusGroup = _statusGroup;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatGroupPage(
            groupName: widget.groupName,
            groupID: AppString.uidRoomChat,
            id: widget.id,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    _profileUrl = AppModel.group.avatarGroup;
    _nameGroup.text = AppModel.group.nameGroup;
    _statusGroup = AppModel.group.statusGroup;
    if (_statusGroup == "public") {
      position = 0;
    } else {
      position = 1;
    }
    log(AppString.uidRoomChat);
    super.initState();
  }

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
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatGroupPage(
                      groupName: widget.groupName,
                      groupID: widget.groupId,
                      id: widget.id,
                    ),
                  ),
                );
              },
              child: Icon(Icons.arrow_back_ios)),
          actions: <Widget>[
            InkWell(
              onTap: () {
                _updateDataGroup();
              },
              child: Container(
                width: 70,
                child: Center(
                  child: Text('ตกลง'),
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
                  itemCount: widget.memberList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ColumnProFileWithName(
                      profileUrl: widget.memberList[index].avatarUrl,
                      displayName: widget.memberList[index].firstName,
                    );
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
                    initialLabelIndex: position,
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
