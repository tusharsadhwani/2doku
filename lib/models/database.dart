import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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

    final doc = await Firestore.instance.collection('games').add({
      'grid': jsonEncode(prefilledGrid),
      'roomCode': roomCode,
      'player_2_joined': false,
    });
    id = doc.documentID;
  }

  Future<void> joinRoom({@required name, @required roomCode}) async {
    this.name = name;
    this.roomCode = roomCode;
    player1 = false;

    final snapshot = await Firestore.instance
        .collection('games')
        .where('roomCode', isEqualTo: this.roomCode)
        .getDocuments();

    snapshot.documents.forEach((doc) {
      id = doc.documentID;
    });

    await Firestore.instance.collection('games').document(id).setData({
      'player_2_joined': true,
    }, merge: true);
  }
}

int generateRoomCode() => Random().nextInt(100000000);

Future<List<List<Map<String, Object>>>> generateGrid() async {
  var grid = List.generate(
      9, (_) => List.generate(9, (_) => {'value': -1, 'prefilled': false}));

  final res =
      await http.get('https://sugoku.herokuapp.com/board?difficulty=easy');

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
