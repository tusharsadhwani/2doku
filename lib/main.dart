import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sudoku/models/database.dart';

import './screens/splash_screen/splash_screen.dart';
import './screens/login/login_screen.dart';
import './screens/home/home_screen.dart';
import './screens/lobby/lobby_screen.dart';
import './screens/sudoku/sudoku_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final primaryColor = Color.fromRGBO(160, 149, 97, 1.0);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
        Provider.value(value: Database()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            // textTheme: TextTheme(
            //   title: TextStyle(
            //     color: Colors.white,
            //     fontSize: 20,
            //   ),
            // ),
          ),
          accentColor: Colors.white,
          primaryColor: primaryColor,
          buttonTheme: ButtonThemeData(
            textTheme: ButtonTextTheme.accent,
            buttonColor: primaryColor,
          ),
          scaffoldBackgroundColor: Colors.grey.shade900,
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white),
            bodyText2: TextStyle(color: Colors.white),
            // subhead: TextStyle(color: Colors.white),
            // display1: GoogleFonts.montserrat(),
            headline1: TextStyle(color: primaryColor),
            button: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return PageTransition(
                child: SplashScreen(),
                type: PageTransitionType.fade,
              );
            case LoginScreen.routeName:
              return PageTransition(
                child: LoginScreen(),
                type: PageTransitionType.leftToRightWithFade,
              );
            case HomeScreen.routeName:
              return PageTransition(
                child: HomeScreen(),
                type: PageTransitionType.leftToRightWithFade,
              );
            case SudokuScreen.routeName:
              return PageTransition(
                child: SudokuScreen(),
                type: PageTransitionType.leftToRightWithFade,
              );
            case LobbyScreen.routeName:
              return PageTransition(
                child: LobbyScreen(),
                type: PageTransitionType.leftToRightWithFade,
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
