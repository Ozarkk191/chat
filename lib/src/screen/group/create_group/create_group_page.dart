import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/card/icon_circle_card.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/group_item/add_user_group_button.dart';
import 'package:chat/src/base_compoments/group_item/column_profile_with_name.dart';
import 'package:chat/src/base_compoments/textfield/big_round_textfield.dart';
import 'package:chat/src/screen/invite/invite_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:random_string/random_string.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  String _profileUrl =
      "https://firebasestorage.googleapis.com/v0/b/chat-ae407.appspot.com/o/2020-07-13_15%3A55%3A08.422616?alt=media&token=99b504a0-6eba-42f0-875d-7afed05c2130";
  String _coverUrl =
      "https://s3-ap-southeast-1.amazonaws.com/media.storylog/storycontent/5f25816951a8c606725949ce/15962940851326482829.jpg";
  List<UserModel> _memberList = List<UserModel>();
  TextEditingController _nameGroup = new TextEditingController();
  String _statusGroup = "public";
  File _image;
  File _imageCover;
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

  Future getImageCover() async {
    final pickedCover = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedCover != null) {
        _imageCover = File(pickedCover.path);
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

    if (_image != null) {
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(now2);
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
      var now = DateTime.now().millisecondsSinceEpoch.toString();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(now);
      StorageUploadTask uploadTask = storageRef.putFile(
        File(_imageCover.path),
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;

      _coverUrl = await download.ref.getDownloadURL();
    }

    List<String> uidlist = List<String>();
    List<String> adminlist = List<String>();
    for (int i = 0; i < _memberList.length; i++) {
      uidlist.add(_memberList[i].uid);
    }

    adminlist.add(AppModel.user.uid);

    // for (int i = 0; i < AppList.allAdminList.length; i++) {
    //   uidlist.add(AppList.allAdminList[i].uid);
    // }

    // uidlist.add(AppString.uid);
    var id = randomBetween(100000, 200000).toString();
    var group = GroupModel(
        nameGroup: _nameGroup.text,
        avatarGroup: _profileUrl,
        memberUIDList: uidlist,
        adminList: adminlist,
        statusGroup: _statusGroup,
        coverUrl: _coverUrl,
        idCustom: "ใส่ ID กลุ่ม",
        id: id,
        groupID: now2);
    var _documentReference = Firestore.instance;
    _documentReference
        .collection('Rooms')
        .document("chats")
        .collection('Group')
        .document(now2)
        .setData(group.toJson())
        .then((_) {
      final ChatUser user = ChatUser(
        name: _nameGroup.text,
        uid: now2,
        avatar: _profileUrl,
      );

      ChatMessage message = ChatMessage(
          text: "${_nameGroup.text} ยินดีต้อนรับ", user: user, image: null);
      for (var i = 0; i <= uidlist.length; i++) {
        var documentReference = Firestore.instance
            .collection('Rooms')
            .document('chats')
            .collection('Group')
            .document(now2)
            .collection("${uidlist[i]}")
            .document(DateTime.now().millisecondsSinceEpoch.toString());
        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            message.toJson(),
          );
        }).then((_) {
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => ChatGroupPage(
          //               groupName: _nameGroup.text,
          //               groupID: now2,
          //               id: id,
          //             )));
          AppList.indexList.clear();

          setState(() {
            isLoading = false;
          });
        });
      }
    });

    // _documentReference
    //     .collection('Rooms')
    //     .document("chats")
    //     .collection('Group')
    //     .document(now2)
    //     .setData(group.toJson())
    //     .then((_) {
    // final ChatUser user = ChatUser(
    //   name: AppModel.user.firstName,
    //   uid: AppModel.user.uid,
    //   avatar: AppModel.user.avatarUrl,
    // );
    // ChatMessage message = ChatMessage(
    //     text:
    //         "${AppModel.user.firstName} ได้สร้างกลุ่ม ${_nameGroup.text} ขึ้น",
    //     user: user,
    //     image: null);

    //   var documentReference = Firestore.instance
    //       .collection('Rooms')
    //       .document('chats')
    //       .collection('Group')
    //       .document(AppString.uidRoomChat)
    //       .collection('messages')
    //       .document(DateTime.now().millisecondsSinceEpoch.toString());

    //   Firestore.instance.runTransaction((transaction) async {
    //     await transaction.set(
    //       documentReference,
    //       message.toJson(),
    //     );
    //   }).then((_) {
    //     Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => ChatGroupPage(
    //                   groupName: _nameGroup.text,
    //                   groupID: now2,
    //                   id: id,
    //                 )));
    //     AppList.indexList.clear();

    //     setState(() {
    //       isLoading = false;
    //     });
    //   });
    // });
    // AppModel.group.nameGroup = _nameGroup.text;
  }

  _pushToInvite(BuildContext context) async {
    setState(() {});
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
  //   Random random = new Random();
  //   int randomNumber = random.nextInt(999999) + 100000;
  //   log(randomNumber);
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
          title: Text('สร้างกลุ่ม'),
          backgroundColor: Color(0xff202020),
          leading: InkWell(
              onTap: () {
                AppList.indexList.clear();
                Navigator.pop(context);
              },
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
        body: Stack(
          children: <Widget>[
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
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      'สมาชิก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   // List: [Colors.black.withOpacity(0), Colors.black]
                // ),
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
