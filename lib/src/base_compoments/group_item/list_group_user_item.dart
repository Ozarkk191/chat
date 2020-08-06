import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListGroupUserItem extends StatelessWidget {
  final String imgCoverUrl;
  final String imgGroupUrl;
  final String nameGroup;
  final String numberUser;
  final String status;

  const ListGroupUserItem({
    Key key,
    @required this.imgCoverUrl,
    @required this.imgGroupUrl,
    @required this.nameGroup,
    @required this.numberUser,
    this.status = "public",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 160,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Color(0xff292929),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 110,
              width: MediaQuery.of(context).size.width,
              child: CachedNetworkImage(
                imageUrl: imgCoverUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.topCenter,
              child: ProfileCard(
                width: 80,
                height: 80,
                profileUrl: imgGroupUrl,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 35,
                margin: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset('assets/images/ic_user.png'),
                            Text(
                              '$numberUser',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                        Text(
                          '$nameGroup',
                          style: TextStyle(color: Colors.white),
                        ),
                        status == "public"
                            ? Image.asset(
                                'assets/images/ic_globe.png',
                                width: 20,
                                height: 20,
                                color: Colors.white,
                              )
                            : Image.asset(
                                'assets/images/ic_peple.png',
                                color: Colors.white,
                                width: 20,
                                height: 20,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
