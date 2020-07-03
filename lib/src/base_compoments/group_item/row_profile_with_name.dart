import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class RowProfileWithName extends StatelessWidget {
  final String profileUrl, displayName;

  const RowProfileWithName({
    Key key,
    @required this.profileUrl,
    @required this.displayName,
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
              '$displayName',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
