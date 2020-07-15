import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:flutter/material.dart';

class ListAdminItem extends StatefulWidget {
  final String profileUrl, adminName;
  final Function callback;
  final bool status;
  final String lastTime;

  const ListAdminItem({
    Key key,
    @required this.profileUrl,
    @required this.adminName,
    @required this.callback,
    @required this.status,
    @required this.lastTime,
  }) : super(key: key);

  @override
  _ListAdminItemState createState() => _ListAdminItemState();
}

class _ListAdminItemState extends State<ListAdminItem> {
  String _lastTime = "";
  @override
  void initState() {
    super.initState();
    var text = widget.lastTime.split(":");
    var hour = text[0];
    var min = text[1];

    if (hour == "0") {
      if (min == "0") {
        _lastTime = "ไม่กี่วินาทีที่แล้ว";
      } else {
        if (min.substring(0, 1) == "0") {
          min = min.replaceAll("0", "");
          _lastTime = "$min นาทีที่แล้ว";
        } else {
          _lastTime = "$min นาทีที่แล้ว";
        }
      }
    } else {
      if (hour.substring(0, 1) == "0") {
        hour = hour.replaceAll("0", "");
        _lastTime = "$hour ชั่วโมงที่แล้ว";
      } else {
        _lastTime = "$hour ชั่วโมงที่แล้ว";
      }
    }
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${widget.adminName}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/ic_status_online.png',
                      color: !widget.status ? Colors.grey : null,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.status ? 'online' : 'ใช้งานล่าสุดเมื่อ $_lastTime',
                      style: TextStyle(color: Colors.grey, fontSize: 8),
                    ),
                  ],
                )
              ],
            ),
          ),
          InkWell(
            onTap: widget.callback,
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
