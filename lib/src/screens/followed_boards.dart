import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';

class FollowedBoards extends StatefulWidget {
  @override
  _FollowedBoardsState createState() => _FollowedBoardsState();
}

class _FollowedBoardsState extends State<FollowedBoards> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Followed boards'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(searchPageRoute);
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
