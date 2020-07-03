import 'package:flutter/material.dart';

class UserDialog extends StatelessWidget {
  final String title1, title2;
  final String pathIcon1, pathIcon2;
  final String coverUrl, profileUrl, username;
  final Function callbackItem1, callbackItem2;

  const UserDialog({
    Key key,
    @required this.title1,
    @required this.title2,
    @required this.pathIcon1,
    @required this.pathIcon2,
    @required this.callbackItem1,
    @required this.callbackItem2,
    @required this.coverUrl,
    @required this.profileUrl,
    @required this.username,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: 280,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Stack(
          children: <Widget>[
            imgCover(context, coverUrl),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 120,
                    height: 120,
                    child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Image.network(
                        profileUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text('$username'),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  actionButton('$title1', pathIcon1, callbackItem1),
                  actionButton('$title2', pathIcon2, callbackItem2),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Image.asset('assets/images/ic_close.png'),
                ),
              ),
            )
          ],
        ),
      );

  Widget actionButton(
    String title,
    String path,
    Function callback,
  ) {
    return InkWell(
      onTap: callback,
      child: Container(
        height: 50,
        width: 80,
        child: Column(
          children: <Widget>[
            Image.asset('$path'),
            Text(
              '$title',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Container imgCover(BuildContext context, String coverUrl) {
    return Container(
      height: 125,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(0),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Image.network(
          coverUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
