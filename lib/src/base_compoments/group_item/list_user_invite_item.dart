import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListUserInviteItem extends StatefulWidget {
  final String profileUrl, userName;
  final Function(bool) onChanged;
  final bool value;
  final int index;

  const ListUserInviteItem({
    Key key,
    @required this.profileUrl,
    @required this.userName,
    this.onChanged,
    this.value = false,
    @required this.index,
  }) : super(key: key);

  @override
  _ListUserInviteItemState createState() => _ListUserInviteItemState();
}

class _ListUserInviteItemState extends State<ListUserInviteItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      height: 60,
      child: Row(
        children: <Widget>[
          ProfileCard(width: 50, height: 50, profileUrl: widget.profileUrl),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              '${widget.userName}',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Checkbox(value: widget.value, onChanged: widget.onChanged)
        ],
      ),
    );
  }
}
