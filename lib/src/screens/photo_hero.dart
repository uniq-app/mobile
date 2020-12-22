import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uniq/src/shared/custom_error.dart';
import 'package:uniq/src/shared/loading.dart';

class PhotoHero extends StatelessWidget {
  final String photo;
  final VoidCallback onTap;
  final String tag;
  final bool isRounded;

  PhotoHero({Key key, this.photo, this.onTap, this.tag, this.isRounded = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: CustomImageNetwork(photo: photo),
              ),
            ),
          ),
        ));
  }
}

class CustomImageNetwork extends StatelessWidget {
  const CustomImageNetwork({
    Key key,
    @required this.photo,
  }) : super(key: key);

  final String photo;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      photo,
      errorBuilder:
          (BuildContext context, Object exception, StackTrace stackTrace) {
        print("Failed loading $photo, attempt");
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
