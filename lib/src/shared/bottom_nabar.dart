import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.maybePop(context);
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
              Navigator.pushNamed(context, cameraRoute, arguments: firstCamera);
            },
          ),
          label: 'Camera',
        ),
      ],
    );
  }
}
