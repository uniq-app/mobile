import 'package:flutter/material.dart';
import 'package:uniq/src/shared/constants.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
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
            onPressed: () {
              Navigator.pushNamed(context, cameraRoute);
            },
          ),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: () {
              Navigator.pushNamed(context, imagePickerRoute);
            },
          ),
          label: 'Library',
        )
      ],
    );
  }
}
