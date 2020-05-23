import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double fontSize;

  const ActionButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    this.fontSize: 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        hoverColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fontSize),
          side: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(fontSize / 4),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
