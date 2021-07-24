import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home/home_screen.dart';
import '../../widgets/action_button.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _handleSignIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(
            flex: 2,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FittedBox(
                child: Text(
                  'Sudoku',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
          ),
          Spacer(flex: 1),
          Center(
            child: ActionButton(
              onPressed: () => _handleSignIn(context),
              text: 'Login',
              fontSize: 32.0,
            ),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}
