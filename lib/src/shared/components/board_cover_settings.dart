import 'dart:io';

import 'package:flutter/material.dart';

class BoardCoverSettings extends StatelessWidget {
  final String image;
  final VoidCallback editLink;
  final double widthFraction, heightFraction;
  const BoardCoverSettings(
      {Key key,
      this.image,
      this.editLink,
      this.widthFraction = 0.8,
      this.heightFraction = 0.15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("BUILDING IMAGE: $image");
    Size size = MediaQuery.of(context).size;
    return Container(
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: editLink,
            child: Container(
              width: size.width,
              height: size.height * heightFraction,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter:
                      ColorFilter.mode(Colors.grey, BlendMode.multiply),
                  image: (image == null)
                      ? AssetImage('assets/defaultCover.jpg')
                      : (image.contains('http'))
                          ? NetworkImage(image)
                          : FileImage(File(image)),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Change Cover",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w300)),
                  ]),
            ),
          )),
    );
  }
}
