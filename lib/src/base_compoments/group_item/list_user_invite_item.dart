import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListUserInviteItem extends StatelessWidget {
  final String profileUrl, userName;
  final Function(bool) onChanged;

  const ListUserInviteItem({
    Key key,
    @required this.profileUrl,
    @required this.userName,
    @required this.onChanged,
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
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Checkbox(value: true, onChanged: onChanged)
        ],
      ),
    );
  }
}
