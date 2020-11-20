import 'dart:developer';
import 'dart:io';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/request_body_parameters.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/repositories/post_repository.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/screen/add_user/add_admin_garoup_page.dart';
import 'package:chat/src/screen/group/setting_group/setting_group_page.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:page_transition/page_transition.dart';

class Broadcast extends StatefulWidget {
  final List<dynamic> uidList;
  final GroupModel group;

  const Broadcast({Key key, this.uidList, this.group}) : super(key: key);
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  bool _select = true;
  File _file;
  final picker = ImagePicker();
  Firestore _databaseReference = Firestore.instance;
  List<String> _tokenList = List<String>();
  List<UserModel> _userList = List<UserModel>();
  ChatUser user;
  bool _loading = false;
  TextEditingController _controller = TextEditingController();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _getToken() async {
    user = ChatUser(
      name: widget.group.nameGroup,
      uid: widget.group.groupID,
      avatar: widget.group.avatarGroup,
    );
    for (var i = 0; i < widget.uidList.length; i++) {
      await _databaseReference
          .collection('Users')
          .document(widget.uidList[i].toString())
          .get()
          .then((value) {
        UserModel user = UserModel.fromJson(value.data);
        _tokenList.add(user.notiToken);
        _userList.add(user);
        setState(() {});
      });
    }
  }

  void _sendNotification(String text, String token, String uid) async {
    var parameter = SendNotiParameters(
      title: widget.group.nameGroup,
      body: text == "" ? "คุณได้รับรูปภาพ" : "คุณได้รับข้อความ",
      data: "${widget.group.nameGroup}&&${widget.group.groupID}&&group&&$uid",
      token: token,
    );
    var response = await PostRepository().sendNotification(parameter);
    log(response['message']);
  }

  void onSend(ChatMessage message) {
    for (var i = 0; i < widget.uidList.length; i++) {
      var documentReference = Firestore.instance
          .collection('Rooms')
          .document('chats')
          .collection('Group')
          .document(widget.group.groupID)
          .collection(widget.uidList[i].toString())
          .document(message.createdAt.millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          message.toJson(),
        );
      });

      _sendNotification(
        message.text,
        _tokenList[i],
        widget.uidList[i].toString(),
      );
    }
    AppBool.groupChange = true;
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: TestNav(
          currentIndex: 1,
        ),
      ),
    );
    setState(() {
      _loading = false;
    });
  }

  void _upLoadPic() async {
    var now = new DateTime.now();
    var now2 = now.toString().replaceAll(" ", "_");

    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(now2);

    StorageUploadTask uploadTask = storageRef.putFile(
      _file,
      StorageMetadata(
        contentType: 'image/jpg',
      ),
    );
    StorageTaskSnapshot download = await uploadTask.onComplete;
    String url = await download.ref.getDownloadURL();
    ChatMessage message = ChatMessage(text: "", user: user, image: url);
    for (var i = 0; i < widget.uidList.length; i++) {
      var documentReference = Firestore.instance
          .collection('Rooms')
          .document('chats')
          .collection('Group')
          .document(widget.group.groupID)
          .collection(widget.uidList[i].toString())
          .document(message.createdAt.millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          message.toJson(),
        );
      });
      _sendNotification(
        message.text,
        _tokenList[i],
        widget.uidList[i].toString(),
      );
    }
    AppBool.groupChange = true;
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: TestNav(
          currentIndex: 1,
        ),
      ),
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _loading,
      child: Scaffold(
        backgroundColor: Color(0xff292929),
        appBar: AppBar(
          title: Text('Broadcast'),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: TestNav(
                    currentIndex: 2,
                  ),
                ),
              );
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          actions: [
            InkWell(
              onTap: () {
                ChatMessage message;
                setState(() {
                  _loading = true;
                });
                if (_select) {
                  message = ChatMessage(
                    text: _controller.text,
                    user: user,
                  );
                  onSend(message);
                } else {
                  _upLoadPic();
                }
              },
              child: Container(
                width: 60,
                height: 50,
                child: Center(
                  child: Text("โพสต์"),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 120,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ProfileCard(
                          profileUrl: widget.group.avatarGroup,
                          width: 70,
                          height: 70,
                          elevation: 10,
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${widget.group.nameGroup}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "Group ID : ${widget.group.id}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingGroupPage(
                                      memberList: _userList,
                                      groupName: widget.group.nameGroup,
                                      groupId: widget.group.groupID,
                                      id: widget.group.id,
                                      group: widget.group,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.settings_outlined),
                            ),
                            Text(
                              "ตั้งค่ากลุ่ม",
                              style: TextStyle(fontSize: 8),
                            ),
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddAddminGroupPage(
                                      adminGroupList: widget.group.adminList,
                                      group: widget.group,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.person_add_alt_1_sharp),
                            ),
                            Text(
                              "เพิ่มแอดมิน",
                              style: TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Checkbox(
                        value: _select,
                        onChanged: (val) {
                          setState(() {
                            if (_select) {
                              _select = false;
                            } else {
                              _select = true;
                              _file = null;
                            }
                          });
                        }),
                    Text(
                      "ข้อความ",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  maxLines: null,
                  enabled: _select,
                  controller: _controller,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff292929),
                        width: 0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff292929),
                        width: 0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Checkbox(
                      value: !_select,
                      onChanged: (val) {
                        setState(() {
                          if (_select) {
                            _select = false;
                            _file = null;
                          } else {
                            _select = true;
                          }
                        });
                      },
                    ),
                    Text(
                      "รูปภาพ",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              _file == null
                  ? Container(
                      child: RaisedButton(
                        onPressed: !_select
                            ? () {
                                _getImage();
                              }
                            : null,
                        child: Text('Select Image'),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        _getImage();
                      },
                      child: Image.file(
                        _file,
                        width: 250,
                        height: 250,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
