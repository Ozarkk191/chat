import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/card/icon_circle_card.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/group_item/column_profile_with_name.dart';
import 'package:chat/src/base_compoments/textfield/big_round_textfield.dart';
import 'package:chat/src/screen/broadcast/broadcast_page.dart';
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
  final GroupModel group;

  const SettingGroupPage({
    Key key,
    this.memberList,
    this.groupName,
    this.groupId,
    this.id,
    this.group,
  }) : super(key: key);
  @override
  _SettingGroupPageState createState() => _SettingGroupPageState();
}

class _SettingGroupPageState extends State<SettingGroupPage> {
  String _profileUrl = "";
  String _coverUrl = "";
  TextEditingController _idController = new TextEditingController();
  TextEditingController _nameGroup = new TextEditingController();
  String _statusGroup = "public";
  File _image;
  int position;
  File _imageCover;
  final picker = ImagePicker();
  bool isLoading = false;
  String _id;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future getImageCover() async {
    final pickedCover = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedCover != null) {
        _imageCover = File(pickedCover.path);
      }
    });
  }

  void _updateDataGroup() async {
    setState(() {
      isLoading = true;
    });
    var date = DateTime.now().millisecondsSinceEpoch;
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(date.toString());

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
    if (_imageCover != null) {
      StorageUploadTask uploadTask = storageRef.putFile(
        File(_imageCover.path),
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;

      _coverUrl = await download.ref.getDownloadURL();
    }
    var _documentReference = Firestore.instance;
    var group = GroupModel(
      adminList: widget.group.adminList,
      avatarGroup: _profileUrl,
      coverUrl: _coverUrl,
      groupID: widget.group.groupID,
      id: _id,
      idCustom: widget.group.idCustom,
      memberUIDList: widget.group.memberUIDList,
      nameGroup: _nameGroup.text,
      statusGroup: _statusGroup,
    );
    await _documentReference
        .collection('Rooms')
        .document("chats")
        .collection('Group')
        .document(widget.group.groupID)
        .setData(group.toJson())
        .then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Broadcast(
            group: group,
            uidList: widget.group.memberUIDList,
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    _profileUrl = widget.group.avatarGroup;
    _nameGroup.text = widget.group.nameGroup;
    _statusGroup = widget.group.statusGroup;
    _coverUrl = widget.group.coverUrl;
    _idController.text = widget.group.id;
    _id = widget.group.id;
    if (_statusGroup == "public") {
      position = 0;
    } else {
      position = 1;
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameGroup.dispose();
    _idController.dispose();
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
                    builder: (context) => Broadcast(
                      group: widget.group,
                      uidList: widget.group.memberUIDList,
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
        body: Stack(
          children: [
            _imageCover == null
                ? CachedNetworkImage(
                    imageUrl: _coverUrl,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    _imageCover,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  headerGroup(context),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "ID Group : ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            textAlign: TextAlign.center,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            buildCounter: (BuildContext context,
                                    {int currentLength,
                                    int maxLength,
                                    bool isFocused}) =>
                                null,
                            style: TextStyle(color: Colors.white),
                            onChanged: (val) {
                              setState(() {
                                _id = val;
                              });
                            },
                            controller: _idController,
                            decoration: InputDecoration(
                              hintText: "id group",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'สมาชิก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20, right: 20),
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
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container headerGroup(BuildContext context) {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Stack(
                      children: <Widget>[
                        _image == null
                            ? ProfileCard(profileUrl: _profileUrl)
                            : Card(
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.white70, width: 1),
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
                                  iconPath:
                                      'assets/images/ic_camera_circle.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
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
                          BigRoundTextField(
                            controller: _nameGroup,
                            hintText: "ชื่อกลุ่ม",
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            maxLength: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(1),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0), Colors.black]),
              ),
              child: InkWell(
                onTap: () {
                  getImageCover();
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        Text(
                          "เพิ่มรูปปกกลุ่ม",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
