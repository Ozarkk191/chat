import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

class InviteWithLink extends StatefulWidget {
  final String groupID;

  const InviteWithLink({Key key, @required this.groupID}) : super(key: key);
  @override
  _InviteWithLinkState createState() => _InviteWithLinkState();
}

class _InviteWithLinkState extends State<InviteWithLink> {
  String _link = "https://secretchat.store/group?uid=";
  @override
  void initState() {
    _link = "$_link${widget.groupID}";
    super.initState();
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
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
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
                          Toast.show("คัดลอกลิงค์เรียบร้อย", context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.BOTTOM);
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
