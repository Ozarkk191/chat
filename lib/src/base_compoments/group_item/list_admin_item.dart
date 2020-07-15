import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListAdminItem extends StatelessWidget {
  final String profileUrl, adminName;
  final Function callback;
  final bool status;

  const ListAdminItem({
    Key key,
    @required this.profileUrl,
    @required this.adminName,
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
                  '$adminName',
                  style: TextStyle(color: Colors.grey),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/ic_status_online.png',
                      color: !status ? Colors.grey : null,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      status ? 'online' : 'offline',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
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
