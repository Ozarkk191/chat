import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/app_strings/type_status.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/src/base_compoments/group_item/list_chat_time_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/broadcast/broadcast_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Firestore _databaseReference = Firestore.instance;

  List<GroupModel> _groupList = List<GroupModel>();
  List<GroupModel> _itemList = List<GroupModel>();
  // var items = List<ChatModel>();
  // List<ShowListItem> _listItem = List<ShowListItem>();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _getGroupID() async {
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        _getGroup(value.documentID);
      });
    });
  }

  void _getGroup(String id) async {
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(id)
        .get()
        .then((value) {
      GroupModel group = GroupModel.fromJson(value.data);
      _groupList.add(group);
      _itemList.add(group);
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  void _filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<GroupModel> dummyListData = List<GroupModel>();
      _groupList.forEach((item) {
        if (item.nameGroup.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      if (this.mounted) {
        setState(() {
          _itemList.clear();
          _itemList.addAll(dummyListData);
        });
      }
      return;
    } else {
      if (this.mounted) {
        setState(() {
          _itemList.clear();
          _itemList.addAll(_groupList);
        });
      }
    }
  }

  @override
  void initState() {
    _itemList.clear();
    _getGroupID();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff202020),
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.black,
        title: AppModel.user.roles == "${TypeStatus.USER}"
            ? Text('แชทกับแอดมิน')
            : Text('แชทกับลูกค้า'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              SearchField(
                onChanged: (val) {
                  setState(() {
                    _filterSearchResults(val);
                  });
                },
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Broadcast(
                              group: _itemList[index],
                              uidList: _itemList[index].memberUIDList,
                            ),
                          ),
                        );
                      },
                      child: ListChatItem(
                        profileUrl: _itemList[index].avatarGroup,
                        lastText: "คลิกเพื่อไปยังหน้าบอร์ดแคส",
                        name: _itemList[index].nameGroup,
                        time: "",
                      ),
                    );
                  },
                  itemCount: _itemList.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
