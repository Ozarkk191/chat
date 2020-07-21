import 'dart:io';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/models/news_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class PostNewsGroupPage extends StatefulWidget {
  @override
  _PostNewsGroupPageState createState() => _PostNewsGroupPageState();
}

class _PostNewsGroupPageState extends State<PostNewsGroupPage> {
  File _image;
  final picker = ImagePicker();
  TextEditingController _title = new TextEditingController();
  String _imageUrl = "";
  bool _loading = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  bool _check() {
    if (_imageUrl == "" && _title.text == "") {
      return false;
    } else {
      return true;
    }
  }

  _post() async {
    setState(() {
      _loading = true;
    });
    if (_image != null) {
      var now = DateTime.now().millisecondsSinceEpoch.toString();
      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child(now);
      StorageUploadTask uploadTask = storageRef.putFile(
        File(_image.path),
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;

      _imageUrl = await download.ref.getDownloadURL();
    }
    var post = NewsModel(
        imageUrl: _imageUrl,
        timePost: DateTime.now().toString(),
        title: _title.text,
        groupUID: AppString.uidRoomChat,
        imageGroup: AppModel.group.avatarGroup,
        nameGroup: AppModel.group.nameGroup);
    final _databaseReference = Firestore.instance;
    _databaseReference
        .collection("Rooms")
        .document("chats")
        .collection("Group")
        .document(AppString.uidRoomChat)
        .collection("News")
        .document()
        .setData(post.toJson())
        .then((_) {
      setState(() {
        _loading = true;
      });
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _loading,
      child: Scaffold(
        backgroundColor: Color(0xff292929),
        appBar: AppBar(
          title: Text("โพสต์ข่าวสาร"),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          actions: <Widget>[
            InkWell(
              onTap: !_check()
                  ? null
                  : () {
                      _post();
                    },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                width: 60,
                height: 50,
                child: Center(
                  child: Text("โพสต์"),
                ),
              ),
            )
          ],
          backgroundColor: Color(0xff202020),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      maxLines: 4,
                      maxLength: 150,
                      controller: _title,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "ใส่หัวข้อข่าวสาร",
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.all(2),
                    color: Colors.white,
                    child: RaisedButton(
                      color: Color(0xff202020),
                      onPressed: () {
                        getImage();
                      },
                      child: Text(
                        "เพิ่มรูปภาพ",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _image != null
                      ? Image.file(
                          _image,
                          height: 300,
                          width: MediaQuery.of(context).size.width - 40,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
