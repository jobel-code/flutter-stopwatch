import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stopwatch/egg_timer_knob.dart';

class EggTimerDial extends StatefulWidget {

  // Parameterized dial
  final Duration currentTime;
  final Duration maxTime; // Tell us how many ticks to draw
  final int ticksPerSection;

  // constructor with defaults
  EggTimerDial({
    this.currentTime = const Duration(minutes: 0),
    this.maxTime = const Duration(minutes: 35),
    this.ticksPerSection = 5,
  });



  @override
  _EggTimerDialState createState() => _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial> {


  _rotationPercent() {
    return widget.currentTime.inSeconds / widget.maxTime.inSeconds;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
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
            // This padding pushes in from the outer circle
            child: Stack(children: <Widget>[
              Container(
                // this padding controls where the ticks will be pushed from the outer circle
                padding: EdgeInsets.all(55.0),

                width: double.infinity,
                height: double.infinity,
                child: CustomPaint(painter: TickPainter(
                  tickCount: widget.maxTime.inMinutes,
                  ticksPerSection: widget.ticksPerSection,
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(65.0),
                child: EggTimerDialKnob(
                  rotationPercent: _rotationPercent(),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class TickPainter extends CustomPainter {
  final LONG_TICK = 14.0;
  final SHORT_TICK = 4.0;

  final tickCount;
  final ticksPerSection;
  final ticksInset;
  final tickPaint;

  final textPainter;
  final textStyle;

  TickPainter({
    this.tickCount = 35,
    this.ticksPerSection = 5,
    this.ticksInset = 0.0,
  })  : tickPaint = Paint(),
        textPainter = TextPainter(
          textAlign: TextAlign.center,
          textDirection:
              TextDirection.ltr, // do not assume that this is set by default.
          // It is not, and will raise an error if not set.
        ),
        textStyle = TextStyle(
          color: Colors.black,
          fontFamily: 'BebasNeue',
          fontSize: 20.0,
        ) {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // moving center of canvas to the center of the circles
    canvas.translate(size.width / 2, size.height / 2);

    // Saving position before rotating canvas.
    canvas.save();

    // radius to draw the offset
    final radius = size.width / 2;

    // Painting short ticks.
    for (var i = 0; i < tickCount; ++i) {
      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;

      canvas.drawLine(
          Offset(0.0, -radius), // minus radius corrects the orientation
          // so the first LONG_TICK goes on top.
          Offset(0.0, -radius - tickLength), // negative goes up
          // plus keeps it on the exterior
          tickPaint);

      // Check if LONG_TICK then paint text
      if (i % ticksPerSection == 0) {
        // Paint text.
        canvas.save();

        canvas.translate(0.0, -(size.width /2) -30.0); // painting text up.
        textPainter.text = TextSpan(
          text: '$i',
          style: textStyle,
        );

        // Layout the text, to figure it out how large the text would be.
        textPainter.layout();


        // Figure out which quadrant the text is in.
        // Note that flutter counts quadrants clockwise, while the cartesian
        // quadrants are counted counterClockWise.
        final tickPercent = i / tickCount; // the percentage around the circle
        var quadrant;

        if (tickPercent < 0.25) {
          quadrant = 1;
        } else if (tickPercent < 0.5) {
          quadrant = 4;
        } else if (tickPercent < 0.75) {
          quadrant = 3;
        } else {
          quadrant = 2;
        }

        // paint text according with the quadrant value
        switch (quadrant) {
          // case 1:
          //  break; We remove this case so it would not rotate unnecessarily.
          case 4:
            canvas.rotate(-pi / 2);

            break;
          case 2:
            // canvas.rotate(pi / 2);
            // break;  without break case 2 would take the same values of case 3.
          case 3:
            canvas.rotate(pi / 2);
            break;

        }

        textPainter.paint(
          canvas,
          // the offset will help to recenter the text, because if it is zero,
          // then all the text is left-aligned with the tick mark.
          // we need to offset the text exactly by half the width of the text.
          Offset(
              -textPainter.width / 2,
              // Now to avoid the text touching the tip of the tick, we offset by
              // half of the text height.
              -textPainter.height / 2),

        );





        canvas.restore();

      }

      canvas.rotate(2 * pi / tickCount);
    }

    // restore after drawing all ticks
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
