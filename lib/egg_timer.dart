// Inspired by https://www.youtube.com/watch?v=svxUUz5mi9s&t=2147s

import 'package:flutter/material.dart';
// import 'package:fluttery/framing.dart';  // used for prototypes.
import 'package:stopwatch/egg_timer_controls.dart';
import 'package:stopwatch/egg_timer_time_display.dart';
// import 'package:stopwatch/egg_timer_button.dart'; // Used now within the controls
import 'package:stopwatch/egg_timer_dial.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final EggTimer eggTimer;

  _MyAppState() : eggTimer = EggTimer(maxTime: Duration(minutes: 35));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'BebasNeue',
      ),
      home: Scaffold(
        // Container used to keep the color gradient of the background
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [GRADIENT_TOP, GRADIENT_BOTTOM])),
          child: Center(
            child: Column(
              children: <Widget>[
                EggTimerTimeDisplay(),
                EggTimerDial(
                  currentTime: eggTimer.currentTime,
                  maxTime: eggTimer.maxTime,
                  ticksPerSection: 5,
                ),

                Expanded(
                  child: Container(),
                ),

                EggTimerControls(),

                // From Fluttery/framing
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EggTimer {
  final Duration maxTime;

  // Defaults
  Duration _currentTime = Duration(seconds: 0);
  EggTimerState state = EggTimerState.ready;

  EggTimer({this.maxTime});

  get currentTime {
    return _currentTime;
  }

  set currentTime(newTime) {
    // only allows the time change under certain circumstances.
    // only when ready and not while running.
    if (state == EggTimerState.ready) {
      _currentTime = newTime;
    }
  }
}

enum EggTimerState {
  ready,
  running,
  paused,
}
