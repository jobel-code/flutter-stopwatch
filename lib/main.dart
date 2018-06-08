// inspired by Tensor Programming [https://www.youtube.com/watch?v=tRe8teyf9Nk]

import 'package:flutter/material.dart';
import 'timer_page.dart';  // from Andrea Bizzotto https://github.com/bizz84/stopwatch-flutter/blob/master/lib/timer_page.dart

import 'dart:math' as math;

void main() => runApp(MaterialApp(
  showPerformanceOverlay: false,
  theme: new ThemeData(
    primarySwatch: Colors.blue,
  ),
  home: MyApp(),
));



class MyApp extends StatefulWidget  {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: TimerPage(),
      ),
    );
  }
}
