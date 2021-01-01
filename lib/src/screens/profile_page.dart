import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uniq/src/blocs/auth/auth_bloc.dart';
import 'package:uniq/src/shared/components/bottom_navbar.dart';
import 'package:uniq/src/shared/constants.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
      bottomNavigationBar: BottomNavbar(),
    );
  }

  Widget _body(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state is LogoutSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              welcomeRoute, (Route<dynamic> route) => false);
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile'),
            OutlinedButton(
              onPressed: () => {context.read<AuthBloc>().add(Logout())},
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
