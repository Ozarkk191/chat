import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/models/request_body_parameters.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/repositories/post_repository.dart';
import 'package:chat/src/screen/group/setting_group/setting_group_page.dart';
import 'package:chat/src/screen/invite/invite_page.dart';
import 'package:chat/src/screen/member/all_member_page.dart';
import 'package:chat/src/screen/post/post_news_group_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatGroupPage extends StatefulWidget {
  final String groupName;

  const ChatGroupPage({Key key, @required this.groupName}) : super(key: key);
  @override
  _ChatGroupPageState createState() => _ChatGroupPageState();
}

class _ChatGroupPageState extends State<ChatGroupPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final picker = ImagePicker();
  Firestore _databaseReference = Firestore.instance;
  List<UserModel> _memberList = List<UserModel>();
  List<String> _tokenList = List<String>();

  final ChatUser user = ChatUser(
    name: AppModel.user.firstName,
    uid: AppModel.user.uid,
    avatar: AppModel.user.avatarUrl,
  );

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  var i = 0;

  void _getMemberUID() async {
    await _databaseReference
        .collection('Rooms')
        .document('chats')
        .collection('Group')
        .document(AppString.uidRoomChat)
        .get()
        .then((value) {
      var member = GroupModel.fromJson(value.data);
      _getMember(member.memberUIDList);
    });
  }

  void _getMember(List<dynamic> list) {
    if (list.length != 0) {
      for (int i = 0; i < list.length; i++) {
        _databaseReference
            .collection('Users')
            .document(list[i].toString())
            .get()
            .then((value) {
          var member = UserModel.fromJson(value.data);
          _memberList.add(member);
          _tokenList.add(member.notiToken);
          setState(() {});
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getMemberUID();
    // _getMemer();
  }

  void _sendNotification(String text, String token) async {
    var parameter = SendNotiParameters(
      title: widget.groupName,
      body: "คุณได้รับข้อความ",
      data: text,
      token: token,
    );
    var response = await PostRepository().sendNotification(parameter);
    log(response['message'].toString());
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
        .collection('Group')
        .document(AppString.uidRoomChat)
        .collection('messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
    for (var i = 0; i < _tokenList.length; i++) {
      _sendNotification(message.text, _tokenList[i]);
    }
  }

  // void _getMemer() async {
  //   Firestore.instance
  //       .collection('Rooms')
  //       .document('chats')
  //       .collection('Group')
  //       .document(AppString.uidRoomChat)
  //       .get()
  //       .then((value) {
  //     var group = GroupModel.fromJson(value.data);
  //     var member = group.memberUIDList;
  //     for (var i = 0; i < member.length; i++) {
  //       _getNotiToken(member[i]);
  //     }
  //   });
  // }

  // void _getNotiToken(uid) async {
  //   await Firestore.instance
  //       .collection("Users")
  //       .document(uid)
  //       .get()
  //       .then((value) {
  //     var user = UserModel.fromJson(value.data);
  //     _tokenList.add(user.notiToken);
  //   });
  // }

  void _saveRead(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppString.uidRoomChat, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
              color: Color(0xff202020),
              onSelected: (value) {
                _selecteMenu(value, context);
              },
              itemBuilder: (BuildContext context) {
                return AppModel.user.roles == "${TypeStatus.USER}"
                    ? MenuSettings.menuList.map((String menu) {
                        return PopupMenuItem<String>(
                          value: menu,
                          child: Text(
                            menu,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList()
                    : MenuSettings.menuList2.map((String menu) {
                        return PopupMenuItem<String>(
                          value: menu,
                          child: Text(
                            menu,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList();
              }),
        ],
        backgroundColor: Color(0xff202020),
        title: Text(widget.groupName),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('Rooms')
              .document('chats')
              .collection('Group')
              .document(AppString.uidRoomChat)
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
              _saveRead(messages[messages.length - 1].createdAt.toString());
              return DashChat(
                key: _chatViewKey,
                inverted: false,
                onSend: onSend,
                user: user,
                inputDecoration: InputDecoration.collapsed(hintText: "ข้อความ"),
                dateFormat: DateFormat('yyyy-MMM-dd'),
                timeFormat: DateFormat('HH:mm'),
                messages: messages,
                showUserAvatar: false,
                showAvatarForEveryMessage: false,
                scrollToBottom: false,
                readOnly:
                    AppString.roles == '${TypeStatus.USER}' ? true : false,
                onPressAvatar: (ChatUser user) {
                  print("OnPressAvatar: ${user.name}");
                },
                onLongPressAvatar: (ChatUser user) {
                  print("OnLongPressAvatar: ${user.name}");
                },
                inputMaxLines: 5,
                messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                alwaysShowSend: true,
                inputTextStyle: TextStyle(fontSize: 16.0),
                inputContainerStyle: BoxDecoration(
                  border: Border.all(width: 0.0),
                  color: Colors.white,
                ),
                onLoadEarlier: () {
                  print("laoding...");
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

                        var documentReference = Firestore.instance
                            .collection('Rooms')
                            .document('chats')
                            .collection('Group')
                            .document(AppString.uidRoomChat)
                            .collection('messages')
                            .document(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString());

                        Firestore.instance.runTransaction((transaction) async {
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
    );
  }

  void _selecteMenu(String menu, BuildContext context) {
    if (menu == MenuSettings.invite) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InvitePage()));
    } else if (menu == MenuSettings.member) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllMemberPage(
            memberList: _memberList,
          ),
        ),
      );
    } else if (menu == MenuSettings.settingGroup) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SettingGroupPage(
            memberList: _memberList,
            groupName: widget.groupName,
          ),
        ),
      );
    } else if (menu == MenuSettings.post) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostNewsGroupPage(),
        ),
      );
    }
  }
}
