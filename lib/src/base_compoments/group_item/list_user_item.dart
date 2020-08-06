import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListUserItem extends StatelessWidget {
  final String profileUrl, userName;
  final Function callback;
  final bool banned;

  const ListUserItem({
    Key key,
    @required this.profileUrl,
    @required this.userName,
    @required this.callback,
    this.banned = false,
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
            child: Text(
              '$userName',
              style: TextStyle(color: banned ? Colors.red : Colors.grey),
            ),
          ),
          InkWell(
            onTap: callback,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
