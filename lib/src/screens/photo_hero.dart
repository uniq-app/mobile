import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  final String photo;
  final VoidCallback onTap;
  final String tag;
  final bool isRounded;

  const PhotoHero(
      {Key key, this.photo, this.onTap, this.tag, this.isRounded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: isRounded
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
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
                    ),
                  ),
                ),
              ),
            )
          : Hero(
              tag: tag,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: FadeInImage.assetNetwork(
                    fadeInDuration: Duration(milliseconds: 300),
                    placeholder: 'assets/404.png',
                    image: photo,
                  ),
                ),
              ),
            ),
    );
  }
}
