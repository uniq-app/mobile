import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/page/page_cubit.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({
    Key key,
  }) : super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 0;

  _setPage(int index) {
    context.read<PageCubit>().setPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageCubit, PageState>(
      builder: (context, PageState state) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 24,
          currentIndex: state.index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            print(index);
            if (_currentIndex != index) {
              _currentIndex = index;
              _setPage(index);
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
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
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: Icon(Icons.supervised_user_circle),
                onPressed: () {
                  Navigator.pushNamed(context, profileRoute);
                },
              ),
              label: 'Profile',
            )
          ],
        );
      },
    );
  }
}
