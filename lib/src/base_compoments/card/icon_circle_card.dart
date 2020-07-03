import 'package:flutter/material.dart';

class IconCircleCard extends StatelessWidget {
  final double width;
  final double height;
  final String iconPath;

  const IconCircleCard({
    Key key,
    this.width = 20,
    this.height = 20,
    @required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Container(
        width: width,
        height: height,
        child: Image.asset(iconPath),
      ),
    );
  }
}
