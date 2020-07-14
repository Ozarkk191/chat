import 'dart:async';
import 'dart:io';

import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/src/screen/group/setting_group/setting_group_page.dart';
import 'package:chat/src/screen/invite/invite_page.dart';
import 'package:chat/src/screen/member/all_member_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatGroupPage extends StatefulWidget {
  @override
  _ChatGroupPageState createState() => _ChatGroupPageState();
}

class _ChatGroupPageState extends State<ChatGroupPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final picker = ImagePicker();

  final ChatUser user = ChatUser(
    name: AppString.firstname,
    uid: AppString.uid,
    avatar: AppString.photoUrl,
  );

  List<ChatMessage> messages = List<ChatMessage>();
  var m = List<ChatMessage>();

  var i = 0;

  @override
  void initState() {
    super.initState();
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
                return MenuSettings.menuList.map((String menu) {
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
        title: Text(AppString.nameGroup),
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
                onQuickReply: (Reply reply) {
                  setState(() {
                    messages.add(ChatMessage(
                        text: reply.value,
                        createdAt: DateTime.now(),
                        user: user));

                    messages = [...messages];
                  });

                  Timer(Duration(milliseconds: 0), () {
                    _chatViewKey.currentState.scrollController
                      ..animateTo(
                        _chatViewKey.currentState.scrollController.position
                            .maxScrollExtent,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 0),
                      );

                    if (i == 0) {
                      systemMessage();
                      Timer(Duration(milliseconds: 0), () {
                        systemMessage();
                      });
                    } else {
                      systemMessage();
                    }
                  });
                },
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
}

void _selecteMenu(String menu, BuildContext context) {
  if (menu == MenuSettings.invite) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => InvitePage()));
  } else if (menu == MenuSettings.member) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AllMemberPage()));
  } else if (menu == MenuSettings.settingGroup) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingGroupPage()));
  }
}
