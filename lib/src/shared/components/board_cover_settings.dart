import 'package:flutter/material.dart';

class BoardCoverSettings extends StatelessWidget {
  final String image;
  final VoidCallback editLink;
  final double widthFraction, heightFraction;
  const BoardCoverSettings(
      {Key key,
      this.image =
          "https://images.unsplash.com/photo-1609869873312-9cb82a7724c7?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=30",
      this.editLink,
      this.widthFraction = 0.8,
      this.heightFraction = 0.15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  image: NetworkImage(image),
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
