// Inspired by https://www.youtube.com/watch?v=svxUUz5mi9s&t=2147s

import 'package:flutter/material.dart';
import 'package:stopwatch/egg_timer.dart';
// import 'package:fluttery/framing.dart';  // used for prototypes.
import 'package:stopwatch/egg_timer_controls.dart';
import 'package:stopwatch/egg_timer_time_display.dart';
// import 'package:stopwatch/egg_timer_button.dart'; // Used now within the controls
import 'package:stopwatch/egg_timer_dial.dart';

// ignore: non_constant_identifier_names
final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
// ignore: non_constant_identifier_names
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  EggTimer eggTimer;

  _MyAppState() {
    eggTimer = new EggTimer(
      maxTime: const Duration(minutes: 35),
      onTimerUpdate: _onTimerUpdate,
    );
  }

  _onTimeSelected(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
    });
  }

  _onDialStopTurning(Duration newTime) {
    setState(() {
      eggTimer.currentTime = newTime;
      eggTimer.resume();
    });
  }

  _onTimerUpdate() {
    setState(() { });
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'BebasNeue',
      ),
      home: new Scaffold(
        body: new Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [GRADIENT_TOP, GRADIENT_BOTTOM],
            ),
          ),
          child: new Center(
            child: new Column(
              children: [
                new EggTimerTimeDisplay(
                  eggTimerState: eggTimer.state,
                  selectionTime: eggTimer.lastStartTime,
                  countdownTime: eggTimer.currentTime,
                ),

                new EggTimerDial(
                  eggTimerState: eggTimer.state,
                  currentTime: eggTimer.currentTime,
                  maxTime: eggTimer.maxTime,
                  ticksPerSection: 5,
                  onTimeSelected: _onTimeSelected,
                  onDialStopTurning: _onDialStopTurning,
                ),

                new Expanded(child: new Container()),

                new EggTimerControls(
                  eggTimerState: eggTimer.state,
                  onPause: () {
                    setState(() => eggTimer.pause());
                  },
                  onResume: () {
                    setState(() => eggTimer.resume());
                  },
                  onRestart: () {
                    setState(() => eggTimer.restart());
                  },

                  onReset: () {
                    setState(() => eggTimer.reset());
                  },
                ),

               // From Fluttery/framing
              ],
            ),
          ),
        ),
      ),
    );
  }
}
