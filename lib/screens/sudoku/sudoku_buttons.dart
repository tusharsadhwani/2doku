import 'package:flutter/material.dart';

class SudokuButtons extends StatelessWidget {
  final Function setGridValue;
  SudokuButtons(this.setGridValue);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SudokuButton(1, setGridValue),
            SudokuButton(2, setGridValue),
            SudokuButton(3, setGridValue),
            SudokuButton(4, setGridValue),
            SudokuButton(5, setGridValue),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SudokuButton(6, setGridValue),
            SudokuButton(7, setGridValue),
            SudokuButton(8, setGridValue),
            SudokuButton(9, setGridValue),
          ],
        ),
      ],
    ));
  }
}

class SudokuButton extends StatelessWidget {
  final int value;
  final Function setGridValue;
  SudokuButton(this.value, this.setGridValue);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey.shade300,
      ),
      child: InkWell(
        onTap: () => setGridValue(value),
        child: SizedBox(
          width: 50,
          height: 50,
          child: FittedBox(
            child: Text('$value'),
          ),
        ),
      ),
    );
  }
}
