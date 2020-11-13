import 'dart:developer';
import 'dart:io';

import 'package:chat/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Broadcast extends StatefulWidget {
  final List<dynamic> uidList;

  const Broadcast({Key key, this.uidList}) : super(key: key);
  @override
  _BroadcastState createState() => _BroadcastState();
}

class _BroadcastState extends State<Broadcast> {
  bool _select = true;
  File _file;
  final picker = ImagePicker();
  Firestore _databaseReference = Firestore.instance;
  List<String> _tokenList = List<String>();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _getToken() async {
    for (var i = 0; i <= widget.uidList.length; i++) {
      await _databaseReference
          .collection('Users')
          .document(widget.uidList[i])
          .get()
          .then((value) {
        UserModel user = UserModel.fromJson(value.data);
        _tokenList.add(user.notiToken);
        log("${user.notiToken}");
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('Broadcast'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Checkbox(
                      value: _select,
                      onChanged: (val) {
                        setState(() {
                          if (_select) {
                            _select = false;
                          } else {
                            _select = true;
                            _file = null;
                          }
                        });
                      }),
                  Text(
                    "ข้อความ",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                maxLines: null,
                enabled: _select,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff292929),
                      width: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff292929),
                      width: 0,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  Checkbox(
                    value: !_select,
                    onChanged: (val) {
                      setState(() {
                        if (_select) {
                          _select = false;
                          _file = null;
                        } else {
                          _select = true;
                        }
                      });
                    },
                  ),
                  Text(
                    "รูปภาพ",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            _file == null
                ? Container(
                    child: RaisedButton(
                      onPressed: !_select
                          ? () {
                              _getImage();
                            }
                          : null,
                      child: Text('Select Image'),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      _getImage();
                    },
                    child: Image.file(
                      _file,
                      width: 250,
                      height: 250,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
