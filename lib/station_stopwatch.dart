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


class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  final Dependencies dependencies = new Dependencies();

  VideoStationState videoStationState = VideoStationState.ready;

  int _progress = 0;

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

  void _restartStation() {
    print('RESTARTING');
    setState(() {
      videoStationState = VideoStationState.ready;
      _controller.reset();
      _progress = 0;
      dependencies.stopwatch.reset();
    });
  }

  void _incrementProgress() {
    setState(() {
      if (videoStationState != VideoStationState.done) {
        _progress++;
        if (_progress == 1) {
          videoStationState = VideoStationState.startInProgress;
          _controller.forward();
          dependencies.stopwatch.start();
        } else if (_progress == 2) {
          videoStationState = VideoStationState.stopInProgress;
          //_controller.reverse();
          _controller.repeat();
          //_controller.forward();

          //_controller.reverse();
        } else {
          videoStationState = VideoStationState.done;
          _controller.stop();
          _controller.reset();
          //dependencies.stopwatch.stop();
          _progress = 0;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Screen.keepOn(_keepScreenOn);

    //initPlatformState();

    _controller = new AnimationController(
      duration: const Duration(seconds: 30),
      upperBound: 0.9,
      vsync: this,
    ); //..forward();

    _animation = new CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.9, curve: Curves.linear),  // 0.0, 0.9
        reverseCurve: Curves.linear)
      ..addStatusListener((AnimationStatus status) {
        if ((status == AnimationStatus.dismissed) &&  videoStationState == VideoStationState.stopInProgress ) {
          print('ANIMATION is dismissed and Station is DONE!');
          dependencies.stopwatch.stop();
          videoStationState = VideoStationState.done;
          _controller.reset();
        } else if (status == AnimationStatus.completed) {
          if (videoStationState == VideoStationState.startInProgress)
            videoStationState == VideoStationState.stopInProgress;
          else if (videoStationState == VideoStationState.stopInProgress)
            videoStationState == VideoStationState.done;
            //dependencies.stopwatch.stop();
          _controller.stop();

        }

        //videoStationState = VideoStationState.stopInProgress;
        //_controller.reverse();
        //else if (status == AnimationStatus.dismissed &&
        //    videoStationState == VideoStationState.done)

      });

    @override
    void dispose() {
      _controller.stop();
      _controller.dispose();
      super.dispose();
    }
  }

  void _handleTap() {
    print(
        'Before setState: progress: $_progress  controller: ${_controller.status}  value: ${_controller.value} videoStatus: $videoStationState');
    _incrementProgress();

    // uncomment  here
    //if (_controller.status == AnimationStatus.dismissed &&
    //    videoStationState == VideoStationState.done) {
    //  dependencies.stopwatch.stop();
    //}

    print('After setState: progress: $_progress  controller: ${_controller.status}  value: ${_controller.value} videoStatus: $videoStationState');
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

  Color _statusColor(){
    Color c;
    setState(() {
      if (videoStationState != VideoStationState.stopInProgress)
        c = Colors.blueAccent;
      else c=Colors.orange;
      return c;
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // fontFamily: 'BebasNeue',
          ),
      home: Scaffold(
        // Container used to keep the color gradient of the background
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:  [GRADIENT_TOP, GRADIENT_BOTTOM] )),
          child: Center(
            child: Column(
              children: <Widget>[
                RandomColorBlock(
                  width: double.infinity,
                  height: 150.0,
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
                                      colors:[GRADIENT_TOP, GRADIENT_BOTTOM]),
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
                                data: Theme
                                    .of(context)
                                    .copyWith(accentColor: _progress == 2? Colors.orange: Colors.blue),
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

                                        new Expanded(
                                          child: new TimerText(
                                              dependencies: dependencies),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum VideoStationState {
  // approachingStation,
  ready,
  startInProgress,
  stopInProgress,
  done,
  cancelled,
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
    return  Padding(
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


/*
Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: new FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '00:30',
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'BebasNeue',
                                                fontSize: 50.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 10.0,
                                              ),
                                            ),
                                          ),
                                        ),
 */