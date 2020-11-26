import 'package:badges/badges.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListChatItem extends StatelessWidget {
  final String profileUrl, name, time, lastText;
  final String unRead;

  const ListChatItem({
    Key key,
    @required this.profileUrl,
    @required this.name,
    @required this.time,
    @required this.lastText,
    @required this.unRead,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$time',
                  style: TextStyle(color: Colors.grey),
                ),
                unRead != "0"
                    ? Badge(
                        badgeColor: Color(0xff00CB00),
                        shape: BadgeShape.circle,
                        toAnimate: false,
                        badgeContent: Text(unRead,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
