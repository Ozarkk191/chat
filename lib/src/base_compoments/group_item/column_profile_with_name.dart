import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ColumnProFileWithName extends StatelessWidget {
  final String profileUrl;
  final String displayName;

  const ColumnProFileWithName({
    Key key,
    @required this.profileUrl,
    @required this.displayName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 80,
      child: Column(
        children: <Widget>[
          ProfileCard(
            profileUrl: profileUrl,
            width: 60,
            height: 60,
          ),
          Text(
            displayName,
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
        ],
      ),
    );
  }
}
