import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sudoku/screens/splash_screen/splash_screen.dart';

class SudokuGrid extends StatelessWidget {
  final List grid;
  final List<List<Set>> markings;
  final int selectedX;
  final int selectedY;
  final int opponentSelectedX;
  final int opponentSelectedY;
  final Function setSelected;
  SudokuGrid(this.grid, this.markings, this.selectedX, this.selectedY,
      this.opponentSelectedX, this.opponentSelectedY, this.setSelected);

  _exitGame(context) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Leave Game?'),
        content: Text('Are you sure you want to leave this game?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (leave)
      Navigator.of(context).pushReplacementNamed(SplashScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: IconButton(
            onPressed: () => _exitGame(context),
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
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
                "${markings[x][y].contains(digit) ? digit : ''}",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
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
              color: x == selectedX && y == selectedY
                  ? Colors.amber.shade200.withAlpha(70)
                  : x == opponentSelectedX && y == opponentSelectedY
                      ? Colors.pink.shade200.withAlpha(70)
                      : Colors.transparent,
              child: InkWell(
                onTap: () {
                  setSelected(x, y);
                },
                child: FittedBox(
                  child: Text(
                    '${grid[x][y]['value'] <= 0 ? '' : grid[x][y]['value']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: grid[x][y]['prefilled']
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
    );
  }
}
