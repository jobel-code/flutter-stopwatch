// Inspired by https://www.youtube.com/watch?v=svxUUz5mi9s&t=2147s

import 'package:flutter/material.dart';
import 'package:fluttery/framing.dart';
import 'package:stopwatch/egg_timer_controls.dart';
import 'package:stopwatch/egg_timer_time_display.dart';
import 'package:stopwatch/egg_timer_button.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class MyApp extends StatelessWidget {
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
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(left: 45.0, right: 45.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [GRADIENT_TOP, GRADIENT_BOTTOM]),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x44000000),
                              blurRadius: 2.0,
                              spreadRadius: 1.0,
                              offset: Offset(0.0, 1.0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(65.0),
                          child: Container(
                            padding: EdgeInsets.all(10.0), // THIS is for the child border
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [GRADIENT_TOP, GRADIENT_BOTTOM]),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x44000000),
                                  blurRadius: 2.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(0.0, 1.0),
                                ),
                              ],
                            ),
                            child: Container(

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Color(0xFFDFDFDF),
                                  width: 1.5

                                )



                              ),
                              child: Container(),
                            ),
                          ),
                        ),
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
      ),
    );
  }
}
