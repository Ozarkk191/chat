import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String path;
  final Function callBack;

  const CustomIconButton(
      {Key key, @required this.path, @required this.callBack})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xff9B9B9B)),
        borderRadius: new BorderRadius.all(Radius.circular(25.0)),
        // gradient: RadialGradient(
        //   colors: <Color>[const Color(0xff676767), const Color(0xFF343434)],
        //   focalRadius: 5,
        //   radius: 0.5,
        // ),
      ),
      child: FlatButton(onPressed: callBack, child: Image.asset('$path')),
    );
  }
}
