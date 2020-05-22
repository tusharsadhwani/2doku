import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../login/login_screen.dart';
import '../home/home_screen.dart';

Future<void> _checkLogin(BuildContext context) async {
  await Future.delayed(Duration(milliseconds: 500));

  try {
    final googleUser = await GoogleSignIn().signInSilently();
    print('Logged in as, $googleUser');
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  } catch (error) {
    print('Not Logged In');
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
