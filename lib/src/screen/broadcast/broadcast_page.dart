import 'dart:developer';
import 'dart:io';

import 'package:chat/models/group_model.dart';
import 'package:chat/models/request_body_parameters.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/repositories/post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  ChatUser user;
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
        log("${user.notiToken}");
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
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('Broadcast'),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          InkWell(
            onTap: () {
              ChatMessage message;
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
    );
  }
}
