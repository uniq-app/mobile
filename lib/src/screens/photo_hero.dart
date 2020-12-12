import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  final String photo;
  final BoxFit boxFit;
  final VoidCallback onTap;
  final String tag;
  const PhotoHero({Key key, this.photo, this.onTap, this.tag, this.boxFit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: SizedBox(
        height: 500,
        width: 300,
        child: Hero(
          tag: tag,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: FadeInImage.assetNetwork(
                fadeInDuration: Duration(milliseconds: 300),
                placeholder: 'assets/404.png',
                image: photo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
