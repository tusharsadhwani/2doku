import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<void> _handleSignOut(BuildContext context) async {
    await _googleSignIn.signOut();
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () => _handleSignOut(context),
          child: Text(
            "Logout",
          ),
        ),
      ),
    );
  }
}
