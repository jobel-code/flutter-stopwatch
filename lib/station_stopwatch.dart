// Inspired by https://www.youtube.com/watch?v=svxUUz5mi9s&t=2147s

import 'package:flutter/material.dart';
import 'package:fluttery/framing.dart';
import 'dart:math' as math;

final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);


class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..forward();

    _animation = new CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.9, curve: Curves.fastOutSlowIn),
        reverseCurve: Curves.fastOutSlowIn
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


  Widget _buildIndicators(BuildContext context, Widget child) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: new CircularProgressIndicator(value: _animation.value, strokeWidth: 65.0,)
    );

      /*
      Column(
      children: indicators
          .map((Widget c) => new Container(child: c, margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0)))
          .toList(),

    );*/

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
                                )
                              ]
                          ),
                          child: Stack(
                            children: <Widget>[
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
                                    child: Container()
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: GestureDetector(
                                  onTap: _handleTap,
                                  behavior: HitTestBehavior.opaque,
                                  child: new AnimatedBuilder(
                                      animation: _animation,
                                      builder: _buildIndicators
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),


                Expanded(
                  child: Container(),
                ),

            RandomColorBlock(
              width: double.infinity,
              height: 50.0,
            ),
            RandomColorBlock(
              width: double.infinity,
              height: 50.0,
            ), //

                // From Fluttery/framing
              ],
            ),
          ),
        ),
      ),
    );
  }
}




/*

class CirclePainter extends CustomPainter {
  Paint _paint;
  double _fraction;

  CirclePainter(this._fraction) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 40.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;
  }

   @override
  void paint(Canvas canvas, Size size) {
    print('paint $_fraction');

    var rect = Offset(0.0, 0.0) & size;

    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * _fraction, false, _paint);
  }
  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}

*/

/*

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;

  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 40.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }

}
*/