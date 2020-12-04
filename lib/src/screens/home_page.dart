import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/lake.jpg'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Pressed');
          Navigator.pushNamed(context, boardDetailsRoute);
        },
        tooltip: 'Route',
        child: Icon(Icons.add),
      ),
    );
  }
}
