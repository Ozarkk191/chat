import 'package:chat/src/screen/gallery/show_image_page.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  final List<ChatMessage> message;

  const GalleryPage({Key key, this.message}) : super(key: key);
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<String> _imageList = List<String>();
  @override
  void initState() {
    getImage();
    super.initState();
  }

  getImage() async {
    for (var i = 0; i < widget.message.length; i++) {
      if (widget.message[i].image != null) {
        _imageList.add(widget.message[i].image);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("รูปภาพทั้งหมด"),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_outlined),
        ),
      ),
      body: _imageList.length != 0
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  shrinkWrap: true,
                  children: List.generate(
                    _imageList.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowImagePage(
                                imageUrl: _imageList[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(_imageList[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                "ไม่มีรูปภาพ",
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}
