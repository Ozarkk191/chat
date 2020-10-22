import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ConfirmImage extends StatefulWidget {
  @override
  _ConfirmImageState createState() => _ConfirmImageState();
}

class _ConfirmImageState extends State<ConfirmImage> {
  File _image;
  final picker = ImagePicker();
  String url;
  bool _overlay = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Navigator.pop(context);
      }
    });
  }

  void _upLoadPic(File image) async {
    setState(() {
      _overlay = true;
    });
    var now = new DateTime.now();
    var now2 = now.toString().replaceAll(" ", "_");

    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(now2);

    StorageUploadTask uploadTask = storageRef.putFile(
      image,
      StorageMetadata(
        contentType: 'image/jpg',
      ),
    );
    StorageTaskSnapshot download = await uploadTask.onComplete;
    url = await download.ref.getDownloadURL();
    Navigator.pop(context, url);
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingOverlay(
        isLoading: _overlay,
        child: Scaffold(
          backgroundColor: Color(0xff292929),
          appBar: AppBar(
            backgroundColor: Color(0xff202020),
            centerTitle: true,
            title: Text("ยืนยัน"),
            leading: InkWell(
              onTap: () {
                setState(() {
                  _overlay = false;
                });
                Navigator.pop(context);
              },
              child: Container(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  _upLoadPic(_image);
                },
                child: Container(
                  width: 50,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 80,
              child: _image != null ? Image.file(_image) : Container(),
            ),
          ),
        ),
      ),
    );
  }
}
