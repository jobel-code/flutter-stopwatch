import 'package:flutter/material.dart';
import 'package:stopwatch/egg_timer_button.dart';

class EggTimerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            EggTimerButton(icon: Icons.refresh, text: 'RESTART',),
            Expanded(child: Container(),),
            EggTimerButton(icon: Icons.arrow_back, text: 'RESET',),
          ],
        ),
        EggTimerButton(icon: Icons.pause, text: 'Pause',),
      ],
    );
  }
}
