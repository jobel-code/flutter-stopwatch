// inspired by Tensor Programming [https://www.youtube.com/watch?v=tRe8teyf9Nk]

import 'package:flutter/material.dart';
// import 'timer_page.dart';  // from Andrea Bizzotto https://github.com/bizz84/stopwatch-flutter/blob/master/lib/timer_page.dart
//import 'count_down_timer.dart';
//import 'package:stopwatch/egg_timer/egg_timer_main.dart';
import 'station_stopwatch.dart';



void main() => runApp(MaterialApp(
  showPerformanceOverlay: false,
  theme: new ThemeData(
    primarySwatch: Colors.blue,
  ),
  home: MyApp(),
),
);


