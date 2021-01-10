import 'package:flutter/material.dart';
import 'package:uniq/src/shared/components/custom_image_network.dart';

class PhotoHero extends StatelessWidget {
  final String url;
  final Image image;
  final VoidCallback onTap;
  final String tag;
  final bool isRounded;

  PhotoHero(
      {Key key,
      this.url,
      this.image,
      this.onTap,
      this.tag,
      this.isRounded = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        alignment: Alignment.center,
        //color: Theme.of(context).scaffoldBackgroundColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isRounded ? 4 : 0),
          child: Hero(
            tag: tag,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: onTap,
                  child: (url != null) ? CustomImageNetwork(url: url) : image),
            ),
          ),
        ),
      ),
    );
  }
}
