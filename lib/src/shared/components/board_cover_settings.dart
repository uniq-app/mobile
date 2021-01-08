import 'dart:io';
import 'package:flutter/material.dart';

class BoardCoverSettings extends StatelessWidget {
  final String image;
  final File imageFromFile;
  final VoidCallback editLink;
  final double widthFraction, heightFraction;
  const BoardCoverSettings(
      {Key key,
      this.image =
          "https://images.unsplash.com/photo-1567201864585-6baec9110dac?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=50",
      this.editLink,
      this.imageFromFile,
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
                  image: (image.contains("http") == true)
                      ? NetworkImage(image)
                      : FileImage(imageFromFile),
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
