// Inspired by https://www.youtube.com/watch?v=svxUUz5mi9s&t=2147s

import 'package:flutter/material.dart';
import 'package:fluttery/framing.dart';
import 'package:stopwatch/egg_timer_controls.dart';
import 'package:stopwatch/egg_timer_time_display.dart';
import 'package:stopwatch/egg_timer_button.dart';

//final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
//final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'BebasNeue',
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              EggTimerTimeDisplay(),
              RandomColorBlock(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(left: 45.0, right: 45.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: RandomColorBlock(
                      width: double.infinity,
                    ),
                  ),
                ),
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
    );
  }
}
