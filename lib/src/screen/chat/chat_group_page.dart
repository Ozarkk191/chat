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
import 'package:chat/src/screen/invite/invite_with_link.dart';
import 'package:chat/src/screen/member/all_member_page.dart';
import 'package:chat/src/screen/navigator/text_nav.dart';
import 'package:chat/src/screen/navigator/user_nav_bottom.dart';
import 'package:chat/src/screen/post/post_news_group_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatGroupPage extends StatefulWidget {
  final String groupName;
  final String groupID;
  final String id;

  const ChatGroupPage(
      {Key key,
      @required this.groupName,
      @required this.groupID,
      @required this.id})
      : super(key: key);
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
  var member;
  void _getMemberUID() async {
    await _databaseReference
        .collection('Rooms')
        .document('chats')
        .collection('Group')
        .document(widget.groupID)
        .get()
        .then((value) {
      member = GroupModel.fromJson(value.data);
    }).then((value) {
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
          if (member.uid != AppModel.user.uid) {
            _tokenList.add(member.notiToken);
          }
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
      body: text == "" ? "คุณได้รับรูปภาพ" : "คุณได้รับข้อความ",
      data: "${widget.groupName}&&${widget.groupID}&&group&&${widget.id}",
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
        .collection('Group')
        .document(widget.groupID)
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
        title: Text("${widget.groupName} (id : ${widget.id})"),
        leading: InkWell(
          onTap: () {
            if (AppModel.user.roles == TypeStatus.USER.toString()) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserNavBottom(
                    currentIndex: 1,
                  ),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TestNav(
                    currentIndex: 1,
                  ),
                ),
              );
            }
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('Rooms')
              .document('chats')
              .collection('Group')
              .document(widget.groupID)
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
                scrollToBottom: true,
                readOnly:
                    AppModel.user.roles == '${TypeStatus.USER}' ? true : false,
                inputMaxLines: 5,
                messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
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

                        for (var i = 0; i < _tokenList.length; i++) {
                          _sendNotification(message.text, _tokenList[i]);
                        }
                        var documentReference = Firestore.instance
                            .collection('Rooms')
                            .document('chats')
                            .collection('Group')
                            .document(widget.groupID)
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
        context,
        MaterialPageRoute(
          builder: (context) => InviteWithLink(
            groupID: widget.groupID,
          ),
        ),
      );
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
            groupId: widget.groupID,
            id: widget.id,
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
