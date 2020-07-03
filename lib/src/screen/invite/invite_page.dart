import 'package:chat/src/base_compoments/group_item/list_user_invite_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InvitePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('เชิญ'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        actions: <Widget>[
          InkWell(
            onTap: () {},
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
                    _qrCodeBottomSheet(context);
                  },
                ),
                boxQRandLink(
                  'assets/images/ic_link.png',
                  ' Link',
                  () {
                    _linkBottomSheet(context);
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
                    profileUrl: 'https://wallpapercave.com/wp/w1fkwPh.jpg',
                    onChanged: (bool) {},
                    userName: 'User Name',
                  );
                },
                itemCount: 20,
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

void _qrCodeBottomSheet(context) {
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
                  data: "rrrrr",
                  version: QrVersions.auto,
                  size: 200.0,
                  embeddedImage: AssetImage('assets/images/logo.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(40, 50),
                  ),
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

void _linkBottomSheet(context) {
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
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40,
                    color: Colors.black,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Text('คัดลอกลิงค์'),
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
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
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
                          child: Text("XXXXXXXXXXXXXXXXXXXXXXXXXXX"),
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
            ],
          ),
        ),
      );
    },
  );
}
