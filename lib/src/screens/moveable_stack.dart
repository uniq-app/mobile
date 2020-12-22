import 'package:flutter/material.dart';

class MoveableStack extends StatefulWidget {
  final List<Image> photos;
  const MoveableStack({this.photos});
  @override
  _MoveableStackState createState() => _MoveableStackState(this.photos);
}

class _MoveableStackState extends State<MoveableStack> {
  final List<Image> photos;
  List<MoveableStackItem> stackItems;

  _MoveableStackState(this.photos);

  @override
  void initState() {
    stackItems = photos.map((e) => MoveableStackItem(e)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: stackItems,
    ));
  }
}

class MoveableStackItem extends StatefulWidget {
  final Image image;
  const MoveableStackItem(this.image);

  @override
  State<StatefulWidget> createState() => _MoveableStackItemState(this.image);
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  final Image image;
  _MoveableStackItemState(this.image);

  double xPosition = 0;
  double yPosition = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
          onPanUpdate: (tapInfo) {
            setState(() {
              xPosition += tapInfo.delta.dx;
              yPosition += tapInfo.delta.dy;
            });
          },
          child: image),
    );
  }
}
