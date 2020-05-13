import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './sudoku_buttons.dart';
import './sudoku_grid.dart';
import '../../constants/update_type.dart';
import '../../models/database.dart';

class Sudoku extends StatefulWidget {
  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  var grid = List.generate(
      9, (_) => List.generate(9, (_) => {'value': -1, 'prefilled': false}));

  var markings = List.generate(9, (_) => List.generate(9, (_) => Set<int>()));
  int selectedX = -1;
  int selectedY = -1;
  int opponentSelectedX = -1;
  int opponentSelectedY = -1;
  bool markingMode = false;

  Database db;
  StreamSubscription<QuerySnapshot> subscription;
  StreamSubscription<DocumentSnapshot> gridSubscription;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      db = Provider.of<Database>(context, listen: false);
      if (db.prefilledGrid != null)
        setState(() {
          grid = db.prefilledGrid;
        });

      subscription = Firestore.instance
          .collection('games')
          .document(db.id)
          .collection('updates')
          .snapshots()
          .listen(firestoreUpdate);

      gridSubscription = Firestore.instance
          .collection('games')
          .document(db.id)
          .snapshots()
          .listen(fillGrid);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    gridSubscription.cancel();
    super.dispose();
  }

  void firestoreUpdate(QuerySnapshot event) {
    event.documentChanges.forEach((change) {
      final Map<String, dynamic> data = change.document.data;
      final String updateType = data['type'];
      switch (updateType) {
        case UpdateType.SET_GRID_VALUE:
          int x = data['x'];
          int y = data['y'];
          int value = data['value'];
          localSetGridValue(x, y, value);
          print("Firestore set ($x, $y) to $value");
          break;
        case UpdateType.UNSET_GRID_VALUE:
          int x = data['x'];
          int y = data['y'];
          localUnsetGridValue(x, y);
          print("Firestore unset ($x, $y)");
          break;
        case UpdateType.SET_MARKING:
          int x = data['x'];
          int y = data['y'];
          int value = data['value'];
          localSetMarking(x, y, value);
          print("Firestore marking set ($x, $y)'s $value");
          break;
        case UpdateType.UNSET_MARKING:
          int x = data['x'];
          int y = data['y'];
          int value = data['value'];
          localUnsetMarking(x, y, value);
          print("Firestore marking unset ($x, $y)'s $value");
          break;
        case UpdateType.CHANGE_PLAYER_SELECTED_CELL:
          bool player1 = data['player1'];
          int x = data['x'];
          int y = data['y'];
          if (db.player1 != player1) {
            setOpponentSelectedCell(x, y);
            print("Firestore set opponent marker at ($x, $y)");
          }
          break;
        default:
          print("Error, weird update type: $updateType");
      }
    });
  }

  void fillGrid(DocumentSnapshot doc) {
    Map data = doc.data;
    List firestoreGrid = jsonDecode(data['grid']);
    final newGrid = List.generate(
        9, (_) => List.generate(9, (_) => {'value': -1, 'prefilled': false}));

    for (int x = 0; x < 9; x++) {
      for (int y = 0; y < 9; y++) {
        Map cell = firestoreGrid[x][y];
        newGrid[x][y] = cell;
      }
    }
    setState(() {
      grid = newGrid;
      print("Firestore set prefilled grid");
    });
  }

  void setSelected(int x, int y) {
    setState(() {
      selectedX = x;
      selectedY = y;
    });
    firestoreSetSelected(x, y);
  }

  void firestoreSetSelected(int x, int y) {
    Firestore.instance
        .collection('games')
        .document(db.id)
        .collection('updates')
        .add({
      'type': UpdateType.CHANGE_PLAYER_SELECTED_CELL,
      'x': selectedX,
      'y': selectedY,
      'player1': db.player1,
    });
  }

  void setOpponentSelectedCell(int x, int y) {
    setState(() {
      opponentSelectedX = x;
      opponentSelectedY = y;
    });
  }

  void firestoreSetMarking(int x, int y, int value) {
    Firestore.instance
        .collection('games')
        .document(db.id)
        .collection('updates')
        .add({
      'type': UpdateType.SET_MARKING,
      'x': selectedX,
      'y': selectedY,
      'value': value,
    });
  }

  void localSetMarking(int x, int y, int value) {
    setState(() {
      markings[x][y].add(value);
    });
    if (grid[x][y]['value'] as int > 0) unsetGridValue(x, y);
  }

  void setMarking(int x, int y, int value) {
    localSetMarking(x, y, value);
    print("Local marking set ($x, $y)'s $value");
    firestoreSetMarking(x, y, value);
  }

  void firestoreUnsetMarking(int x, int y, int value) {
    Firestore.instance
        .collection('games')
        .document(db.id)
        .collection('updates')
        .add({
      'type': UpdateType.UNSET_MARKING,
      'x': selectedX,
      'y': selectedY,
      'value': value,
    });
  }

  void localUnsetMarking(int x, int y, value) {
    setState(() {
      markings[x][y].remove(value);
    });
  }

  void unsetMarking(int x, int y, int value) {
    localUnsetMarking(x, y, value);
    print("Local marking unset ($x, $y)'s $value");
    firestoreUnsetMarking(x, y, value);
  }

  void firestoreSetGridValue(int x, int y, int value) {
    Firestore.instance
        .collection('games')
        .document(db.id)
        .collection('updates')
        .add({
      'type': UpdateType.SET_GRID_VALUE,
      'x': selectedX,
      'y': selectedY,
      'value': value,
    });
  }

  void localSetGridValue(int x, int y, int value) {
    setState(() {
      grid[x][y]['value'] = value;
      markings[x][y].clear();
    });
  }

  void setGridValue(int x, int y, int value) {
    localSetGridValue(x, y, value);
    print("Local set ($x, $y) to $value");
    firestoreSetGridValue(x, y, value);
  }

  void firestoreUnsetGridValue(int x, int y) {
    Firestore.instance
        .collection('games')
        .document(db.id)
        .collection('updates')
        .add({
      'type': UpdateType.UNSET_GRID_VALUE,
      'x': selectedX,
      'y': selectedY,
    });
  }

  void localUnsetGridValue(int x, int y) {
    localSetGridValue(x, y, 0);
  }

  void unsetGridValue(int x, int y) {
    localUnsetGridValue(x, y);
    print("Local unset ($x, $y)");
    firestoreUnsetGridValue(x, y);
  }

  void changeGridValue(int value) {
    int x = selectedX;
    int y = selectedY;

    if (x < 0 || x > 8 || y < 0 || y > 8) return;
    if (grid[x][y]['prefilled']) return;

    if (markingMode) {
      if (markings[x][y].contains(value))
        unsetMarking(x, y, value);
      else
        setMarking(x, y, value);
    } else {
      if (grid[x][y]['value'] == value)
        unsetGridValue(x, y);
      else
        setGridValue(x, y, value);
    }
  }

  void toggleMarkingMode() {
    setState(() {
      markingMode = !markingMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SudokuGrid(
            grid,
            markings,
            selectedX,
            selectedY,
            opponentSelectedX,
            opponentSelectedY,
            setSelected,
          ),
        ),
        SudokuButtons(changeGridValue, markingMode, toggleMarkingMode),
      ],
    );
  }
}
