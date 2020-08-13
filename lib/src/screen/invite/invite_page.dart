import 'dart:async';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/list_user_invite_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class InvitePage extends StatefulWidget {
  final List<UserModel> user;

  const InvitePage({Key key, this.user}) : super(key: key);
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  List<bool> _boolList = List<bool>();
  String _link = "XXXXXXXXXXXXXXXXXXXXXXXXXXX";

  List<UserModel> _addUserList = List<UserModel>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i <= AppList.userList.length; i++) {
      _boolList.add(false);
    }
    Timer(Duration(milliseconds: 500), () {
      if (AppList.indexList.length != 0) {
        for (int i = 0; i <= AppList.indexList.length; i++) {
          _boolList[AppList.indexList[i]] = true;
          setState(() {});
        }
      }
    });
  }

  void _addUser() {
    AppList.indexList.clear();
    for (int i = 0; i < _boolList.length; i++) {
      if (_boolList[i]) {
        UserModel data = AppList.userList[i];
        data.uid = AppList.allUidList[i];
        AppList.indexList.add(i);
        _addUserList.add(data);
      }
    }
    Navigator.pop(context, _addUserList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('เชิญ'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
          onTap: () {
            if (widget.user != null) {
              Navigator.pop(context, widget.user);
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        actions: <Widget>[
          InkWell(
            onTap: _addUser,
            child: Container(
              width: 70,
              child: Center(
                child: Text('ตกลง'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                boxQRandLink(
                  'assets/images/ic_qr_code.png',
                  'QR Code',
                  () {
                    _qrCodeBottomSheet(context, _link);
                  },
                ),
                boxQRandLink(
                  'assets/images/ic_link.png',
                  ' Link',
                  () {
                    _linkBottomSheet(context, _link);
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            SearchField(),
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return ListUserInviteItem(
                    index: index,
                    profileUrl: AppList.userList[index].avatarUrl,
                    value: _boolList[index],
                    onChanged: (val) {
                      setState(() {
                        // log("$index");
                        _boolList[index] = val;
                        // if(_boolList[index]){
                        //     _intdexList[index] .add(index);
                        // }
                      });
                    },
                    userName: AppList.userList[index].displayName,
                  );
                },
                itemCount: AppList.userList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell boxQRandLink(String pathImage, String boxTitle, Function callback) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Color(0xff404040),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(pathImage),
            SizedBox(
              height: 10,
            ),
            Text(
              '$boxTitle',
              style: TextStyle(color: Colors.white, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}

void _qrCodeBottomSheet(context, String link) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        height: 250,
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                width: 150,
                height: 150,
                child: QrImage(
                  data: "$link",
                  version: QrVersions.auto,
                  size: 200.0,
                  gapless: false,
                  embeddedImage: AssetImage('assets/images/logo.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(40, 50),
                  ),
                  errorStateBuilder: (cxt, err) {
                    return Container(
                      child: Center(
                        child: Text(
                          "Uh oh! Something went wrong...",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'ชวนเพื่อนใช้แอพฯ ได้ด้วยการสแกนคิวอาร์โค้ด',
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                // padding: EdgeInsets.fromLTRB(0, 0.5, 0, 0.5),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                height: 40,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Text('บันทึกลงเครื่อง'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'แชร์',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _linkBottomSheet(context, String link) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        height: 200,
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Link',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 40,
                      padding: EdgeInsets.all(1),
                      color: Colors.black,
                      child: Container(
                        color: Colors.white,
                        child: Center(
                          child: Text("$link"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'ชวนเพื่อนใช้แอพฯ ได้ด้วยการแชร์ลิงค์',
                      style: TextStyle(fontSize: 8),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                height: 40,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: link));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              'คัดลอกลิงค์',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          final RenderBox box = context.findRenderObject();
                          Share.share("$link",
                              subject: "subject",
                              sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) & box.size);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          color: Colors.white,
                          child: Center(
                            child: Text('แชร์'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
