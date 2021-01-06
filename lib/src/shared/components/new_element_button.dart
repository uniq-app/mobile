import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class NewElementButton extends StatelessWidget {
  final VoidCallback push;
  final double widthFraction, heightFraction;
  final Widget child;
  NewElementButton({
    Key key,
    this.push,
    this.widthFraction = 0.8,
    this.heightFraction = 0.15,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 15),
        //decoration: BoxDecoration(
        // borderRadius: BorderRadius.all(Radius.circular(15)),
        // border: Border.all(width: 2, color: Colors.grey[600])),
        child: DottedBorder(
          dashPattern: [6, 3],
          borderType: BorderType.RRect,
          radius: Radius.circular(15),
          color: Colors.grey,
          strokeWidth: 2,
          child: InkWell(
            onTap: push,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(12),
              height: size.height * heightFraction,
              child: child ??
                  Text(
                    "+",
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey),
                  ),
            ),
          ),
        ));
  }
}
