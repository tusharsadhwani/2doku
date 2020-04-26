import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './sudoku_buttons.dart';
import './sudoku_grid.dart';

class Sudoku extends StatefulWidget {
  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  // List grid = [
  //   [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  //   [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  //   [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  //   [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  //   [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  //   [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  //   [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  //   [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  //   [-1, -1, -1, -1, -1, -1, -1, -1, -1],
  // ];
  var grid = List.generate(
      9, (_) => List.generate(9, (_) => {'value': -1, 'prefilled': false}));
  var markings = List.generate(9, (_) => List.generate(9, (_) => Set<int>()));
  int selectedX;
  int selectedY;
  bool markingMode = false;

  @override
  void initState() {
    super.initState();
    markings[0][0].add(1);
    markings[0][0].add(8);
    http.get('https://sugoku.herokuapp.com/board?difficulty=easy').then((res) {
      setState(() {
        final data = jsonDecode(res.body);
        final board = data['board'];
        print("board: $board");
        for (int x = 0; x < 9; x++) {
          for (int y = 0; y < 9; y++) {
            var val = board[x][y];
            grid[x][y]['value'] = val;
            if (val > 0) {
              grid[x][y]['prefilled'] = true;
            }
          }
        }
      });
    });
  }

  void setSelected(int x, int y) {
    setState(() {
      selectedX = x;
      selectedY = y;
    });
  }

  void setGridValue(int value) {
    final x = selectedX;
    final y = selectedY;
    if (x < 0 || x > 8 || y < 0 || y > 8) return;
    if (grid[x][y]['prefilled']) return;

    if (markingMode) {
      if (markings[x][y].contains(value))
        setState(() {
          markings[x][y].remove(value);
        });
      else
        setState(() {
          markings[x][y].add(value);
        });
      if (grid[x][y]['value'] as int > 0)
        setState(() {
          grid[x][y]['value'] = 0;
        });
    } else {
      if (grid[x][y]['value'] == value) value = 0;
      setState(() {
        grid[x][y]['value'] = value;
        markings[x][y].clear();
      });
    }
  }

  void toggleMarkingMode() {
    setState(() {
      markingMode = !markingMode;
    });
  }

  String testMessage = 'Test';
  void setMessage(text) {
    setState(() {
      testMessage = text;
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
            setSelected,
            setMessage,
          ),
        ),
        Text(
          testMessage,
          style: TextStyle(color: Colors.red),
        ),
        SudokuButtons(setGridValue, markingMode, toggleMarkingMode),
      ],
    );
  }
}
