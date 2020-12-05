import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  final String photo;
  final VoidCallback onTap;
  final String tag;
  const PhotoHero({Key key, this.photo, this.onTap, this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 300,
      height: 300,
      child: Hero(
        tag: tag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              onTap: onTap,
              child: Image.network(
                photo,
                fit: BoxFit.contain,
              )),
        ),
      ),
    );
  }
}
