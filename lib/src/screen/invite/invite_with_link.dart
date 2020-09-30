import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

class InviteWithLink extends StatefulWidget {
  final String groupID;

  const InviteWithLink({Key key, @required this.groupID}) : super(key: key);
  @override
  _InviteWithLinkState createState() => _InviteWithLinkState();
}

class _InviteWithLinkState extends State<InviteWithLink> {
  File _imageFile;
  ScreenshotController screenshotController = ScreenshotController();
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
        actions: [
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: _link));
              Toast.show("คัดลอกลิงค์เรียบร้อย", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            },
            child: Container(
              padding: EdgeInsets.only(right: 5, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.content_copy,
                    color: Colors.white,
                  ),
                  Text(
                    "คัดลอกลิงค์",
                    style: TextStyle(fontSize: 8),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              final RenderBox box = context.findRenderObject();
              Share.share("$_link",
                  subject: "subject",
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
            child: Container(
              padding: EdgeInsets.only(right: 20, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  Text(
                    "แชร์ลิงค์",
                    style: TextStyle(fontSize: 8),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "QR Code ของกลุ่ม",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  boxQRandLink(
                    'แตะเพื่อแชร์ QR Code',
                    () {
                      screenshotController.capture().then((File image) {
                        setState(() {
                          _imageFile = image;
                          Share.shareFiles(['${_imageFile.path}'],
                              text: 'QrCode');
                        });
                      }).catchError((onError) {
                        print(onError);
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  // boxQRandLink(
                  //   'assets/images/ic_link.png',
                  //   ' Link',
                  //   () {
                  //     _linkBottomSheet(context, _link);
                  //   },
                  // ),
                ],
              ),
              SizedBox(height: 10),
              // SearchField(),
            ],
          ),
        ),
      ),
    );
  }

  InkWell boxQRandLink(String boxTitle, Function callback) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 300,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Screenshot(
              controller: screenshotController,
              child: Container(
                width: 250,
                height: 250,
                color: Colors.white,
                child: QrImage(
                  data: "$_link",
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
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '$boxTitle',
              style: TextStyle(color: Colors.black, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }
}
