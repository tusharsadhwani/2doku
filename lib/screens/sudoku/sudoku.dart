import 'package:flutter/material.dart';
import './sudoku_buttons.dart';
import './sudoku_grid.dart';

class Sudoku extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SudokuGrid(),
        ),
        SudokuButtons(),
      ],
    );
  }
}
