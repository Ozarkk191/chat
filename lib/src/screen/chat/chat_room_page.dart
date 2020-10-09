import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/request_body_parameters.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/repositories/post_repository.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:chat/src/screen/navigator/user_nav_bottom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomPage extends StatefulWidget {
  final String uid;
  final String keyRoom;

  const ChatRoomPage({Key key, this.uid, this.keyRoom}) : super(key: key);
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  Firestore _databaseReference = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  UserModel userModel;
  String _token;

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
    log(token);
    var parameter = SendNotiParameters(
      title: AppModel.user.displayName,
      body: text == "" ? "คุณได้รับรูปภาพ" : "คุณได้รับข้อความ",
      data: "${widget.keyRoom}&&${AppModel.user.uid}&&room",
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

  void onSend(ChatMessage message) {
    var documentReference = Firestore.instance
        .collection('Rooms')
        .document('chats')
        .collection('ChatRoom')
        .document(widget.keyRoom)
        .collection('messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
    _sendNotification(message.text, _token);
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserNavBottom(
                    currentIndex: 2,
                  ),
                ),
              );
            } else {
              AppBool.chatChange = true;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TestNav(
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
                .collection('ChatRoom')
                .document(widget.keyRoom)
                .collection('messages')
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
                  scrollToBottom: false,
                  // onPressAvatar: (ChatUser user) {
                  //   print("OnPressAvatar: ${user.name}");
                  // },
                  // onLongPressAvatar: (ChatUser user) {
                  //   print("OnLongPressAvatar: ${user.name}");
                  // },
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
                      onPressed: () async {
                        final result = await picker.getImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                          maxHeight: 400,
                          maxWidth: 400,
                        );

                        if (result != null) {
                          log("${result.path}");
                          var now = new DateTime.now();
                          var now2 = now.toString().replaceAll(" ", "_");

                          final StorageReference storageRef =
                              FirebaseStorage.instance.ref().child(now2);

                          StorageUploadTask uploadTask = storageRef.putFile(
                            File(result.path),
                            StorageMetadata(
                              contentType: 'image/jpg',
                            ),
                          );
                          StorageTaskSnapshot download =
                              await uploadTask.onComplete;

                          String url = await download.ref.getDownloadURL();

                          ChatMessage message =
                              ChatMessage(text: "", user: user, image: url);
                          _sendNotification(message.text, _token);

                          var documentReference = Firestore.instance
                              .collection('Rooms')
                              .document('chats')
                              .collection('ChatRoom')
                              .document(widget.keyRoom)
                              .collection('messages')
                              .document(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString());

                          Firestore.instance
                              .runTransaction((transaction) async {
                            await transaction.set(
                              documentReference,
                              message.toJson(),
                            );
                          });
                        }
                      },
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
