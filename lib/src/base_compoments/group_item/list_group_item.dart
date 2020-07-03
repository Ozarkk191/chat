import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListGroupItem extends StatelessWidget {
  final String imgCoverUrl;
  final String imgGroupUrl;
  final String nameGroup;
  final String numberUser;

  const ListGroupItem({
    Key key,
    @required this.imgCoverUrl,
    @required this.imgGroupUrl,
    @required this.nameGroup,
    @required this.numberUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 160,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        color: Color(0xff616161),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: 80,
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
                height: 50,
                margin: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '$nameGroup',
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset('assets/images/ic_user.png'),
                        Expanded(
                          child: Text(
                            '$numberUser',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        Image.asset('assets/images/ic_globe.png'),
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
