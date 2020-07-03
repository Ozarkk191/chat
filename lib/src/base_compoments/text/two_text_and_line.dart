import 'package:flutter/material.dart';

class TwoTextAndLine extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String data;
  final Function onTap;

  TwoTextAndLine({
    @required this.context,
    @required this.title,
    this.data = "",
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '$title',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  '$data',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
