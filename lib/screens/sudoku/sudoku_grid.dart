import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SudokuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SvgPicture.asset('assets/sudoku.svg'),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
          itemBuilder: (_, idx) => Container(
            // color: idx % 2 == 0 ? Colors.red : Colors.blue,
            child: FittedBox(
              child: Text(
                '${((idx ~/ 9) * 10 + idx % 9) % 9 + 1}',
                style: TextStyle(
                  color: idx % 2 == 0 ? Colors.black : Colors.blue,
                ),
              ),
            ),
          ),
          itemCount: 81,
        ),
      ],
    );
  }
}
