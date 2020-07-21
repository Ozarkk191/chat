import 'package:flutter/material.dart';

class TextAndLineEdit extends StatelessWidget {
  final String title;
  final Function callback;

  const TextAndLineEdit({
    Key key,
    @required this.title,
    @required this.callback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(color: Colors.white),
              ),
              InkWell(
                onTap: callback,
                child: Container(
                  width: 60,
                  height: 20,
                  child: Center(
                    child: Text(
                      'เพิ่มแอดมิน',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff202020),
                    border: Border.all(width: 1, color: Color(0xff9B9B9B)),
                    borderRadius: new BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 2),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
