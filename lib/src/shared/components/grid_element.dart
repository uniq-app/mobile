import 'package:flutter/material.dart';
import 'package:uniq/src/models/photo.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/services/photo_api_provider.dart';
import 'package:uniq/src/shared/constants.dart';

class GridElement extends StatelessWidget {
  final Photo photo;
  final Image image;
  final double height;
  final double width;
  final Size size;
  GridElement(
      {@required this.photo,
      @required this.image,
      this.height,
      this.width,
      this.size});

  @override
  Widget build(BuildContext context) {
    String tag = '${photo.photoId}';
    String url = "${PhotoApiProvider.apiUrl}/${photo.value}";
    Map<String, dynamic> arguments = {'url': url, 'tag': tag, 'image': image};
    return Container(
      height: width,
      width: width,
      child: FittedBox(
        fit: BoxFit.cover,
        child: PhotoHero(
          tag: tag,
          image: image,
          isRounded: true,
          onTap: () {
            Navigator.pushNamed(context, photoDetails, arguments: arguments);
          },
        ),
      ),
    );
  }
}
