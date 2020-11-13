import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/request_body_parameters.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/repositories/post_repository.dart';
import 'package:chat/src/screen/confirm_image/confirm_image.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:chat/src/screen/navigator/user_nav_bottom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:page_transition/page_transition.dart';

class GroupRoomPage extends StatefulWidget {
  final String uid;
  final String groupName;

  const GroupRoomPage({Key key, this.uid, this.groupName}) : super(key: key);
  @override
  _GroupRoomPageState createState() => _GroupRoomPageState();
}

class _GroupRoomPageState extends State<GroupRoomPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  Firestore _databaseReference = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  UserModel userModel;
  String _token;
  List<Asset> images = List<Asset>();
  List<File> files = List<File>();
  // File _file;

  final ChatUser user = ChatUser(
    name: AppModel.user.firstName,
    uid: AppModel.user.uid,
    avatar: AppModel.user.avatarUrl,
  );

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  var i = 0;

  @override
  void initState() {
    super.initState();
    _admin();
  }

  _admin() async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      AppModel.user.uid = user.uid;
      await _databaseReference
          .collection('Users')
          .document(widget.uid)
          .get()
          .then((value) {
        userModel = UserModel.fromJson(value.data);
        _token = userModel.notiToken;
        setState(() {});
      });
    }
  }

  void _sendNotification(String text, String token) async {
    var parameter = SendNotiParameters(
      title: AppModel.user.displayName,
      body: text == "" ? "คุณได้รับรูปภาพ" : "คุณได้รับข้อความ",
      data: "${widget.groupName}_${widget.uid}&&${AppModel.user.uid}&&room",
      token: token,
    );
    var response = await PostRepository().sendNotification(parameter);
    log(response['message']);
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 0), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 0), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 0),
          );
      });
    });
  }

  // void onRemove(String keyMSG) {
  //   var documentReference = Firestore.instance
  //       .collection('Rooms')
  //       .document('chats')
  //       .collection('ChatRoom')
  //       .document(widget.keyRoom)
  //       .collection('messages')
  //       .document(keyMSG);

  //   Firestore.instance.runTransaction((transaction) async {
  //     await transaction.delete(
  //       documentReference,
  //     );
  //   });
  //   Navigator.pop(context);
  // }

  void onSend(ChatMessage message) {
    var documentReference = Firestore.instance
        .collection('Rooms')
        .document('chats')
        .collection('Group')
        .document(widget.groupName)
        .collection(widget.uid)
        .document(message.createdAt.millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
    _sendNotification(message.text, _token);
  }

  // Future<File> getImageFileFromAsset(String path) async {
  //   final file = File(path);
  //   return file;
  // }

  void _upLoadPic(String url) async {
    ChatMessage message = ChatMessage(text: "", user: user, image: url);
    _sendNotification(message.text, _token);

    var documentReference = Firestore.instance
        .collection('Rooms')
        .document('chats')
        .collection('Group')
        .document(widget.groupName)
        .collection(widget.uid)
        .document(message.createdAt.millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

  void _goToSecondScreen() async {
    var result = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (BuildContext context) => ConfirmImage(),
        fullscreenDialog: true,
      ),
    );
    if (result != null) {
      _upLoadPic("$result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        backgroundColor: Color(0xff202020),
        title: AppModel.user.roles == "${TypeStatus.USER}"
            ? Text(userModel != null ? 'แอดมิน ${userModel.firstName}' : "")
            : Text(userModel != null ? "${userModel.firstName}" : ""),
        leading: InkWell(
          onTap: () {
            if (AppModel.user.roles == TypeStatus.USER.toString()) {
              AppBool.chatChange = true;
              AppBool.homeUserChange = true;
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: UserNavBottom(
                    currentIndex: 2,
                  ),
                ),
              );
            } else {
              AppBool.chatChange = true;
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: TestNav(
                    currentIndex: 2,
                  ),
                ),
              );
            }
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('Rooms')
                .document('chats')
                .collection('Group')
                .document(widget.groupName)
                .collection(widget.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                );
              } else {
                List<DocumentSnapshot> items = snapshot.data.documents;
                var messages =
                    items.map((i) => ChatMessage.fromJson(i.data)).toList();
                return DashChat(
                  key: _chatViewKey,
                  inverted: false,
                  onSend: onSend,
                  user: user,
                  inputDecoration:
                      InputDecoration.collapsed(hintText: "ข้อความ"),
                  dateFormat: DateFormat('yyyy-MMM-dd'),
                  timeFormat: DateFormat('HH:mm'),
                  messages: messages,
                  showUserAvatar: false,
                  showAvatarForEveryMessage: false,
                  scrollToBottom: true,
                  onLongPressMessage: (ChatMessage chatMessage) {
                    // _dialogShow(
                    //     title: "แจ้งเตือน",
                    //     content: "คุณต้องการลบข้อความใช่หรือไม่");
                    // Toast.show(
                    //     chatMessage.createdAt.millisecondsSinceEpoch.toString(),
                    //     context,
                    //     duration: Toast.LENGTH_SHORT,
                    //     gravity: Toast.BOTTOM);
                  },
                  inputMaxLines: 5,
                  messageContainerPadding:
                      EdgeInsets.only(left: 5.0, right: 5.0),
                  alwaysShowSend: true,
                  inputTextStyle: TextStyle(fontSize: 16.0),
                  inputContainerStyle: BoxDecoration(
                    border: Border.all(width: 0.0),
                    color: Colors.white,
                  ),
                  onLoadEarlier: () {
                    // print("laoding...");
                  },
                  shouldShowLoadEarlier: false,
                  showTraillingBeforeSend: true,
                  trailing: <Widget>[
                    IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: _goToSecondScreen,
                      //loadAssets,
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
