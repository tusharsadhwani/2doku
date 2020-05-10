import 'package:flutter/material.dart';
import 'package:sudoku/screens/sudoku/sudoku.dart';

class SudokuScreen extends StatelessWidget {
  static const routeName = '/game';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sudoku"),
      ),
      body: Sudoku(),
    );
  }
}
