// Inspired by https://www.youtube.com/watch?v=svxUUz5mi9s&t=2147s

import 'package:flutter/material.dart';
import 'package:fluttery/framing.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:screen/screen.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);
final Color GRADIENT2_TOP = Colors.blue;
final Color GRADIENT2_BOTTOM = Colors.blue;

final GlobalKey<ScaffoldState> _stopWatchScaffoldKey =
    GlobalKey<ScaffoldState>();

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  final Dependencies dependencies = new Dependencies();

  bool _active = false;
  bool _started = false;
  bool _extraTime = false;
  bool _done = false;

  String startTime;

  static const int videoTimeLengthInSeconds = 30;

  bool _keepScreenOn = true;
  final double strokeWidth = 50.0;

  AnimationController _controller;
  Animation<double> _animation;

  initPlatformState() async {
    // Check if the screen is kept on:
    //bool isKeptOn = await Screen.isKeptOn;
    bool keptOn = await Screen.isKeptOn;
    setState(() {
      _keepScreenOn = keptOn;
    });
  }

  void _setStationStateIdle() {
    setState(() {
      _active = false;
      _started = false;
      _extraTime = false;
      _done = false;
    });
  }

  void _restartStation() {
    print('RESTARTING');
    setState(() {
      _controller.reset();
      _controller.stop();
      _setStationStateIdle();
      dependencies.stopwatch.reset();
      dependencies.stopwatch.stop();
    });
  }

  void startStation() {
    _controller.reset();
    _controller.forward();
    dependencies.stopwatch.reset();
    dependencies.stopwatch.start();
    startTime = getTimeUtc();
    //TODO: popup dialog for depth start
    //TODO: Show the time of start
    //TODO: initialize GPS recording.
  }

  void stopAndAddExtraTime() {
    _controller.reset();
    _controller.forward();
    //TODO: popup dialog for depth stop
    //TODO: Show the time of stop
    //TODO: Fix position
    //TODO: continue until xtra time is done and stop GPS recording.
  }

  void setStationDone() {
    setState(() {
      _done = true;
      if (_active) _active = false;
      if (_started) _started = false;
      if (_extraTime) _extraTime = false;
      _controller.stop();
      dependencies.stopwatch.stop();
    });
  }

  void _handleTap() {
    print(
        'before Tap: started: $_started | active: $_active | extraTime: $_extraTime  | done: $_done');
    setState(
      () {
        if (!_done) {
          // Toggle value
          if (!_active) _started = true;
          if (!_active && _started) {
            _active = true;
            startStation();
          } else if (_active &&
              _started &&
              dependencies.stopwatch.elapsed.inSeconds >= 30 && !_extraTime) {
            _extraTime = true;
            stopAndAddExtraTime();
          } else if (_active &&
              _started &&
              dependencies.stopwatch.elapsed.inSeconds < 30) {
            showInSnackBar(
                'Please wait to finish current time before stoping the station.');

          } else if (_active && _extraTime) {
            setStationDone(); }
           else if (_active &&
              _started &&
              dependencies.stopwatch.elapsed.inSeconds >= 30 && _extraTime) {
            setStationDone();
        }
        }
      },
    );
    print(
        'After Tap: started: $_started | active: $_active | extraTime: $_extraTime  | done: $_done');

  }

  @override
  void initState() {
    super.initState();

    Screen.keepOn(_keepScreenOn);

    //initPlatformState();

    _controller = new AnimationController(
      duration: const Duration(seconds: videoTimeLengthInSeconds),
      upperBound: 0.9,
      vsync: this,
    ); //..forward();

    _animation = new CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.9, curve: Curves.linear), // 0.0, 0.9
        reverseCurve: Curves.linear)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed) {
          print('ANIMATION is dismissed!');
          //if (_extraTime) setStationDone();
        } else if (status == AnimationStatus.completed) {
          print('ANIMATION is completed!');

          if (_extraTime) setStationDone();
        } // else if (status == AnimationStatus.forward && _extraTime) setStationDone();
      });

    @override
    void dispose() {
      _controller.stop();
      _controller.dispose();
      super.dispose();
    }
  }


  String getTimeUtc() {
    // String dateSlug ="${startTime.year.toString()}-${startTime.month.toString().padLeft(2,'0')}-${startTime.day.toString().padLeft(2,'0')}";
    String timeUtcString =
        "${DateTime.now().toUtc().hour.toString().padLeft(2,'0')}:"
        " ${DateTime.now().toUtc().minute.toString().padLeft(2,'0')}:"
        "${DateTime.now().toUtc().second.toString().padLeft(2,'0')}";
    return timeUtcString;
  }

  Widget _buildCircularProgressIndicator(BuildContext context, Widget child) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: new CircularProgressIndicator(
          value: _animation.value,
          strokeWidth: strokeWidth,
        ));
  }


  void showInSnackBar(String value) {
    _stopWatchScaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // fontFamily: 'BebasNeue',
          ),
      home: Scaffold(
        key: _stopWatchScaffoldKey,
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
                Container(
                  color: Colors.pink[900],
                  padding: EdgeInsets.all(16.0),
                  height: 150.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.pink[900],
                          child: Center(
                            child: Text(
                              'Station 01',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 80.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: AspectRatio(
                        aspectRatio: 1.0,
                        child: GestureDetector(
                          onTap: _handleTap,
                          onLongPress: _restartStation,
                          child: Stack(
                            children: <Widget>[

                              Container(
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
                                child: Container(),
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                    accentColor: _extraTime || _done
                                        ? Colors.orange
                                        : Colors.blue),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: new AnimatedBuilder(
                                      animation: _animation,
                                      builder: _buildCircularProgressIndicator),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.all(strokeWidth),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              GRADIENT_TOP,
                                              GRADIENT_BOTTOM
                                            ]),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x44000000),
                                            blurRadius: 2.0,
                                            spreadRadius: 1.0,
                                            offset: Offset(0.0, 1.0),
                                          )
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: TimerText(
                                                dependencies: dependencies)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 275.0),
                                child: Center(child: Row( mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.timer, size: 85.0,),

                                    Text(_active || _done? '$startTime': "", style: TextStyle(fontFamily: 'Roboto',
                                        fontSize: 40.0, color: Colors.black, fontWeight: FontWeight.bold), ),

                                  ],
                                )),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),

                SizedBox(
                  height: 25.0,
                ),
                Container(
                  color: Colors.white70,
                  padding: EdgeInsets.all(16.0),
                  height: 100.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.white70,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Depth: ',
                              style: TextStyle(
                                  fontSize: 35.0, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            'start:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50.0,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            'end:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50.0,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;

  ElapsedTime({
    this.hundreds,
    this.seconds,
    this.minutes,
  });
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];
  final TextStyle textStyle = const TextStyle(
      fontSize: 225.0,
      fontFamily: "BebasNeue",
      letterSpacing: 10.0,
      fontWeight: FontWeight.bold);
  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 100;
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});
  final Dependencies dependencies;

  TimerTextState createState() => TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: MinutesAndSeconds(dependencies: dependencies),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '$minutesStr:$secondsStr',
          style: dependencies.textStyle,
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
