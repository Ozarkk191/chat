import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListWaittingItem extends StatelessWidget {
  final String profileUrl, name, groupName;

  const ListWaittingItem({
    Key key,
    @required this.profileUrl,
    @required this.name,
    @required this.groupName,
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
                  '$groupName',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/ic_cancel.png'),
          SizedBox(
            width: 20,
          ),
          Image.asset('assets/images/ic_confirm.png'),
        ],
      ),
    );
  }
}
