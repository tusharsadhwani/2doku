import 'package:flutter/material.dart';

import '../login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 1),
      () => Navigator.of(context).pushReplacementNamed(LoginScreen.routeName),
    );

    return Scaffold(
      body: Center(
        child: Text(
          'Sudoku',
          style: Theme.of(context).textTheme.display4,
        ),
      ),
    );
  }
}
