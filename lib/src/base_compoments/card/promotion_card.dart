import 'package:flutter/material.dart';

import 'profile_card.dart';

class PromotionCard extends StatefulWidget {
  final String imageUrlGroup;
  final String imageUrlPromotion;
  final String nameGroup;
  final String status;
  final String description;
  final Function callback;

  const PromotionCard({
    Key key,
    @required this.imageUrlGroup,
    @required this.imageUrlPromotion,
    @required this.nameGroup,
    @required this.status,
    @required this.description,
    @required this.callback,
  }) : super(key: key);

  @override
  _PromotionCardState createState() => _PromotionCardState();
}

class _PromotionCardState extends State<PromotionCard> {
  String _lastTime = "";
  @override
  void initState() {
    super.initState();

    var text = widget.status.split(":");
    var hour = text[0];
    var min = text[1];

    var day1 = int.parse(hour) / 24;
    var day = day1.toInt();
    var week1 = day / 7;
    var week = week1.toInt();

    if (week != 0) {
      _lastTime = " $week สัปดาห์ที่แล้ว";
    } else {
      if (day != 0) {
        _lastTime = " $day วันที่แล้ว";
      } else {
        if (hour == "0") {
          if (min == "00") {
            _lastTime = "ไม่กี่วินาทีที่แล้ว";
          } else {
            if (min.substring(0, 1) == "0") {
              min = min.replaceAll("0", "");
              _lastTime = " $min นาทีที่แล้ว";
            } else {
              _lastTime = " $min นาทีที่แล้ว";
            }
          }
        } else {
          if (hour.substring(0, 1) == "0") {
            hour = hour.replaceAll("0", "");
            _lastTime = " $hour ชั่วโมงที่แล้ว";
          } else {
            _lastTime = " $hour ชั่วโมงที่แล้ว";
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ProfileCard(
                      profileUrl: widget.imageUrlGroup,
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.nameGroup,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "โพสต์เมื่อ$_lastTime",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      child: RaisedButton(
                        onPressed: widget.callback,
                        color: Colors.black,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              size: 12,
                              color: Colors.white,
                            ),
                            Text(
                              'เข้ากลุ่ม',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.grey,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  widget.description,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              widget.imageUrlPromotion != null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Image.network(
                        widget.imageUrlPromotion,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
