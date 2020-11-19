import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final double width;
  final double height;
  final double elevation;
  final String profileUrl;

  const ProfileCard({
    Key key,
    this.width = 100,
    this.height = 100,
    @required this.profileUrl,
    this.elevation = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
      ),
      child: Container(
        width: width,
        height: height,
        child: CachedNetworkImage(
          imageUrl: profileUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
