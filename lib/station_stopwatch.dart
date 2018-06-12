// Inspired by https://www.youtube.com/watch?v=svxUUz5mi9s&t=2147s

import 'package:flutter/material.dart';
import 'package:fluttery/framing.dart';
import 'dart:math' as math;
import 'package:screen/screen.dart';

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);


class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {

  bool _isKeptOn = true;

  AnimationController _controller;
  Animation<double> _animation;

  initPlatformState() async {

    // Check if the screen is kept on:
    //bool isKeptOn = await Screen.isKeptOn;
    bool keptOn = await Screen.isKeptOn;
    setState((){
      _isKeptOn = keptOn;
    });
  }


  @override
  void initState() {
    super.initState();
    Screen.keepOn(_isKeptOn);

    //initPlatformState();

    _controller = new AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..forward();

    _animation = new CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.9, curve: Curves.linear),
        reverseCurve: Curves.linear
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed)
        _controller.forward();
      else if (status == AnimationStatus.completed)
        _controller.reverse();

    });

    @override
    void dispose() {
      _controller.stop();
      super.dispose();
    }

  }


  void _handleTap() {
    setState(() {
      // valueAnimation.isAnimating is part of our build state
      if (_controller.isAnimating) {
        _controller.stop();
      } else {
        switch (_controller.status) {
          case AnimationStatus.dismissed:
          case AnimationStatus.forward:
            _controller.forward();
            break;
          case AnimationStatus.reverse:
          case AnimationStatus.completed:
            _controller.reverse();
            break;
        }
      }
    });
  }


  Widget _buildCircularProgressIndicator(BuildContext context, Widget child) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: new CircularProgressIndicator(value: _animation.value, strokeWidth: 64.0,)
    );
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
                  colors: [GRADIENT_TOP, GRADIENT_BOTTOM])),
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

                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: GestureDetector(
                                onTap: _handleTap,
                                behavior: HitTestBehavior.translucent,
                                child: new AnimatedBuilder(
                                    animation: _animation,
                                    builder: _buildCircularProgressIndicator
                                ),
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.all(65.0),
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
                                        )
                                      ]
                                  ),
                                  child: Center(
                                    child: Container(
                                      child: Text(
                                        '00:30',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'BebasNeue',
                                          fontSize: 200.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 10.0,
                                        ),
                                      ),
                                    ),
                                  ),

                                ),
                              ),
                            ),



                          ],

                        )),
                  ),
                ),


                //Expanded(
                //  child: Container(),
                //),

/*
            Expanded(
              flex: 1,
              child: Container(
                child: Text(
                  'L2345678',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'BebasNeue',
                    fontSize: 100.0,
                    //fontWeight: FontWeight.bold,
                    //letterSpacing: 10.0,
                  ),
                ),
              ),
            ),

            Center(
              child: Text('L01D13P',
                textAlign: TextAlign.center,
                style: const TextStyle(
                color: Colors.black,
                fontFamily: 'BebasNeue',
                fontSize: 150.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 5.0,
              ),),
            ),
            //Expanded(
            //  child: Container(),
            //), //
*/
                // From Fluttery/framing
              ],
            ),
          ),
        ),
      ),
    );
  }
}


