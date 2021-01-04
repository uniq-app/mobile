import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/page/page_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({
    Key key,
  }) : super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  _setPage(int index) {
    context.read<PageCubit>().setPage(PageState.values[index]);
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
            if (state.index != index) {
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
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}
