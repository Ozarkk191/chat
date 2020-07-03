import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final Function callBack;

  const GradientButton({Key key, @required this.title, @required this.callBack})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: 45,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xff9B9B9B)),
        borderRadius: new BorderRadius.all(Radius.circular(25.0)),
        gradient: RadialGradient(
          colors: <Color>[const Color(0xff676767), const Color(0xFF343434)],
          focalRadius: 10,
          radius: 2,
          stops: [0.4, 1.0],
        ),
      ),
      child: FlatButton(
        child: Center(
          child: Text(
            "$title",
            style: TextStyle(color: Colors.white),
          ),
        ),
        onPressed: callBack,
      ),
    );
  }
}
