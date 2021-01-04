import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/page/page_cubit.dart';
import 'package:uniq/src/screens/home_page.dart';
import 'package:uniq/src/screens/image_library_page.dart';
import 'package:uniq/src/screens/search_page.dart';
import 'package:uniq/src/screens/take_photo_screen.dart';
import 'package:uniq/src/screens/user_settings_page.dart';
import 'package:uniq/src/shared/components/bottom_navbar.dart';

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    print("Building scaffold");
    return Scaffold(
      body: BlocBuilder<PageCubit, PageState>(
        builder: (BuildContext context, PageState state) {
          if (state == PageState.homePage) {
            return HomePage();
          }
          if (state == PageState.searchPage) {
            return SearchPage();
          }
          if (state == PageState.cameraPage) {
            return TakePhotoScreen();
          }
          if (state == PageState.libraryPage) {
            return ImageLibraryPage();
          }
          if (state == PageState.profilePage) {
            return UserSettingsPage();
          }
          return HomePage();
        },
      ),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
