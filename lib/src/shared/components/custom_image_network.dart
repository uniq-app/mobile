import 'package:flutter/material.dart';
import 'package:uniq/src/shared/components/custom_error.dart';
import 'package:uniq/src/shared/components/loading.dart';

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
