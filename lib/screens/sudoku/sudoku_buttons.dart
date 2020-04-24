import 'package:flutter/material.dart';

class SudokuButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SudokuButton(1),
            SudokuButton(2),
            SudokuButton(3),
            SudokuButton(4),
            SudokuButton(5),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SudokuButton(6),
            SudokuButton(7),
            SudokuButton(8),
            SudokuButton(9),
          ],
        ),
      ],
    ));
  }
}

class SudokuButton extends StatelessWidget {
  final int value;
  SudokuButton(this.value);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey.shade300,
      ),
      child: SizedBox(
        width: 50,
        height: 50,
        child: FittedBox(
          child: Text('$value'),
        ),
      ),
    );
  }
}
