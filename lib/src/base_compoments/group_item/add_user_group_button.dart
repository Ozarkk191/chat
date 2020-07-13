import 'package:flutter/material.dart';

class AddUserGroupButton extends StatelessWidget {
  final String title;
  final Function onTop;

  const AddUserGroupButton({
    Key key,
    @required this.title,
    @required this.onTop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTop,
      child: Container(
        width: 60,
        height: 80,
        child: Column(
          children: <Widget>[
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: Container(
                width: 60,
                height: 60,
                color: Colors.white,
                child: Center(
                  child: Icon(Icons.add),
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }
}
