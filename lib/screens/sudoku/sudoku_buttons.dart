import 'package:flutter/material.dart';

class SudokuButtons extends StatelessWidget {
  final Function setGridValue;
  final bool markingMode;
  final Function toggleMarkingMode;
  SudokuButtons(this.setGridValue, this.markingMode, this.toggleMarkingMode);
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
            SudokuModeButton(markingMode, toggleMarkingMode),
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
    const buttonTextStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.w300);
    final radius = BorderRadius.circular(5.0);
    return Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: radius,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: () => setGridValue(value),
          child: SizedBox(
            width: 50,
            height: 50,
            child: FittedBox(
              child: Text(
                '$value',
                style: buttonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SudokuModeButton extends StatelessWidget {
  final bool markingMode;
  final Function toggleMarkingMode;
  SudokuModeButton(this.markingMode, this.toggleMarkingMode);
  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = TextStyle(
        color: Theme.of(context).primaryColor, fontWeight: FontWeight.w300);
    final radius = BorderRadius.circular(5.0);
    return Container(
      margin: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: radius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: () => toggleMarkingMode(),
            child: SizedBox(
              width: 50,
              height: 50,
              child: markingMode
                  ? GridView(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      children: <Widget>[
                        FittedBox(
                          child: Text(
                            'X',
                            style: buttonTextStyle,
                          ),
                        ),
                      ],
                    )
                  : FittedBox(
                      child: Text(
                        'X',
                        style: buttonTextStyle,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
