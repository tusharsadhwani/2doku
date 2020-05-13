import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/database.dart';
import '../sudoku/sudoku_screen.dart';

class LobbyScreen extends StatefulWidget {
  static const routeName = '/lobby';

  LobbyScreen();

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  int roomCode;
  @override
  void initState() {
    final db = Provider.of<Database>(context, listen: false);
    roomCode = db.roomCode;
    Firestore.instance
        .collection('games')
        .document(db.id)
        .snapshots()
        .listen(startGame);

    super.initState();
  }

  void startGame(DocumentSnapshot snapshot) {
    if (snapshot.data['player_2_joined'])
      Navigator.of(context).pushReplacementNamed(SudokuScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lobby"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Room Code: $roomCode"),
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
            SizedBox(height: 10),
            Text(
              "Waiting for the other player to join...",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
