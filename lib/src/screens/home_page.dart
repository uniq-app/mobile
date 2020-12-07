import 'package:camera/camera.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:uniq/src/shared/ad_manager.dart';

import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<void>(
        future: _initAdMob(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          List<Widget> children = <Widget>[
            Text(
              "Awesome Drawing Quiz!",
              style: TextStyle(
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 72),
            ),
          ];

          if (snapshot.hasData) {
            children.add(RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text(
                "Let's get started!".toUpperCase(),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 48,
              ),
              onPressed: () => Navigator.of(context).pushNamed('/game'),
            ));
          } else if (snapshot.hasError) {
            children.addAll(<Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
            ]);
          } else {
            children.add(SizedBox(
              child: CircularProgressIndicator(),
              width: 48,
              height: 48,
            ));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
      // TODO: Switch to proper icons and labels, "switch" screen without routing
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacementNamed(context, homeRoute);
              },
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.camera),
              onPressed: () async {
                // Ensure that camera is initialized
                WidgetsFlutterBinding.ensureInitialized();
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                Navigator.pushNamed(context, cameraRoute,
                    arguments: firstCamera);
              },
            ),
            label: 'Camera',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, boardDetailsRoute);
        },
        tooltip: 'Route',
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
