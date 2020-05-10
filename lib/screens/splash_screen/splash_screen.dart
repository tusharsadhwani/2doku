import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../login/login_screen.dart';
import '../home/home_screen.dart';

Future<void> _checkLogin(BuildContext context) async {
  await Future.delayed(Duration(seconds: 1));
  final user = Provider.of<FirebaseUser>(context, listen: false);
  if (user != null) {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  } else {
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkLogin(context);

    return Scaffold(
      body: Center(
        child: Text(
          'Sudoku',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
    );
  }
}
