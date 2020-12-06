import 'package:camera/camera.dart';
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
      // TODO: Switch to proper icons and labels, "switch" screen without routing
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, homeRoute);
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
          print('Pressed');
          Navigator.pushNamed(context, boardDetailsRoute);
        },
        tooltip: 'Route',
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
