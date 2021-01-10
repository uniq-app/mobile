import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class WrapExample extends StatefulWidget {
  final List<Image> images;
  WrapExample(this.images);
  @override
  _WrapExampleState createState() => _WrapExampleState();
}

class _WrapExampleState extends State<WrapExample> {
  List<Widget> _tiles;

  @override
  void initState() {
    super.initState();
    _tiles = widget.images
        .map(
          (e) => SizedBox.fromSize(
            size: Size(100, 100),
            child: e,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, row);
      });
    }

    var wrap = ReorderableWrap(
        spacing: 8.0,
        runSpacing: 4.0,
        padding: const EdgeInsets.all(8),
        children: _tiles,
        onReorder: _onReorder,
        onNoReorder: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
        },
        onReorderStarted: (int index) {
          //this callback is optional
          debugPrint(
              '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
        });

    return wrap;
  }
}
