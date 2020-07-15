import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoverDialog extends StatelessWidget {
  final String coverUrl;

  const CoverDialog({Key key, @required this.coverUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: coverUrl,
        ),
      ),
    );
  }
}
