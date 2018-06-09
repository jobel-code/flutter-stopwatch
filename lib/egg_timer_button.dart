import 'package:flutter/material.dart';

class EggTimerButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      splashColor: Color(0x22000000),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: Icon(
                Icons.pause,
                color: Colors.black,
              ),
            ),
            Text(
              'Pause',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
