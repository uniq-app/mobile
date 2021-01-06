import 'package:flutter/material.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';

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
        color: Theme.of(context).scaffoldBackgroundColor,
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

class CustomImageNetwork extends StatelessWidget {
  final String url;

  const CustomImageNetwork({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace stackTrace) {
        print("Failed loading $url, attempt");
        return CustomError(message: "Failed to load");
      },
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent progress) {
        if (progress != null)
          print(progress.cumulativeBytesLoaded / progress.expectedTotalBytes);
        return progress == null ? child : Loading();
      },
    );
  }
}
