import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

class Database {
  String id;
  String name;
  bool player1;
  int roomCode;
  List<List<Map<String, Object>>> prefilledGrid;

  Future<void> createRoom({@required name}) async {
    this.name = name;
    roomCode = generateRoomCode();
    player1 = true;

    prefilledGrid = await generateGrid();

    final doc = await FirebaseFirestore.instance.collection('games').add({
      'grid': jsonEncode(prefilledGrid),
      'roomCode': roomCode,
      'player_1': FirebaseAuth.instance.currentUser.uid,
    });
    id = doc.id;
  }

  Future<bool> joinRoom({@required name, @required roomCode}) async {
    this.name = name;
    this.roomCode = roomCode;

    final userData = FirebaseAuth.instance.currentUser;

    final snapshot = await FirebaseFirestore.instance
        .collection('games')
        .where('roomCode', isEqualTo: this.roomCode)
        .get();

    snapshot.docs.forEach((doc) {
      id = doc.id;
    });

    final room =
        await FirebaseFirestore.instance.collection('games').doc(id).get();
    if (room.data()['player_1'] == userData.uid) {
      player1 = true;
      return true;
    }

    if (room.data()['player_2'] != null) {
      if (room.data()['player_2'] == userData.uid)
        player1 = false;
      else
        return false;
    }

    await FirebaseFirestore.instance
        .collection('games')
        .doc(id)
        .set({'player_2': userData.uid}, SetOptions(merge: true));

    player1 = false;
    return true;
  }
}

int generateRoomCode() => Random().nextInt(100000000);

Future<List<List<Map<String, Object>>>> generateGrid() async {
  var grid = List.generate(
    9,
    (_) => List.generate(9, (_) => {'value': -1, 'prefilled': false}),
  );

  final res = await http.get(
    Uri.parse('https://sugoku.herokuapp.com/board?difficulty=easy'),
  );

  final data = jsonDecode(res.body);
  final board = data['board'];
  for (int x = 0; x < 9; x++) {
    for (int y = 0; y < 9; y++) {
      var val = board[x][y];
      grid[x][y]['value'] = val;
      if (val > 0) {
        grid[x][y]['prefilled'] = true;
      }
    }
  }

  return grid;
}
