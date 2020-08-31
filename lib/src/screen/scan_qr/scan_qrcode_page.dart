import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/src/screen/chat/chat_group_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRcodePage extends StatefulWidget {
  @override
  _ScanQRcodePageState createState() => _ScanQRcodePageState();
}

class _ScanQRcodePageState extends State<ScanQRcodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('Scan'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              color: Colors.white,
              child: Center(
                child: Text('สแกนคิวอาร์โค้ดเพื่อเข้ากลุ่ม'),
              ),
            ),
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Center(
            //     child: Text('Scan result: $qrText'),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        _group(scanData);
      });
    });
  }

  void _group(String text) async {
    var str = text.split("uid=");
    text = str[1];
    List<String> _groupID = List<String>();
    Firestore _databaseReference = Firestore.instance;
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((value) {
        _groupID.add(value.documentID);
      });
    }).then((value) {
      var id = _groupID.where((element) => element == text).toList();
      if (id.length != 0) {
        _getGroup(text);
      }
      setState(() {});
    });
  }

  _getGroup(String groupID) async {
    List<dynamic> _memberList = List<String>();
    Firestore _databaseReference = Firestore.instance;
    await _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(groupID)
        .get()
        .then((value) {
      var group = GroupModel.fromJson(value.data);
      _memberList = group.memberUIDList;

      var member =
          _memberList.where((element) => element == AppModel.user.uid).toList();
      if (member.length == 0) {
        _memberList.add(AppModel.user.uid);
        _databaseReference
            .collection("Rooms")
            .document("chats")
            .collection("Group")
            .document(groupID)
            .updateData({"memberUIDList": _memberList}).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatGroupPage(
                groupName: group.nameGroup,
                groupID: group.groupID,
                id: group.id,
              ),
            ),
          );
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatGroupPage(
              groupName: group.nameGroup,
              groupID: group.groupID,
              id: group.id,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
