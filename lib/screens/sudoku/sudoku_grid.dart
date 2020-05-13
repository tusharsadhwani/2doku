import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SudokuGrid extends StatefulWidget {
  final List grid;
  final List<List<Set>> markings;
  final int selectedX;
  final int selectedY;
  final int opponentSelectedX;
  final int opponentSelectedY;
  final Function setSelected;
  SudokuGrid(this.grid, this.markings, this.selectedX, this.selectedY,
      this.opponentSelectedX, this.opponentSelectedY, this.setSelected);

  @override
  _SudokuGridState createState() => _SudokuGridState();
}

class _SudokuGridState extends State<SudokuGrid> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/sudoku.svg'),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 27),
            itemBuilder: (_, idx) {
              final x = (idx ~/ 81) % 9;
              final y = (idx ~/ 3) % 9;
              final digit = (idx % 3 + (3 * (idx ~/ 27))) % 9 + 1;
              return FittedBox(
                child: Text(
                  "${widget.markings[x][y].contains(digit) ? digit : ''}",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              );
            },
            itemCount: 729,
          ),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
            itemBuilder: (_, idx) {
              final int x = idx ~/ 9;
              final int y = idx % 9;
              return Container(
                color: x == widget.selectedX && y == widget.selectedY
                    ? Colors.amber.shade200.withAlpha(70)
                    : x == widget.opponentSelectedX &&
                            y == widget.opponentSelectedY
                        ? Colors.pink.shade200.withAlpha(70)
                        : Colors.transparent,
                child: InkWell(
                  onTap: () {
                    widget.setSelected(x, y);
                  },
                  child: FittedBox(
                    child: Text(
                      '${widget.grid[x][y]['value'] <= 0 ? '' : widget.grid[x][y]['value']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: widget.grid[x][y]['prefilled']
                            ? Theme.of(context).accentColor
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: 81,
          ),
        ],
      ),
    );
  }
}
