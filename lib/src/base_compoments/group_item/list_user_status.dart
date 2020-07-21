import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListUserWithStatus extends StatelessWidget {
  final String profileUrl, userName, status;
  final Function callback;

  const ListUserWithStatus({
    Key key,
    @required this.profileUrl,
    @required this.userName,
    @required this.callback,
    @required this.status,
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
                  '$userName',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '$status',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
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
