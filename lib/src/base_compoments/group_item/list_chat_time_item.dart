import 'package:badges/badges.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListChatItem extends StatelessWidget {
  final String profileUrl, name, time, lastText;

  const ListChatItem({
    Key key,
    @required this.profileUrl,
    @required this.name,
    @required this.time,
    @required this.lastText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      height: 60,
      child: Row(
        children: <Widget>[
          ProfileCard(width: 50, height: 50, profileUrl: profileUrl),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$name',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '$lastText',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  '$time',
                  style: TextStyle(color: Colors.grey),
                ),
                Badge(
                  badgeColor: Color(0xff00CB00),
                  shape: BadgeShape.circle,
                  borderRadius: 10,
                  toAnimate: false,
                  badgeContent: Text('1',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
