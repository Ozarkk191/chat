import 'package:chat/src/screen/gallery/show_image_page.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  final List<String> image;

  const GalleryPage({Key key, this.image}) : super(key: key);
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  void initState() {
    super.initState();
  }

  // getImage() async {
  //   for (var i = 0; i < widget.image.length; i++) {
  //     if (widget.image[i].image != null) {
  //       _imageList.add(widget.image[i].image);
  //     }
  //   }
  // }

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
      // body: widget.image.length != 0 ?
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          shrinkWrap: true,
          children: List.generate(
            widget.image.length,
            (index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowImagePage(
                        imageUrl: widget.image[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.image[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      // : Center(
      //     child: Text(
      //       "ไม่มีรูปภาพ",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
    );
  }
}
