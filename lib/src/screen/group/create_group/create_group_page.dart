import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AppBar(
              backgroundColor: Color(0xff202020),
            )
          ],
        ),
      ),
    );
  }
}
